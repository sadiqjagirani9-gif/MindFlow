import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/features/tasks/data/task_repository.dart';
import 'package:mindflow/features/tasks/domain/task_service.dart';
import 'package:mindflow/features/tasks/presentation/task_provider.dart';
import 'package:mindflow/features/settings/presentation/default_reminder_provider.dart';

enum TaskView { today, all, completed, overdue }

enum TaskSort { time, priority, category }

DateTime? _dateOnlyUtc(DateTime? value) =>
    value == null ? null : DateTime.utc(value.year, value.month, value.day);

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TaskView view = TaskView.today;
  TaskSort sort = TaskSort.time;
  int? priorityFilter;
  int? categoryFilter;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    final categories =
        ref.watch(taskCategoriesProvider).value ?? const <TaskCategory>[];
    final categoryNames = {
      for (final category in categories) category.id: category.name,
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('待办'),
        actions: [
          IconButton(
            tooltip: '新建任务',
            onPressed: () => _openEditor(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败：$error')),
        data: (items) {
          final filtered = _filter(items, categoryNames);
          return Column(
            children: [
              _TaskViews(
                selected: view,
                onChanged: (value) => setState(() => view = value),
              ),
              _TaskFilterBar(
                sort: sort,
                priority: priorityFilter,
                categoryId: categoryFilter,
                categories: categories,
                onSortChanged: (value) => setState(() => sort = value),
                onPriorityChanged: (value) =>
                    setState(() => priorityFilter = value),
                onCategoryChanged: (value) =>
                    setState(() => categoryFilter = value),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? _EmptyTasks(view: view, onCreate: _openEditor)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) => _TaskTile(
                          task: filtered[index],
                          categoryName:
                              categoryNames[filtered[index].categoryId],
                          onToggle: _toggle,
                          onEdit: _openEditor,
                          onDelete: _delete,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: const Text('新任务'),
      ),
    );
  }

  List<TaskRecord> _filter(
    List<TaskRecord> tasks,
    Map<int, String> categoryNames,
  ) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);
    final result = tasks.where((task) {
      if (priorityFilter != null && task.priority != priorityFilter) {
        return false;
      }
      if (categoryFilter != null && task.categoryId != categoryFilter) {
        return false;
      }
      final due = task.dueDate == null
          ? null
          : DateTime(
              task.dueDate!.year,
              task.dueDate!.month,
              task.dueDate!.day,
            );
      return switch (view) {
        TaskView.all => true,
        TaskView.completed => task.isCompleted,
        TaskView.overdue =>
          !task.isCompleted && due != null && due.isBefore(date),
        TaskView.today => !task.isCompleted && (due == null || due == date),
      };
    }).toList();
    result.sort((a, b) {
      switch (sort) {
        case TaskSort.time:
          final byDate = (a.dueDate ?? DateTime(9999)).compareTo(
            b.dueDate ?? DateTime(9999),
          );
          return byDate != 0
              ? byDate
              : (a.dueTime ?? '99:99').compareTo(b.dueTime ?? '99:99');
        case TaskSort.priority:
          return b.priority.compareTo(a.priority);
        case TaskSort.category:
          return (categoryNames[a.categoryId] ?? '').compareTo(
            categoryNames[b.categoryId] ?? '',
          );
      }
    });
    return result;
  }

  Future<void> _toggle(TaskRecord task) async =>
      ref.read(taskServiceProvider).toggleCompleted(task);

  Future<void> _delete(TaskRecord task) async {
    await ref.read(taskServiceProvider).delete(task);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('任务已删除')));
    }
  }

  Future<void> _openEditor([TaskRecord? task]) async {
    final reminders = task == null
        ? const <TaskReminder>[]
        : await ref.read(taskRepositoryProvider).remindersForTask(task.id);
    if (!mounted) return;
    final result = await showModalBottomSheet<TaskDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => TaskEditor(
        task: task,
        reminder: reminders.isEmpty ? null : reminders.first,
      ),
    );
    if (result == null) return;
    if (task == null) {
      try {
        await ref
            .read(taskServiceProvider)
            .create(
              task: TaskRecordsCompanion.insert(
                title: result.title,
                description: drift.Value(result.description),
                dueDate: drift.Value(_dateOnlyUtc(result.dueDate)),
                dueTime: drift.Value(result.dueTime),
                priority: drift.Value(result.priority),
                categoryId: drift.Value(result.categoryId),
              ),
              reminderTime: result.reminderTime,
              repeatRule: result.repeatRule,
            );
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('任务已保存，但提醒未能安排')));
        }
      }
    } else {
      try {
        await ref
            .read(taskServiceProvider)
            .update(
              task: task.copyWith(
                title: result.title,
                description: result.description,
                dueDate: drift.Value(_dateOnlyUtc(result.dueDate)),
                dueTime: drift.Value(result.dueTime),
                priority: result.priority,
                categoryId: drift.Value(result.categoryId),
                repeatRule: result.repeatRule,
              ),
              title: result.title,
              reminderTime: result.reminderTime,
              repeatRule: result.repeatRule,
            );
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('任务已保存，但提醒未能安排')));
        }
      }
    }
  }
}

class _TaskViews extends StatelessWidget {
  const _TaskViews({required this.selected, required this.onChanged});
  final TaskView selected;
  final ValueChanged<TaskView> onChanged;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
    child: SegmentedButton<TaskView>(
      segments: const [
        ButtonSegment(value: TaskView.today, label: Text('今日')),
        ButtonSegment(value: TaskView.all, label: Text('全部')),
        ButtonSegment(value: TaskView.completed, label: Text('已完成')),
        ButtonSegment(value: TaskView.overdue, label: Text('逾期')),
      ],
      selected: {selected},
      onSelectionChanged: (values) => onChanged(values.first),
      showSelectedIcon: false,
    ),
  );
}

class _TaskFilterBar extends StatelessWidget {
  const _TaskFilterBar({
    required this.sort,
    required this.priority,
    required this.categoryId,
    required this.categories,
    required this.onSortChanged,
    required this.onPriorityChanged,
    required this.onCategoryChanged,
  });

  final TaskSort sort;
  final int? priority;
  final int? categoryId;
  final List<TaskCategory> categories;
  final ValueChanged<TaskSort> onSortChanged;
  final ValueChanged<int?> onPriorityChanged;
  final ValueChanged<int?> onCategoryChanged;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
    child: Row(
      children: [
        DropdownButton<TaskSort>(
          value: sort,
          underline: const SizedBox.shrink(),
          items: const [
            DropdownMenuItem(value: TaskSort.time, child: Text('按时间')),
            DropdownMenuItem(value: TaskSort.priority, child: Text('按优先级')),
            DropdownMenuItem(value: TaskSort.category, child: Text('按分类')),
          ],
          onChanged: (value) {
            if (value != null) onSortChanged(value);
          },
        ),
        const SizedBox(width: 12),
        DropdownButton<int?>(
          value: priority,
          underline: const SizedBox.shrink(),
          items: const [
            DropdownMenuItem<int?>(value: null, child: Text('所有优先级')),
            DropdownMenuItem<int?>(value: 2, child: Text('高优先级')),
            DropdownMenuItem<int?>(value: 1, child: Text('中优先级')),
            DropdownMenuItem<int?>(value: 0, child: Text('低优先级')),
          ],
          onChanged: onPriorityChanged,
        ),
        const SizedBox(width: 12),
        DropdownButton<int?>(
          value: categoryId,
          underline: const SizedBox.shrink(),
          items: [
            const DropdownMenuItem<int?>(value: null, child: Text('所有分类')),
            ...categories.map(
              (item) => DropdownMenuItem<int?>(
                value: item.id,
                child: Text(item.name),
              ),
            ),
          ],
          onChanged: onCategoryChanged,
        ),
      ],
    ),
  );
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.categoryName,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });
  final TaskRecord task;
  final String? categoryName;
  final ValueChanged<TaskRecord> onToggle;
  final ValueChanged<TaskRecord> onEdit;
  final ValueChanged<TaskRecord> onDelete;

  @override
  Widget build(BuildContext context) => Card(
    child: Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(task),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).colorScheme.errorContainer,
        child: const Icon(Icons.delete_outline),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggle(task),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: _TaskMeta(task: task, categoryName: categoryName),
        onTap: () => onEdit(task),
      ),
    ),
  );
}

class _TaskMeta extends StatelessWidget {
  const _TaskMeta({required this.task, required this.categoryName});
  final TaskRecord task;
  final String? categoryName;

  @override
  Widget build(BuildContext context) {
    final date = task.dueDate == null
        ? null
        : DateFormat('M月d日').format(task.dueDate!);
    final text = [
      ?date,
      ?task.dueTime,
      ?categoryName,
      '优先级 ${task.priority == 2
          ? '高'
          : task.priority == 1
          ? '中'
          : '低'}',
    ].join(' · ');
    return Text(text.isEmpty ? '无日期' : text);
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks({required this.view, required this.onCreate});
  final TaskView view;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            view == TaskView.overdue ? '没有逾期任务' : '这里还很安静',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            view == TaskView.today ? '创建一个今天要完成的任务吧' : '把下一件重要的事记录下来',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('创建任务'),
          ),
        ],
      ),
    ),
  );
}

class TaskDraft {
  const TaskDraft({
    required this.title,
    required this.description,
    this.dueDate,
    this.dueTime,
    required this.priority,
    this.categoryId,
    this.reminderTime,
    this.repeatRule = 'none',
  });
  final String title;
  final String description;
  final DateTime? dueDate;
  final String? dueTime;
  final int priority;
  final int? categoryId;
  final DateTime? reminderTime;
  final String repeatRule;
}

class TaskEditor extends ConsumerStatefulWidget {
  const TaskEditor({super.key, this.task, this.reminder});
  final TaskRecord? task;
  final TaskReminder? reminder;

  @override
  ConsumerState<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends ConsumerState<TaskEditor> {
  late final TextEditingController title = TextEditingController(
    text: widget.task?.title,
  );
  late final TextEditingController description = TextEditingController(
    text: widget.task?.description,
  );
  DateTime? dueDate;
  TimeOfDay? dueTime;
  DateTime? reminderTime;
  int priority = 1;
  int? categoryId;
  String repeatRule = 'none';
  int customInterval = 2;

  @override
  void initState() {
    super.initState();
    dueDate = widget.task?.dueDate;
    final savedTime = widget.task?.dueTime?.split(':');
    if (savedTime != null && savedTime.length == 2) {
      dueTime = TimeOfDay(
        hour: int.parse(savedTime[0]),
        minute: int.parse(savedTime[1]),
      );
    }
    reminderTime = widget.reminder?.reminderTime;
    repeatRule = widget.task?.repeatRule ?? 'none';
    final interval = RegExp(r'^custom:(\d+)$').firstMatch(repeatRule);
    if (interval != null) {
      customInterval = int.tryParse(interval.group(1)!) ?? 2;
    }
    priority = widget.task?.priority ?? 1;
    categoryId = widget.task?.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        ref.watch(taskCategoriesProvider).value ?? const <TaskCategory>[];
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.task == null ? '新建任务' : '编辑任务',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  tooltip: '关闭',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: title,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '标题',
                hintText: '下一件要做的事',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: description,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: '描述',
                hintText: '可选',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.event_outlined),
                    label: Text(
                      dueDate == null
                          ? '设置日期'
                          : DateFormat('yyyy-MM-dd').format(dueDate!),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDueTime,
                    icon: const Icon(Icons.schedule_outlined),
                    label: Text(
                      dueTime == null ? '设置时间' : dueTime!.format(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: priority,
              decoration: const InputDecoration(labelText: '优先级'),
              items: const [
                DropdownMenuItem(value: 0, child: Text('低')),
                DropdownMenuItem(value: 1, child: Text('中')),
                DropdownMenuItem(value: 2, child: Text('高')),
              ],
              onChanged: (value) => setState(() => priority = value ?? 1),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              initialValue: categoryId,
              decoration: const InputDecoration(labelText: '分类'),
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('未分类')),
                ...categories.map(
                  (category) => DropdownMenuItem<int?>(
                    value: category.id,
                    child: Text(category.name),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => categoryId = value),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue:
                  repeatRule == 'none' ||
                      repeatRule == 'daily' ||
                      repeatRule == 'weekly'
                  ? repeatRule
                  : 'custom',
              decoration: const InputDecoration(labelText: '重复'),
              items: const [
                DropdownMenuItem(value: 'none', child: Text('不重复')),
                DropdownMenuItem(value: 'daily', child: Text('每天')),
                DropdownMenuItem(value: 'weekly', child: Text('每周')),
                DropdownMenuItem(value: 'custom', child: Text('自定义间隔')),
              ],
              onChanged: (value) => setState(() {
                if (value == 'custom') {
                  repeatRule = 'custom:$customInterval';
                } else {
                  repeatRule = value ?? 'none';
                }
              }),
            ),
            if (repeatRule.startsWith('custom:')) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(child: Text('每隔多少天重复')),
                  IconButton(
                    tooltip: '减少间隔',
                    onPressed: customInterval <= 2
                        ? null
                        : () => setState(() {
                            customInterval--;
                            repeatRule = 'custom:$customInterval';
                          }),
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$customInterval 天'),
                  IconButton(
                    tooltip: '增加间隔',
                    onPressed: () => setState(() {
                      customInterval++;
                      repeatRule = 'custom:$customInterval';
                    }),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: reminderTime != null,
              title: const Text('提醒'),
              subtitle: Text(
                reminderTime == null
                    ? '关闭'
                    : DateFormat('M月d日 HH:mm').format(reminderTime!),
              ),
              onChanged: (enabled) {
                if (!enabled) {
                  setState(() => reminderTime = null);
                } else {
                  final baseDate = dueDate ?? DateTime.now();
                  final TimeOfDay baseTime =
                      dueTime ?? ref.read(defaultReminderTimeProvider);
                  setState(
                    () => reminderTime = DateTime(
                      baseDate.year,
                      baseDate.month,
                      baseDate.day,
                      baseTime.hour,
                      baseTime.minute,
                    ),
                  );
                }
              },
            ),
            if (reminderTime != null)
              OutlinedButton.icon(
                onPressed: _pickReminder,
                icon: const Icon(Icons.notifications_outlined),
                label: const Text('更改提醒时间'),
              ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('保存任务'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: dueDate ?? DateTime.now(),
    );
    if (picked != null) setState(() => dueDate = picked);
  }

  Future<void> _pickDueTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: dueTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => dueTime = picked);
  }

  Future<void> _pickReminder() async {
    final initial =
        reminderTime ?? DateTime.now().add(const Duration(hours: 1));
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: initial,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time != null) {
      setState(
        () => reminderTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        ),
      );
    }
  }

  void _submit() {
    final name = title.text.trim();
    if (name.isEmpty) return;
    Navigator.pop(
      context,
      TaskDraft(
        title: name,
        description: description.text.trim(),
        dueDate: dueDate,
        dueTime: dueTime == null
            ? null
            : '${dueTime!.hour.toString().padLeft(2, '0')}:${dueTime!.minute.toString().padLeft(2, '0')}',
        priority: priority,
        categoryId: categoryId,
        reminderTime: reminderTime,
        repeatRule: repeatRule,
      ),
    );
  }
}

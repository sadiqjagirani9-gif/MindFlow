import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindflow/features/diary/data/diary_repository.dart';
import 'package:mindflow/features/knowledge/data/knowledge_repository.dart';
import 'package:mindflow/features/tasks/presentation/task_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final tasks = ref.watch(tasksProvider);
    final projects = ref.watch(knowledgeProjectsProvider);
    final entries = ref.watch(diaryEntriesProvider);
    final todayCount = tasks.valueOrNull
        ?.where(
          (task) =>
              !task.isCompleted &&
              task.dueDate != null &&
              task.dueDate!.year == today.year &&
              task.dueDate!.month == today.month &&
              task.dueDate!.day == today.day,
        )
        .length;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${today.year}年${today.month}月${today.day}日 · 星期${const ['', '一', '二', '三', '四', '五', '六', '日'][today.weekday]}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const Text('你好，今天也保持清醒'),
            ],
          ),
          actions: [
            IconButton(
              tooltip: '设置',
              onPressed: () => context.push('/settings'),
              icon: const Icon(Icons.tune_rounded),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _QuickActions(),
              const SizedBox(height: 24),
              _SectionHeader(
                title: todayCount == null ? '今日待办' : '今日待办 · $todayCount',
                action: '查看全部',
                onTap: () => context.go('/tasks'),
              ),
              tasks.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => const _EmptyPanel(
                  icon: Icons.error_outline,
                  title: '任务暂时无法加载',
                  subtitle: '请稍后重试',
                ),
                data: (items) {
                  final day = DateTime(today.year, today.month, today.day);
                  final todayItems =
                      items
                          .where(
                            (task) =>
                                !task.isCompleted &&
                                task.dueDate != null &&
                                task.dueDate!.year == day.year &&
                                task.dueDate!.month == day.month &&
                                task.dueDate!.day == day.day,
                          )
                          .toList()
                        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
                  if (todayItems.isEmpty) {
                    return const _EmptyPanel(
                      icon: Icons.check_circle_outline,
                      title: '今天还没有任务',
                      subtitle: '把下一件重要的事放进待办清单',
                    );
                  }
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.today_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text('今天 ${todayItems.length} 项'),
                          onTap: () => context.go('/tasks'),
                        ),
                        ...todayItems
                            .take(3)
                            .map(
                              (task) => ListTile(
                                dense: true,
                                leading: const Icon(
                                  Icons.radio_button_unchecked,
                                  size: 20,
                                ),
                                title: Text(
                                  task.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(task.dueTime ?? ''),
                                onTap: () => context.go('/tasks'),
                              ),
                            ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              _SectionHeader(
                title: '知识体系',
                action: '打开知识',
                onTap: () => context.go('/knowledge'),
              ),
              projects.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => const _EmptyPanel(
                  icon: Icons.error_outline,
                  title: '知识项目暂时无法加载',
                  subtitle: '请稍后重试',
                ),
                data: (items) => items.isEmpty
                    ? const _EmptyPanel(
                        icon: Icons.account_tree_outlined,
                        title: '从一个主题开始',
                        subtitle: '建立属于你的长期认知结构',
                      )
                    : Card(
                        child: Column(
                          children: items
                              .take(3)
                              .map(
                                (project) => ListTile(
                                  leading: const Icon(
                                    Icons.account_tree_outlined,
                                  ),
                                  title: Text(project.title),
                                  subtitle: Text(
                                    project.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () => context.go('/knowledge'),
                                ),
                              )
                              .toList(),
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(
                title: '最近日记',
                action: '打开日记',
                onTap: () => context.go('/diary'),
              ),
              entries.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => const _EmptyPanel(
                  icon: Icons.error_outline,
                  title: '日记暂时无法加载',
                  subtitle: '请稍后重试',
                ),
                data: (items) => items.isEmpty
                    ? const _EmptyPanel(
                        icon: Icons.auto_stories_outlined,
                        title: '给今天留一句话',
                        subtitle: '日记只属于你，不做分析，不做评判',
                      )
                    : Card(
                        child: Column(
                          children: items
                              .take(3)
                              .map(
                                (entry) => ListTile(
                                  leading: const Icon(Icons.menu_book_outlined),
                                  title: Text(
                                    entry.title.isEmpty
                                        ? DateFormat('M月d日')
                                              .format(entry.diaryDate)
                                        : entry.title,
                                  ),
                                  subtitle: Text(
                                    entry.content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () => context.go('/diary'),
                                ),
                              )
                              .toList(),
                        ),
                      ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _ActionTile(
          icon: Icons.add_task_rounded,
          label: '新建待办',
          onTap: () => context.go('/tasks'),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _ActionTile(
          icon: Icons.edit_note_rounded,
          label: '写日记',
          onTap: () => context.go('/diary'),
        ),
      ),
    ],
  );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [Icon(icon), const SizedBox(width: 10), Text(label)],
        ),
      ),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onTap,
  });
  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
      TextButton(onPressed: onTap, child: Text(action)),
    ],
  );
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

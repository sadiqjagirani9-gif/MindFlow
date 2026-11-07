import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindflow/core/services/notification_service.dart';
import 'package:mindflow/features/knowledge/presentation/knowledge_ai_settings_dialog.dart';
import 'package:mindflow/features/tasks/data/task_repository.dart';
import 'package:mindflow/features/tasks/presentation/task_provider.dart';
import 'package:mindflow/features/settings/presentation/data_management_section.dart';
import 'package:mindflow/features/settings/presentation/default_reminder_provider.dart';
import 'package:mindflow/features/settings/presentation/theme_mode_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final defaultReminder = ref.watch(defaultReminderTimeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('外观', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.brightness_auto_outlined),
                label: Text('系统'),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode_outlined),
                label: Text('浅色'),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode_outlined),
                label: Text('深色'),
              ),
            ],
            selected: {mode},
            showSelectedIcon: false,
            onSelectionChanged: (values) =>
                ref.read(themeModeProvider.notifier).setMode(values.first),
          ),
          const SizedBox(height: 24),
          Text('知识体系 AI', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_awesome_outlined),
              title: const Text('OpenAI 兼容 API'),
              subtitle: const Text('仅用于知识体系生成与辅助编辑'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showKnowledgeAiSettingsDialog(context, ref),
            ),
          ),
          const SizedBox(height: 24),
          Text('提醒', style: Theme.of(context).textTheme.titleMedium),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.schedule_outlined),
                  title: const Text('默认提醒时间'),
                  subtitle: Text(defaultReminder.format(context)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: defaultReminder,
                    );
                    if (picked != null) {
                      await ref
                          .read(defaultReminderTimeProvider.notifier)
                          .setTime(picked);
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_active_outlined),
                  title: const Text('本地通知权限'),
                  subtitle: const Text('管理任务提醒和精确闹钟权限'),
                  trailing: IconButton(
                    tooltip: '请求通知权限',
                    onPressed: () async {
                      final allowed = await NotificationService.instance
                          .requestPermissions();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(allowed ? '通知权限已启用' : '请在系统设置中允许通知'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('任务分类', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                tooltip: '添加分类',
                onPressed: () => _addCategory(context, ref),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const _CategoryList(),
          const SizedBox(height: 24),
          const DataManagementSection(),
          const SizedBox(height: 24),
          Text('关于', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.auto_awesome),
              title: Text('MindFlow 知序'),
              subtitle: Text('版本 1.0.0+1\n本地优先的个人效率与知识管理'),
              isThreeLine: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addCategory(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('新建分类'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 24,
          decoration: const InputDecoration(labelText: '名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('添加'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    try {
      await ref.read(taskRepositoryProvider).addCategory(name, 0xFF6D8F7D);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('分类名称已存在')));
      }
    }
  }
}

class _CategoryList extends ConsumerWidget {
  const _CategoryList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(taskCategoriesProvider);
    return categories.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, stack) => Text('分类加载失败：$error'),
      data: (items) => Card(
        child: Column(
          children: items
              .map(
                (category) => ListTile(
                  leading: CircleAvatar(
                    radius: 7,
                    backgroundColor: Color(category.colorValue),
                  ),
                  title: Text(category.name),
                  trailing: IconButton(
                    tooltip: '删除分类',
                    onPressed: () async {
                      await ref
                          .read(taskRepositoryProvider)
                          .deleteCategory(category.id);
                    },
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

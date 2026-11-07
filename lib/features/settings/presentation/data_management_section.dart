// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindflow/core/database/database_provider.dart';
import 'package:mindflow/core/services/data_management_service.dart';
import 'package:mindflow/features/tasks/data/task_repository.dart';
import 'package:mindflow/features/tasks/domain/task_service.dart';

class DataManagementSection extends ConsumerWidget {
  const DataManagementSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('数据管理', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: const Text('导出本地数据'),
              subtitle: const Text('任务、知识、日记、标签和日记图片'),
              onTap: () => _export(context, ref),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.unarchive_outlined),
              title: const Text('导入恢复数据'),
              subtitle: const Text('校验后作为新记录导入，不覆盖现有数据'),
              onTap: () => _import(context, ref),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.storage_outlined),
              title: const Text('查看存储情况'),
              onTap: () => _storage(context, ref),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.delete_forever_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                '清空本地数据',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              subtitle: const Text('主题和 AI 配置不会随业务数据备份导出'),
              onTap: () => _clear(context, ref),
            ),
          ],
        ),
      ),
    ],
  );

  DataManagementService _service(WidgetRef ref) =>
      DataManagementService(ref.read(databaseProvider));

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    _showProgress(context, '正在导出本地数据…');
    try {
      final file = await _service(ref).exportAll();
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('导出完成'),
            content: SelectableText(file.path),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      _error(context, '导出失败：$error');
    }
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final path = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('导入本地备份'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('导入会创建新记录，不会覆盖现有内容。建议先导出当前数据。'),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: '备份文件完整路径'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('校验并导入'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (path == null || path.isEmpty) return;
    _showProgress(context, '正在校验并恢复数据…');
    try {
      final result = await _service(ref).importAll(File(path));
      await ref.read(taskServiceProvider).rescheduleAll();
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('恢复完成'),
            content: Text(
              '新增 ${result.tasks} 个任务、${result.diaries} 篇日记、${result.knowledgeProjects} 个知识体系。',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      _error(context, '导入失败，现有数据未被覆盖：$error');
    }
  }

  Future<void> _storage(BuildContext context, WidgetRef ref) async {
    try {
      final info = await _service(ref).storageInfo();
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('本地存储情况'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _row('任务', '${info.tasks} 项'),
              _row('日记', '${info.diaries} 篇'),
              _row('知识体系', '${info.knowledgeProjects} 个'),
              _row('知识节点', '${info.knowledgeNodes} 个'),
              _row('日记图片', '${info.diaryImages} 张'),
              _row('数据库', _bytes(info.databaseBytes)),
              _row('图片文件', _bytes(info.imageBytes)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
            ),
          ],
        ),
      );
    } catch (error) {
      _error(context, '读取存储情况失败：$error');
    }
  }

  Future<void> _clear(BuildContext context, WidgetRef ref) async {
    final first = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空全部本地数据？'),
        content: const Text('任务、知识体系、日记和日记图片将被永久删除。请先导出备份。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('继续'),
          ),
        ],
      ),
    );
    if (first != true || !context.mounted) return;
    final controller = TextEditingController();
    final second = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('二次确认'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: '输入“清空”确认'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, controller.text.trim() == '清空'),
            child: const Text('永久清空'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (second != true) return;
    _showProgress(context, '正在清理本地数据…');
    try {
      await ref.read(taskServiceProvider).cancelAll();
      await _service(ref).clearAll();
      await ref.read(taskRepositoryProvider).seedDefaultCategories();
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('本地业务数据已清空')));
      }
    } catch (error) {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      _error(context, '清空失败：$error');
    }
  }

  void _showProgress(BuildContext context, String text) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 18),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }

  void _error(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text(value)],
    ),
  );

  String _bytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
  }
}

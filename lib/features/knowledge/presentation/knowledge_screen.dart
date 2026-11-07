import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/features/knowledge/data/knowledge_repository.dart';

class KnowledgeScreen extends ConsumerWidget {
  const KnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(knowledgeProjectsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('知识体系'),
        actions: [
          IconButton(
            tooltip: '新建项目',
            onPressed: () => _createProject(context, ref),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: projects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('知识项目加载失败：$error')),
        data: (items) => items.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_tree_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '还没有知识项目',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '创建一个主题，逐步添加概念、原则和应用。',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => _createProject(context, ref),
                        icon: const Icon(Icons.add),
                        label: const Text('新建项目'),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final project = items[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.account_tree_outlined),
                      title: Text(project.title),
                      subtitle: Text(
                        project.description.isEmpty
                            ? '尚无简介'
                            : project.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _openProject(context, project),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: projects.valueOrNull?.isNotEmpty == true
          ? FloatingActionButton.extended(
              onPressed: () => _createProject(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('新项目'),
            )
          : null,
    );
  }

  Future<void> _createProject(BuildContext context, WidgetRef ref) async {
    final title = TextEditingController();
    final description = TextEditingController();
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('新建知识项目'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              autofocus: true,
              maxLength: 80,
              decoration: const InputDecoration(labelText: '主题名称'),
            ),
            TextField(
              controller: description,
              maxLines: 3,
              decoration: const InputDecoration(labelText: '简介'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, (
              title.text.trim(),
              description.text.trim(),
            )),
            child: const Text('创建'),
          ),
        ],
      ),
    );
    title.dispose();
    description.dispose();
    if (result == null || result.$1.isEmpty) return;
    await ref
        .read(knowledgeRepositoryProvider)
        .createProject(result.$1, result.$2);
  }

  Future<void> _openProject(BuildContext context, KnowledgeProject project) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => _ProjectSheet(project: project),
      );
}

class _ProjectSheet extends ConsumerWidget {
  const _ProjectSheet({required this.project});
  final KnowledgeProject project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodes = ref.watch(knowledgeNodesProvider(project.id));
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .8,
      child: Column(
        children: [
          ListTile(
            title: Text(
              project.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: project.description.isEmpty
                ? null
                : Text(project.description),
            trailing: IconButton(
              tooltip: '添加知识节点',
              onPressed: () => _editNode(context, ref),
              icon: const Icon(Icons.add),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: nodes.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('节点加载失败：$error')),
              data: (items) => items.isEmpty
                  ? Center(
                      child: OutlinedButton.icon(
                        onPressed: () => _editNode(context, ref),
                        icon: const Icon(Icons.add),
                        label: const Text('添加第一个节点'),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final node = items[index];
                        return Card(
                          child: ListTile(
                            title: Text(node.title),
                            subtitle: Text(
                              node.summary.isEmpty ? '暂无摘要' : node.summary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              tooltip: '删除节点',
                              onPressed: () => ref
                                  .read(knowledgeRepositoryProvider)
                                  .deleteNode(node.id, includeChildren: true),
                              icon: const Icon(Icons.delete_outline),
                            ),
                            onTap: () => _editNode(context, ref, node),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editNode(
    BuildContext context,
    WidgetRef ref, [
    KnowledgeNode? node,
  ]) async {
    final title = TextEditingController(text: node?.title);
    final summary = TextEditingController(text: node?.summary);
    final content = TextEditingController(text: node?.content);
    final result = await showDialog<(String, String, String)>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(node == null ? '新建知识节点' : '编辑知识节点'),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: title,
                  autofocus: true,
                  maxLength: 100,
                  decoration: const InputDecoration(labelText: '标题'),
                ),
                TextField(
                  controller: summary,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: '摘要'),
                ),
                TextField(
                  controller: content,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(labelText: 'Markdown 内容'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, (
              title.text.trim(),
              summary.text.trim(),
              content.text,
            )),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    title.dispose();
    summary.dispose();
    content.dispose();
    if (result == null || result.$1.isEmpty) return;
    final repository = ref.read(knowledgeRepositoryProvider);
    if (node == null) {
      await repository.createNode(project.id, result.$1, result.$2, result.$3);
    } else {
      await repository.updateNode(node, result.$1, result.$2, result.$3);
    }
  }
}

// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:drift/drift.dart' show OrderingMode, OrderingTerm;
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/core/database/database_provider.dart';
import 'package:mindflow/features/knowledge/data/knowledge_ai_settings.dart';
import 'package:mindflow/features/knowledge/data/knowledge_export_service.dart';
import 'package:mindflow/features/knowledge/data/knowledge_graph_export_service.dart';
import 'package:mindflow/features/knowledge/data/knowledge_repository.dart';
import 'package:mindflow/features/knowledge/domain/knowledge_ai_service.dart';
import 'package:mindflow/features/knowledge/domain/knowledge_tree.dart';

class KnowledgeHubScreen extends ConsumerWidget {
  const KnowledgeHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(knowledgeProjectsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('知识体系'),
        actions: [
          IconButton(
            tooltip: 'AI 设置',
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => _configureAi(context, ref),
          ),
          IconButton(
            tooltip: '新建知识体系',
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _create(context, ref),
          ),
        ],
      ),
      body: projects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('知识体系加载失败：$error')),
        data: (items) => items.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_tree_outlined,
                        size: 44,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '从一个主题开始建立知识库',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: () => _create(context, ref),
                        icon: const Icon(Icons.add),
                        label: const Text('新建知识体系'),
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
                  return _ProjectTile(
                    project: project,
                    onTap: () => _open(context, ref, project),
                  );
                },
              ),
      ),
      floatingActionButton: projects.valueOrNull?.isNotEmpty == true
          ? FloatingActionButton(
              onPressed: () => _create(context, ref),
              tooltip: '新建知识体系',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final topic = TextEditingController();
    final scope = TextEditingController();
    final requirements = TextEditingController();
    var depth = '基础';
    var ai = true;
    final result =
        await showDialog<
          ({
            String topic,
            String scope,
            String depth,
            String requirements,
            bool ai,
          })
        >(
          context: context,
          builder: (dialogContext) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text('新建知识体系'),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: topic,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: '研究主题',
                          hintText: '例如：人工智能',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: scope,
                        decoration: const InputDecoration(
                          labelText: '研究范围',
                          hintText: '可留空，由主题决定',
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: depth,
                        decoration: const InputDecoration(labelText: '知识深度'),
                        items: ['基础', '进阶', '深入']
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => depth = value ?? depth),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: requirements,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: '自定义要求'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('使用 AI 生成并展开分支'),
                        value: ai,
                        onChanged: (value) => setState(() => ai = value),
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
                  onPressed: () {
                    if (topic.text.trim().isEmpty) return;
                    Navigator.pop(dialogContext, (
                      topic: topic.text.trim(),
                      scope: scope.text.trim(),
                      depth: depth,
                      requirements: requirements.text.trim(),
                      ai: ai,
                    ));
                  },
                  child: const Text('创建'),
                ),
              ],
            ),
          ),
        );
    topic.dispose();
    scope.dispose();
    requirements.dispose();
    if (result == null) return;
    if (!result.ai) {
      final id = await ref
          .read(knowledgeRepositoryProvider)
          .createProject(result.topic, result.scope);
      await _open(
        context,
        ref,
        KnowledgeProject(
          id: id,
          title: result.topic,
          description: result.scope,
          generationStatus: 'idle',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      return;
    }
    await _generate(
      context,
      ref,
      topic: result.topic,
      scope: result.scope,
      depth: result.depth,
      requirements: result.requirements,
    );
  }

  Future<void> _generate(
    BuildContext context,
    WidgetRef ref, {
    required String topic,
    required String scope,
    required String depth,
    required String requirements,
    int? projectId,
  }) async {
    late final KnowledgeAiService service;
    try {
      service = KnowledgeAiService(
        await ref.read(knowledgeAiSettingsProvider).createProvider(),
        ref.read(knowledgeRepositoryProvider),
      );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('请先完成 AI 配置：$error')));
      }
      return;
    }
    var progress = '正在连接 AI 服务…';
    Object? failure;
    StateSetter? refreshDialog;
    final dialogFuture = showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          refreshDialog = setState;
          return AlertDialog(
            title: const Text('构建知识体系'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LinearProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(progress),
                  if (failure != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        '$failure',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              if (failure != null)
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('关闭'),
                ),
            ],
          );
        },
      ),
    );
    try {
      await service.generateProject(
        topic: topic,
        scope: scope,
        depth: depth,
        requirements: requirements,
        resumeProjectId: projectId,
        onProgress: (value) {
          progress = value;
          refreshDialog?.call(() {});
        },
      );
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    } catch (error) {
      failure = error;
      refreshDialog?.call(() {});
    }
    await dialogFuture;
    refreshDialog = null;
  }

  Future<void> _configureAi(BuildContext context, WidgetRef ref) async {
    final settings = await ref.read(knowledgeAiSettingsProvider).read();
    final url = TextEditingController(text: settings.baseUrl);
    final model = TextEditingController(text: settings.model);
    final key = TextEditingController();
    final tokens = TextEditingController(text: '${settings.maxTokens}');
    var temperature = settings.temperature;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('知识 AI 配置'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: url,
                    decoration: const InputDecoration(
                      labelText: 'API Base URL',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: model,
                    decoration: const InputDecoration(labelText: '模型名称'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: key,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: settings.apiKey == null
                          ? 'API Key'
                          : 'API Key（留空保持不变）',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Temperature'),
                      Expanded(
                        child: Slider(
                          value: temperature,
                          min: 0,
                          max: 1,
                          divisions: 20,
                          label: temperature.toStringAsFixed(2),
                          onChanged: (value) =>
                              setState(() => temperature = value),
                        ),
                      ),
                      Text(temperature.toStringAsFixed(2)),
                    ],
                  ),
                  TextField(
                    controller: tokens,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '最大输出 Token 数',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'API Key 保存在系统安全存储中。客户端应用中的密钥仍有被提取风险。',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(knowledgeAiSettingsProvider)
                      .save(
                        baseUrl: url.text.trim(),
                        model: model.text.trim(),
                        apiKey: key.text.trim(),
                        temperature: temperature,
                        maxTokens: int.parse(tokens.text),
                      );
                  final provider = await ref
                      .read(knowledgeAiSettingsProvider)
                      .createProvider();
                  await provider.generate(
                    'Return only this JSON object: {"connection":"ok"}',
                  );
                  if (dialogContext.mounted) Navigator.pop(dialogContext, true);
                  if (context.mounted)
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('连接测试成功')));
                } catch (error) {
                  if (context.mounted)
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('保存或连接测试失败：$error')));
                }
              },
              child: const Text('保存并测试'),
            ),
          ],
        ),
      ),
    );
    url.dispose();
    model.dispose();
    key.dispose();
    tokens.dispose();
    if (result == true && context.mounted)
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('AI 配置已保存')));
  }

  Future<void> _open(
    BuildContext context,
    WidgetRef ref,
    KnowledgeProject project,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _KnowledgeWorkspace(
        project: project,
        onResume: (id, topic, scope, depth, requirements) => _generate(
          context,
          ref,
          topic: topic,
          scope: scope,
          depth: depth,
          requirements: requirements,
          projectId: id,
        ),
      ),
    );
  }
}

class _ProjectTile extends ConsumerWidget {
  const _ProjectTile({required this.project, required this.onTap});
  final KnowledgeProject project;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Card(
    child: ListTile(
      leading: const Icon(Icons.account_tree_outlined),
      title: Text(project.title),
      subtitle: Text(
        project.description.isEmpty
            ? '知识体系 · ${_decodeStatus(project.generationStatus)['phase'] == 'complete'
                  ? '可持续扩展'
                  : _decodeStatus(project.generationStatus).isEmpty
                  ? '手动编辑'
                  : '生成可恢复'}'
            : project.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) async {
          if (value == 'delete') {
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('删除知识体系？'),
                content: const Text('此操作会删除其中所有节点和关系。'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('取消'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('删除'),
                  ),
                ],
              ),
            );
            if (ok == true)
              await ref
                  .read(knowledgeRepositoryProvider)
                  .deleteProject(project.id);
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'delete', child: Text('删除体系')),
        ],
      ),
      onTap: onTap,
    ),
  );
}

class _KnowledgeWorkspace extends ConsumerStatefulWidget {
  const _KnowledgeWorkspace({required this.project, required this.onResume});
  final KnowledgeProject project;
  final Future<void> Function(int, String, String, String, String) onResume;
  @override
  ConsumerState<_KnowledgeWorkspace> createState() =>
      _KnowledgeWorkspaceState();
}

class _KnowledgeWorkspaceState extends ConsumerState<_KnowledgeWorkspace> {
  final _search = TextEditingController();
  final _graphKey = GlobalKey();
  bool _graph = false;
  String _query = '';
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodesAsync = ref.watch(knowledgeNodesProvider(widget.project.id));
    final nodes = nodesAsync.valueOrNull ?? const <KnowledgeNode>[];
    final relations = ref
        .watch(databaseProvider)
        .select(ref.read(databaseProvider).knowledgeRelations)
        .watch();
    final status = _decodeStatus(widget.project.generationStatus);
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .92,
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.project.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              '${nodes.length} 个节点${status['phase'] == 'complete'
                  ? ' · 可持续扩展'
                  : status['phase'] == null
                  ? ''
                  : ' · ${status['phase']}'}',
            ),
            trailing: PopupMenuButton<String>(
              tooltip: '体系操作',
              onSelected: (value) => _projectAction(value, nodes),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'add', child: Text('新增一级节点')),
                PopupMenuItem(value: 'edit', child: Text('编辑介绍')),
                PopupMenuItem(value: 'undo', child: Text('撤销最近编辑')),
                PopupMenuItem(value: 'history', child: Text('编辑历史')),
                PopupMenuItem(value: 'findings', child: Text('完整性建议')),
                PopupMenuItem(value: 'relations', child: Text('管理关系')),
                PopupMenuItem(value: 'markdown', child: Text('导出 Markdown')),
                PopupMenuItem(value: 'backup', child: Text('本地备份')),
                PopupMenuItem(value: 'restore', child: Text('从本地备份恢复')),
                PopupMenuItem(value: 'graphpng', child: Text('导出图谱 PNG')),
                PopupMenuItem(value: 'resume', child: Text('继续 AI 生成')),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _search,
                    onChanged: (value) =>
                        setState(() => _query = value.trim().toLowerCase()),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: '搜索知识点',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false,
                      icon: Icon(Icons.account_tree_outlined),
                      label: Text('目录'),
                    ),
                    ButtonSegment(
                      value: true,
                      icon: Icon(Icons.hub_outlined),
                      label: Text('图谱'),
                    ),
                  ],
                  selected: {_graph},
                  onSelectionChanged: (value) =>
                      setState(() => _graph = value.first),
                ),
              ],
            ),
          ),
          Expanded(
            child: nodesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('加载失败：$error')),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: FilledButton.icon(
                      onPressed: () => _editNode(null),
                      icon: const Icon(Icons.add),
                      label: const Text('添加第一个知识点'),
                    ),
                  );
                }
                if (!_graph) return _tree(items.take(500).toList());
                return StreamBuilder<List<KnowledgeRelation>>(
                  stream: relations,
                  builder: (context, relationSnapshot) => RepaintBoundary(
                    key: _graphKey,
                    child: _KnowledgeGraph(
                      nodes: _filtered(items),
                      relations: relationSnapshot.data ?? const [],
                      onTap: _showNode,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<KnowledgeNode> _filtered(List<KnowledgeNode> nodes) => _query.isEmpty
      ? nodes.take(500).toList()
      : nodes
            .where(
              (node) =>
                  node.title.toLowerCase().contains(_query) ||
                  node.summary.toLowerCase().contains(_query),
            )
            .take(500)
            .toList();

  Widget _tree(List<KnowledgeNode> nodes) {
    final children = <int?, List<KnowledgeNode>>{};
    for (final node in nodes) {
      children.putIfAbsent(node.parentId, () => []).add(node);
    }
    Widget branch(KnowledgeNode node, int level) {
      final kids = children[node.id] ?? const <KnowledgeNode>[];
      final matches =
          _query.isEmpty ||
          node.title.toLowerCase().contains(_query) ||
          node.summary.toLowerCase().contains(_query) ||
          _hasMatchingDescendant(node.id, children);
      if (!matches) return const SizedBox.shrink();
      return Padding(
        padding: EdgeInsets.only(left: level * 18.0),
        child: ExpansionTile(
          key: PageStorageKey('knowledge-${node.id}'),
          initiallyExpanded: level < 1 || _query.isNotEmpty,
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: EdgeInsets.zero,
          title: Text(node.title),
          subtitle: Text(
            node.summary.isEmpty
                ? '第 ${level + 1} 层 · ${kids.length} 个子节点'
                : '${node.summary}\n第 ${level + 1} 层 · ${kids.length} 个子节点',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            tooltip: '节点操作',
            icon: const Icon(Icons.more_horiz),
            onPressed: () => _nodeMenu(node, nodes),
          ),
          onExpansionChanged: (_) {},
          children: [
            InkWell(
              onTap: () => _showNode(node),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('打开详情'),
                ),
              ),
            ),
            ...kids.map((child) => branch(child, level + 1)),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
      itemCount: (children[null] ?? []).length,
      onReorderItem: (oldIndex, newIndex) async {
        final roots = children[null] ?? [];
        final moved = roots.removeAt(oldIndex);
        roots.insert(newIndex, moved);
        for (var i = 0; i < roots.length; i++) {
          await ref.read(knowledgeRepositoryProvider).reorder(roots[i].id, i);
        }
      },
      itemBuilder: (context, index) {
        final root = (children[null] ?? [])[index];
        return KeyedSubtree(key: ValueKey(root.id), child: branch(root, 0));
      },
    );
  }

  bool _hasMatchingDescendant(
    int id,
    Map<int?, List<KnowledgeNode>> children,
  ) => (children[id] ?? []).any(
    (node) =>
        node.title.toLowerCase().contains(_query) ||
        _hasMatchingDescendant(node.id, children),
  );

  void _showNode(KnowledgeNode node) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _NodeDetail(
      node: node,
      onEdit: () {
        Navigator.pop(context);
        _editNode(node.parentId, node);
      },
    ),
  );

  Future<void> _editNode(int? parentId, [KnowledgeNode? node]) async {
    final result = await showDialog<KnowledgeNodeDraft>(
      context: context,
      builder: (_) => _NodeEditor(
        node: node,
        onAiSuggest: (prompt, old) => _aiSuggestion(prompt, old),
      ),
    );
    if (result == null) return;
    final repository = ref.read(knowledgeRepositoryProvider);
    if (node == null)
      await repository.createManualNode(widget.project.id, parentId, result);
    else
      await repository.updateDetailedNode(node, result);
  }

  Future<String?> _aiSuggestion(String prompt, String old) async {
    try {
      final provider = await ref
          .read(knowledgeAiSettingsProvider)
          .createProvider();
      final proposed = await provider.generate(
        '''针对知识节点，按用户要求改进以下 Markdown 内容。仅返回改进后的 Markdown，不要解释。\n要求：$prompt\n\n原内容：\n$old''',
      );
      if (!mounted) return null;
      final apply = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('AI 修改建议'),
          content: SizedBox(
            width: 520,
            height: 360,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('修改前'),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(old.isEmpty ? '（空）' : old),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('修改后'),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Markdown(data: proposed),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('放弃'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('应用建议'),
            ),
          ],
        ),
      );
      return apply == true ? proposed : null;
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('AI 建议失败：$error')));
      return null;
    }
  }

  Future<void> _nodeMenu(KnowledgeNode node, List<KnowledgeNode> all) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('查看详情'),
              onTap: () => Navigator.pop(context, 'view'),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('编辑'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('添加子节点'),
              onTap: () => Navigator.pop(context, 'child'),
            ),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('复制节点'),
              onTap: () => Navigator.pop(context, 'copy'),
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move_outline),
              title: const Text('移动节点'),
              onTap: () => Navigator.pop(context, 'move'),
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome_outlined),
              title: const Text('AI 扩展此分支'),
              onTap: () => Navigator.pop(context, 'expand'),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_upward),
              title: const Text('上移同级顺序'),
              onTap: () => Navigator.pop(context, 'up'),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_downward),
              title: const Text('下移同级顺序'),
              onTap: () => Navigator.pop(context, 'down'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('删除'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    final repository = ref.read(knowledgeRepositoryProvider);
    if (action == 'view') _showNode(node);
    if (action == 'edit') _editNode(node.parentId, node);
    if (action == 'child') _editNode(node.id);
    if (action == 'copy')
      await repository.createManualNode(
        widget.project.id,
        node.parentId,
        KnowledgeNodeDraft(
          title: '${node.title}（副本）',
          summary: node.summary,
          content: node.content,
          coreConcept: node.coreConcept,
          principle: node.principle,
          mechanism: node.mechanism,
          methods: node.methods,
          application: node.application,
          learningValue: node.learningValue,
        ),
      );
    if (action == 'move') await _moveNode(node, all);
    if (action == 'expand') await _expandBranch(node);
    if (action == 'up') await repository.shiftSibling(node.id, -1);
    if (action == 'down') await repository.shiftSibling(node.id, 1);
    if (action == 'delete') {
      final hasChildren = all.any((item) => item.parentId == node.id);
      final include = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('删除知识节点'),
          content: Text(
            hasChildren
                ? '同时删除所有子节点？选择取消子节点将提升到当前节点的父级。'
                : '确认删除「${node.title}」？',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('保留'),
            ),
            if (hasChildren)
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('仅删除此节点'),
              ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(hasChildren ? '删除节点和子项' : '删除'),
            ),
          ],
        ),
      );
      if (include != null)
        await repository.deleteNode(node.id, includeChildren: include);
    }
  }

  Future<void> _expandBranch(KnowledgeNode node) async {
    try {
      final provider = await ref
          .read(knowledgeAiSettingsProvider)
          .createProvider();
      final response = await provider.generate(
        '''为知识体系「${widget.project.title}」扩展分支「${node.title}」。根据内容自然细分，最多输出 12 个直接子节点，每个节点包含适用的简介、核心概念、原理、机制、方法、应用、学习价值、Markdown 详细介绍和 children。仅返回完整 JSON：{"nodes":[{"title":"...","summary":"...","coreConcept":"...","principle":"...","mechanism":"...","methods":"...","application":"...","learningValue":"...","content":"...","children":[]}]}。避免重复标题和空洞文字。''',
      );
      final start = response.indexOf('{');
      final end = response.lastIndexOf('}');
      if (start < 0 || end <= start) throw const FormatException('AI 未返回 JSON');
      final decoded = jsonDecode(response.substring(start, end + 1));
      if (decoded is! Map || decoded['nodes'] is! List)
        throw const FormatException('缺少 nodes 数组');
      final drafts = (decoded['nodes'] as List)
          .whereType<Map>()
          .map(
            (item) => KnowledgeNodeDraft.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList();
      if (drafts.isEmpty || drafts.any((item) => item.title.isEmpty))
        throw const FormatException('节点标题不能为空');
      final accept = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('AI 分支扩展建议'),
          content: SizedBox(
            width: 440,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text('应用后会新增这些节点；同名节点的内容会被更新。'),
                const SizedBox(height: 8),
                ...drafts.map(
                  (item) => ListTile(
                    dense: true,
                    title: Text(item.title),
                    subtitle: Text(item.summary),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('暂不应用'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('确认应用'),
            ),
          ],
        ),
      );
      if (accept == true)
        await ref
            .read(knowledgeRepositoryProvider)
            .replaceGeneratedChildren(node.id, drafts);
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('分支扩展失败：$error')));
    }
  }

  Future<void> _moveNode(KnowledgeNode node, List<KnowledgeNode> nodes) async {
    final descendants = <int>{node.id};
    bool changed = true;
    while (changed) {
      changed = false;
      for (final item in nodes) {
        if (item.parentId != null &&
            descendants.contains(item.parentId) &&
            descendants.add(item.id))
          changed = true;
      }
    }
    final choices = nodes
        .where((item) => !descendants.contains(item.id))
        .toList();
    final parent = await showDialog<int?>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('移动到'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, -1),
            child: const Text('设为一级节点'),
          ),
          ...choices.map(
            (item) => SimpleDialogOption(
              onPressed: () => Navigator.pop(context, item.id),
              child: Text(item.title),
            ),
          ),
        ],
      ),
    );
    if (parent == -1)
      await ref.read(knowledgeRepositoryProvider).moveNode(node.id, null);
    else if (parent != null)
      await ref.read(knowledgeRepositoryProvider).moveNode(node.id, parent);
  }

  Future<void> _projectAction(String action, List<KnowledgeNode> nodes) async {
    final repository = ref.read(knowledgeRepositoryProvider);
    if (action == 'add') await _editNode(null);
    if (action == 'edit') await _editProject();
    if (action == 'undo') {
      await repository.undoLast(widget.project.id);
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('已撤销最近一次支持的节点编辑')));
    }
    if (action == 'history') await _showHistory();
    if (action == 'findings') await _showFindings();
    if (action == 'relations') await _manageRelations(nodes);
    if (action == 'markdown') await _exportMarkdown(nodes);
    if (action == 'backup') await _backup(nodes);
    if (action == 'restore') await _restoreBackup();
    if (action == 'graphpng') await _exportPng();
    if (action == 'resume') {
      final data = _decodeStatus(widget.project.generationStatus);
      await widget.onResume(
        widget.project.id,
        data['topic'] as String? ?? widget.project.title,
        data['scope'] as String? ?? widget.project.description,
        data['depth'] as String? ?? '进阶',
        data['requirements'] as String? ?? '',
      );
    }
  }

  Future<void> _editProject() async {
    final title = TextEditingController(text: widget.project.title);
    final description = TextEditingController(text: widget.project.description);
    final save = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('知识体系信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: '标题'),
            ),
            TextField(
              controller: description,
              maxLines: 3,
              decoration: const InputDecoration(labelText: '介绍'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (save == true && title.text.trim().isNotEmpty)
      await ref
          .read(knowledgeRepositoryProvider)
          .updateProject(
            widget.project.id,
            title.text.trim(),
            description.text.trim(),
          );
    title.dispose();
    description.dispose();
  }

  Future<void> _showHistory() async {
    final history = await ref
        .read(knowledgeRepositoryProvider)
        .history(widget.project.id);
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SizedBox(
        height: 500,
        child: ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];
            return ListTile(
              title: Text(item.operationType),
              subtitle: Text(item.createdAt.toLocal().toString()),
              trailing: IconButton(
                tooltip: '撤销到修改前',
                icon: const Icon(Icons.undo),
                onPressed: item.beforeData == null
                    ? null
                    : () async {
                        await ref
                            .read(knowledgeRepositoryProvider)
                            .undoLast(widget.project.id);
                        if (context.mounted) Navigator.pop(context);
                      },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showFindings() async {
    final findings = _decodeStatus(widget.project.generationStatus)['findings'];
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('体系检查建议'),
        content: SizedBox(
          width: 440,
          child: findings is List && findings.isNotEmpty
              ? ListView(
                  shrinkWrap: true,
                  children: findings
                      .whereType<String>()
                      .map(
                        (item) => ListTile(
                          leading: const Icon(Icons.lightbulb_outline),
                          title: Text(item),
                        ),
                      )
                      .toList(),
                )
              : const Text('暂无检查建议。知识体系不是绝对完备的，可以继续补充和修订。'),
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

  Future<void> _manageRelations(List<KnowledgeNode> nodes) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final db = ref.read(databaseProvider);
        final ids = nodes.map((node) => node.id).toSet();
        final byId = {for (final node in nodes) node.id: node.title};
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * .72,
          child: Column(
            children: [
              ListTile(
                title: const Text('知识关系'),
                trailing: IconButton(
                  tooltip: '添加关系',
                  icon: const Icon(Icons.add),
                  onPressed: () => _addRelation(nodes),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: StreamBuilder<List<KnowledgeRelation>>(
                  stream:
                      (db.select(db.knowledgeRelations)..orderBy([
                            (row) => OrderingTerm(
                              expression: row.id,
                              mode: OrderingMode.desc,
                            ),
                          ]))
                          .watch(),
                  builder: (context, snapshot) {
                    final rows = (snapshot.data ?? const <KnowledgeRelation>[])
                        .where(
                          (item) =>
                              ids.contains(item.sourceNodeId) &&
                              ids.contains(item.targetNodeId),
                        )
                        .toList();
                    if (rows.isEmpty)
                      return const Center(child: Text('尚无关联关系'));
                    return ListView.builder(
                      itemCount: rows.length,
                      itemBuilder: (context, index) {
                        final item = rows[index];
                        return ListTile(
                          title: Text(
                            '${byId[item.sourceNodeId]} → ${byId[item.targetNodeId]}',
                          ),
                          subtitle: Text(
                            item.relationType == 'prerequisite'
                                ? '前置知识'
                                : '相关知识${item.description.isEmpty ? '' : ' · ${item.description}'}',
                          ),
                          trailing: IconButton(
                            tooltip: '删除关系',
                            icon: const Icon(Icons.link_off),
                            onPressed: () => ref
                                .read(knowledgeRepositoryProvider)
                                .deleteRelation(item.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addRelation(List<KnowledgeNode> nodes) async {
    if (nodes.length < 2) return;
    final source = await _selectNode('选择关系起点', nodes);
    if (source == null) return;
    final target = await _selectNode('选择关系终点', nodes);
    if (target == null || source.id == target.id) return;
    final type = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('关系类型'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'prerequisite'),
            child: const Text('前置知识'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'related'),
            child: const Text('相关知识'),
          ),
        ],
      ),
    );
    if (type != null) {
      await ref
          .read(knowledgeRepositoryProvider)
          .addRelation(source.id, target.id, type, '');
    }
  }

  Future<KnowledgeNode?> _selectNode(String title, List<KnowledgeNode> nodes) =>
      showDialog<KnowledgeNode>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(title),
          children: nodes
              .take(100)
              .map(
                (item) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, item),
                  child: Text(item.title),
                ),
              )
              .toList(),
        ),
      );

  Future<void> _exportMarkdown(List<KnowledgeNode> nodes) async {
    final file = await KnowledgeExportService().exportMarkdown(
      widget.project,
      nodes,
    );
    if (mounted)
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Markdown 已保存：${file.path}')));
  }

  Future<void> _backup(List<KnowledgeNode> nodes) async {
    final relations =
        await (ref
                .read(databaseProvider)
                .select(ref.read(databaseProvider).knowledgeRelations))
            .get();
    final scoped = relations
        .where(
          (item) =>
              nodes.any((node) => node.id == item.sourceNodeId) &&
              nodes.any((node) => node.id == item.targetNodeId),
        )
        .toList();
    final file = await KnowledgeExportService().exportBackup(
      widget.project,
      nodes,
      scoped,
    );
    if (mounted)
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('本地备份已保存：${file.path}')));
  }

  Future<void> _restoreBackup() async {
    final path = TextEditingController();
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('恢复知识备份'),
        content: TextField(
          controller: path,
          decoration: const InputDecoration(
            labelText: '备份文件路径',
            hintText: 'MindFlow 文档目录中的 .mindflow.json 文件',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, path.text.trim()),
            child: const Text('恢复'),
          ),
        ],
      ),
    );
    path.dispose();
    if (selected == null || selected.isEmpty) return;
    try {
      final decoded = jsonDecode(await File(selected).readAsString());
      if (decoded is! Map<String, dynamic>)
        throw const FormatException('备份文件根节点无效');
      final id = await ref
          .read(knowledgeRepositoryProvider)
          .restoreBackup(decoded);
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('已恢复为新的知识体系 #$id')));
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('恢复失败：$error')));
    }
  }

  Future<void> _exportPng() async {
    try {
      setState(() => _graph = true);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final file = await KnowledgeGraphExportService().exportBoundary(
        boundaryKey: _graphKey,
        projectTitle: widget.project.title,
      );
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('图谱 PNG 已保存：${file.path}')));
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('图谱导出失败：$error')));
    }
  }
}

class _NodeDetail extends StatelessWidget {
  const _NodeDetail({required this.node, required this.onEdit});
  final KnowledgeNode node;
  final VoidCallback onEdit;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: MediaQuery.sizeOf(context).height * .86,
    child: Column(
      children: [
        ListTile(
          title: Text(
            node.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(node.summary),
          trailing: IconButton(
            tooltip: '编辑节点',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (final field in [
                ('核心概念', node.coreConcept),
                ('基本原理', node.principle),
                ('关键机制', node.mechanism),
                ('主要方法', node.methods),
                ('实际应用', node.application),
                ('学习价值', node.learningValue),
              ])
                if (field.$2.trim().isNotEmpty) ...[
                  Text(field.$1, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Markdown(data: field.$2),
                  const SizedBox(height: 14),
                ],
              if (node.content.trim().isNotEmpty) Markdown(data: node.content),
            ],
          ),
        ),
      ],
    ),
  );
}

class _NodeEditor extends StatefulWidget {
  const _NodeEditor({required this.node, required this.onAiSuggest});
  final KnowledgeNode? node;
  final Future<String?> Function(String, String) onAiSuggest;
  @override
  State<_NodeEditor> createState() => _NodeEditorState();
}

class _NodeEditorState extends State<_NodeEditor> {
  late final fields = <String, TextEditingController>{
    '标题': TextEditingController(text: widget.node?.title ?? ''),
    '简介': TextEditingController(text: widget.node?.summary ?? ''),
    '核心概念': TextEditingController(text: widget.node?.coreConcept ?? ''),
    '基本原理': TextEditingController(text: widget.node?.principle ?? ''),
    '关键机制': TextEditingController(text: widget.node?.mechanism ?? ''),
    '主要方法': TextEditingController(text: widget.node?.methods ?? ''),
    '实际应用': TextEditingController(text: widget.node?.application ?? ''),
    '学习价值': TextEditingController(text: widget.node?.learningValue ?? ''),
    '详细介绍（Markdown）': TextEditingController(text: widget.node?.content ?? ''),
  };
  @override
  void dispose() {
    for (final field in fields.values) {
      field.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.node == null ? '新建知识节点' : '编辑知识节点'),
    content: SizedBox(
      width: 560,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final entry in fields.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: entry.value,
                  maxLines: entry.key == '标题' ? 1 : 4,
                  minLines: entry.key == '标题' ? 1 : 2,
                  decoration: InputDecoration(labelText: entry.key),
                ),
              ),
            if (widget.node != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () async {
                    final prompt = TextEditingController();
                    final ask = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('AI 辅助编辑'),
                        content: TextField(
                          controller: prompt,
                          decoration: const InputDecoration(labelText: '改进要求'),
                          maxLines: 3,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('取消'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('生成建议'),
                          ),
                        ],
                      ),
                    );
                    if (ask == true) {
                      final suggestion = await widget.onAiSuggest(
                        prompt.text,
                        fields['详细介绍（Markdown）']!.text,
                      );
                      if (suggestion != null)
                        setState(
                          () => fields['详细介绍（Markdown）']!.text = suggestion,
                        );
                    }
                    prompt.dispose();
                  },
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: const Text('生成介绍修改建议'),
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('取消'),
      ),
      FilledButton(
        onPressed: () {
          final title = fields['标题']!.text.trim();
          if (title.isEmpty) return;
          Navigator.pop(
            context,
            KnowledgeNodeDraft(
              title: title,
              summary: fields['简介']!.text,
              coreConcept: fields['核心概念']!.text,
              principle: fields['基本原理']!.text,
              mechanism: fields['关键机制']!.text,
              methods: fields['主要方法']!.text,
              application: fields['实际应用']!.text,
              learningValue: fields['学习价值']!.text,
              content: fields['详细介绍（Markdown）']!.text,
            ),
          );
        },
        child: const Text('保存'),
      ),
    ],
  );
}

class _KnowledgeGraph extends StatelessWidget {
  const _KnowledgeGraph({
    required this.nodes,
    required this.relations,
    required this.onTap,
  });
  final List<KnowledgeNode> nodes;
  final List<KnowledgeRelation> relations;
  final ValueChanged<KnowledgeNode> onTap;
  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) return const Center(child: Text('没有匹配的节点'));
    final byId = {for (final node in nodes) node.id: node};
    final levels = <int, int>{};
    int level(KnowledgeNode node) {
      if (levels.containsKey(node.id)) return levels[node.id]!;
      final parent = byId[node.parentId];
      final result = parent == null ? 0 : level(parent) + 1;
      return levels[node.id] = result;
    }

    for (final node in nodes) {
      level(node);
    }
    final grouped = <int, List<KnowledgeNode>>{};
    for (final node in nodes) {
      grouped.putIfAbsent(levels[node.id]!, () => []).add(node);
    }
    final maxLevel = levels.values.reduce((a, b) => a > b ? a : b);
    final height = (nodes.length * 78.0).clamp(460.0, 50000.0);
    final width = ((maxLevel + 1) * 260.0).clamp(700.0, 20000.0);
    final positions = <int, Offset>{};
    for (final entry in grouped.entries) {
      for (var i = 0; i < entry.value.length; i++) {
        positions[entry.value[i].id] = Offset(
          entry.key * 250 + 24,
          i * 76 + 28,
        );
      }
    }
    return InteractiveViewer(
      minScale: .25,
      maxScale: 3.5,
      boundaryMargin: const EdgeInsets.all(160),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(width, height),
              painter: _GraphEdges(
                nodes: nodes,
                relations: relations,
                positions: positions,
              ),
            ),
            for (final node in nodes)
              Positioned(
                left: positions[node.id]!.dx,
                top: positions[node.id]!.dy,
                width: 210,
                height: 58,
                child: Tooltip(
                  message: '${node.title}\n${node.summary}',
                  child: Card(
                    child: InkWell(
                      onTap: () => onTap(node),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Icon(
                              node.parentId == null
                                  ? Icons.folder_outlined
                                  : Icons.circle,
                              size: 15,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                node.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GraphEdges extends CustomPainter {
  _GraphEdges({
    required this.nodes,
    required this.relations,
    required this.positions,
  });
  final List<KnowledgeNode> nodes;
  final List<KnowledgeRelation> relations;
  final Map<int, Offset> positions;
  @override
  void paint(Canvas canvas, Size size) {
    final hierarchy = Paint()
      ..color = const Color(0xFF8A9A91)
      ..strokeWidth = 1.5;
    final prerequisite = Paint()
      ..color = const Color(0xFFCB7855)
      ..strokeWidth = 1.5;
    final related = Paint()
      ..color = const Color(0xFF6487B5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    void edge(int source, int target, Paint paint, {bool curve = false}) {
      final a = positions[source];
      final b = positions[target];
      if (a == null || b == null) return;
      final start = Offset(a.dx + 210, a.dy + 29);
      final end = Offset(b.dx, b.dy + 29);
      if (!curve) {
        canvas.drawLine(start, end, paint);
      } else {
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..cubicTo(
            start.dx + 60,
            start.dy - 70,
            end.dx - 60,
            end.dy - 70,
            end.dx,
            end.dy,
          );
        canvas.drawPath(path, paint);
      }
    }

    for (final node in nodes) {
      if (node.parentId != null) edge(node.parentId!, node.id, hierarchy);
    }
    for (final relation in relations) {
      edge(
        relation.sourceNodeId,
        relation.targetNodeId,
        relation.relationType == 'prerequisite' ? prerequisite : related,
        curve: true,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GraphEdges oldDelegate) =>
      oldDelegate.nodes != nodes || oldDelegate.relations != relations;
}

Map<String, dynamic> _decodeStatus(String value) {
  try {
    final result = jsonDecode(value);
    return result is Map<String, dynamic> ? result : {};
  } on FormatException {
    return {};
  }
}

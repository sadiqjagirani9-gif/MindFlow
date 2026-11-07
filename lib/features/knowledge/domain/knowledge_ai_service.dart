// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:mindflow/features/knowledge/data/knowledge_repository.dart';
import 'package:mindflow/features/knowledge/domain/knowledge_ai_provider.dart';
import 'package:mindflow/features/knowledge/domain/knowledge_tree.dart';

typedef KnowledgeGenerationProgress = void Function(String message);

class KnowledgeAiService {
  const KnowledgeAiService(this.provider, this.repository);

  final KnowledgeAiProvider provider;
  final KnowledgeRepository repository;

  Future<int> generateProject({
    required String topic,
    required String scope,
    required String depth,
    required String requirements,
    KnowledgeGenerationProgress? onProgress,
    int? resumeProjectId,
  }) async {
    final projectId =
        resumeProjectId ?? await repository.createProject(topic, scope);
    final project = await repository.getProject(projectId);
    if (project == null) throw StateError('知识项目不存在');
    final checkpoint = _checkpoint(project.generationStatus);
    final completed =
        (checkpoint['completedBranches'] as List?)
            ?.whereType<String>()
            .toSet() ??
        <String>{};
    final rootNodes = (await repository.getNodes(projectId))
        .where((node) => node.parentId == null)
        .toList();

    try {
      onProgress?.call('阶段 1/7 · 分析主题与总体知识框架');
      final outline = rootNodes.isNotEmpty
          ? rootNodes
                .map(
                  (node) => KnowledgeNodeDraft(
                    title: node.title,
                    summary: node.summary,
                  ),
                )
                .toList()
          : await _retryJsonList(
              _outlinePrompt(topic, scope, depth, requirements),
              'branches',
            );
      if (outline.isEmpty) throw const FormatException('知识框架没有一级分支');
      if (rootNodes.isEmpty) {
        for (var i = 0; i < outline.length; i++) {
          await repository.createNode(
            projectId,
            outline[i].title,
            outline[i].summary,
            '',
            sortOrder: i,
          );
        }
      }
      await _saveCheckpoint(
        projectId,
        'expand',
        completed,
        topic,
        scope,
        depth,
        requirements,
      );

      final currentRoots = (await repository.getNodes(projectId))
          .where((node) => node.parentId == null)
          .toList();
      for (final root in currentRoots) {
        if (completed.contains(root.title)) continue;
        onProgress?.call('阶段 2-4/7 · 展开「${root.title}」并补充节点内容');
        final expansion = await _retryJsonList(
          _branchPrompt(topic, scope, depth, requirements, root.title),
          'nodes',
        );
        await repository.replaceGeneratedChildren(root.id, expansion);
        completed.add(root.title);
        await _saveCheckpoint(
          projectId,
          'expand',
          completed,
          topic,
          scope,
          depth,
          requirements,
        );
      }

      onProgress?.call('阶段 5/7 · 建立前置与相关知识关联');
      await _createRelations(projectId);
      onProgress?.call('阶段 6/7 · 检查层级、重复项和内容完整性');
      final findings = await _checkCompleteness(projectId, topic, scope, depth);
      onProgress?.call('阶段 7/7 · 保存完整结果');
      await repository.setGenerationStatus(
        projectId,
        jsonEncode({
          'phase': 'complete',
          'completedBranches': completed.toList(),
          'findings': findings,
          'updatedAt': DateTime.now().toIso8601String(),
        }),
      );
      return projectId;
    } catch (_) {
      await _saveCheckpoint(
        projectId,
        'failed',
        completed,
        topic,
        scope,
        depth,
        requirements,
      );
      rethrow;
    }
  }

  String _outlinePrompt(
    String topic,
    String scope,
    String depth,
    String requirements,
  ) =>
      '''
分析「$topic」的学科结构。范围：$scope。程度：$depth。额外要求：$requirements。
按该主题自身特点组织知识，不套用固定学科模板。覆盖适用的基础、核心分支、理论/方法/工具/应用、历史或前沿、挑战和交叉联系。仅输出 JSON：{"branches":[{"title":"...","summary":"..."}]}。至少 6 个有区分度的一级分支，避免泛化空话。
''';

  String _branchPrompt(
    String topic,
    String scope,
    String depth,
    String requirements,
    String branch,
  ) =>
      '''
为知识体系「$topic」（范围：$scope，程度：$depth，要求：$requirements）详细展开一级分支「$branch」。请按自然知识深度细分，不要求所有路径相同层数。输出 JSON：{"nodes":[{"title":"...","summary":"...","coreConcept":"...","principle":"...","mechanism":"...","methods":"...","application":"...","learningValue":"...","content":"Markdown 详细说明","children":[同结构子节点]}]}。每支至少 3 个明确知识点；重要主题至少深入三级，子节点字段按需填写、不得用空话填充。避免与分支标题重复。
''';

  Future<List<KnowledgeNodeDraft>> _retryJsonList(
    String prompt,
    String key,
  ) async {
    Object? lastError;
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        final response = await provider.generate(
          attempt == 0
              ? prompt
              : '$prompt\n上次输出未通过 JSON 校验（$lastError）。请缩短内容并严格输出完整有效 JSON。',
        );
        final value = _decodeObject(response);
        final raw = value[key];
        if (raw is! List) throw FormatException('缺少 $key 数组');
        final items = raw
            .whereType<Map>()
            .map(
              (item) => KnowledgeNodeDraft.fromJson(
                item.map((key, value) => MapEntry(key.toString(), value)),
              ),
            )
            .toList(growable: false);
        _validate(items);
        return items;
      } catch (error) {
        lastError = error;
        if (error is KnowledgeAiProviderFailure &&
            error.statusCode != null &&
            error.statusCode! < 500 &&
            error.statusCode != 429)
          rethrow;
      }
    }
    if (lastError is KnowledgeAiProviderFailure) throw lastError;
    throw FormatException('AI 结果重试 3 次仍无效：$lastError');
  }

  Future<void> _createRelations(int projectId) async {
    final nodes = await repository.getNodes(projectId);
    final prompt =
        '''根据以下节点标题建立少量准确关系，只输出 JSON：{"relations":[{"source":"标题","target":"标题","type":"prerequisite|related","description":"关系说明"}]}。不得生成父子层级关系。标题：${nodes.map((node) => node.title).join('、')}''';
    try {
      final data = _decodeObject(await provider.generate(prompt));
      final values = data['relations'];
      if (values is! List) return;
      final byTitle = {for (final node in nodes) node.title: node.id};
      for (final raw in values.whereType<Map>()) {
        final source = byTitle[raw['source']];
        final target = byTitle[raw['target']];
        final type = raw['type'];
        if (source == null ||
            target == null ||
            source == target ||
            (type != 'prerequisite' && type != 'related'))
          continue;
        await repository.addRelation(
          source,
          target,
          type as String,
          raw['description'] is String ? raw['description'] as String : '',
        );
      }
    } on Object {
      // Relationships are optional enrichment; saved branches remain usable.
    }
  }

  Future<List<String>> _checkCompleteness(
    int projectId,
    String topic,
    String scope,
    String depth,
  ) async {
    final nodes = await repository.getNodes(projectId);
    final titles = nodes.map((node) => node.title).toList();
    final duplicates = titles.toSet().length != titles.length;
    final sparse = nodes
        .where((node) => node.summary.length < 12)
        .map((node) => node.title)
        .toList();
    final prompt =
        '''检查「$topic」（范围：$scope，程度：$depth）的知识体系是否有明显分支遗漏、层级断层或重复。当前节点：${titles.join('、')}。输出 JSON：{"findings":["...", ...]}，最多 8 条可行动建议；不要声称绝对完整。''';
    final findings = <String>[];
    if (duplicates) findings.add('检测到重复标题，请在树状目录中核对同层节点。');
    if (sparse.isNotEmpty)
      findings.add('以下节点的简介偏短：${sparse.take(8).join('、')}');
    try {
      final result = _decodeObject(await provider.generate(prompt))['findings'];
      if (result is List) findings.addAll(result.whereType<String>().take(8));
    } on Object {
      findings.add('AI 完整性建议暂不可用，可在恢复网络后重新检查。');
    }
    return findings;
  }

  Future<void> _saveCheckpoint(
    int id,
    String phase,
    Set<String> done,
    String topic,
    String scope,
    String depth,
    String requirements,
  ) => repository.setGenerationStatus(
    id,
    jsonEncode({
      'phase': phase,
      'topic': topic,
      'scope': scope,
      'depth': depth,
      'requirements': requirements,
      'completedBranches': done.toList(),
      'updatedAt': DateTime.now().toIso8601String(),
    }),
  );

  Map<String, dynamic> _checkpoint(String value) {
    try {
      final parsed = jsonDecode(value);
      return parsed is Map<String, dynamic> ? parsed : {};
    } on FormatException {
      return {};
    }
  }

  Map<String, dynamic> _decodeObject(String text) {
    final cleaned = text
        .trim()
        .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
        .replaceFirst(RegExp(r'\s*```$'), '');
    final start = cleaned.indexOf('{');
    final end = cleaned.lastIndexOf('}');
    if (start < 0 || end <= start) throw const FormatException('没有完整 JSON 对象');
    final decoded = jsonDecode(cleaned.substring(start, end + 1));
    if (decoded is! Map<String, dynamic>)
      throw const FormatException('JSON 根节点必须是对象');
    return decoded;
  }

  void _validate(List<KnowledgeNodeDraft> items, [Set<String>? titles]) {
    final seen = titles ?? <String>{};
    for (final item in items) {
      if (item.title.isEmpty) throw const FormatException('知识节点标题不能为空');
      if (!seen.add(item.title.toLowerCase()))
        throw FormatException('重复节点：${item.title}');
      if (item.children.length > 30) throw const FormatException('单节点子项过多');
      _validate(item.children, seen);
    }
  }
}

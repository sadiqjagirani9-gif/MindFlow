import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/features/knowledge/data/knowledge_repository.dart';
import 'package:mindflow/features/knowledge/data/knowledge_export_service.dart';
import 'package:mindflow/features/knowledge/data/knowledge_graph_export_service.dart';
import 'package:mindflow/features/knowledge/data/ai_provider_configuration.dart';
import 'package:mindflow/features/knowledge/data/openai_compatible_knowledge_provider.dart';
import 'package:mindflow/features/knowledge/domain/knowledge_ai_provider.dart';
import 'package:mindflow/features/knowledge/domain/knowledge_ai_service.dart';
import 'package:mindflow/features/knowledge/domain/knowledge_tree.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;
  late KnowledgeRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = KnowledgeRepository(database);
  });
  tearDown(() async => database.close());

  test(
    'persists a multi-level tree, rejects cycles, and moves nodes',
    () async {
      final project = await repository.createProject('人工智能', '研究体系');
      final root = await repository.addChild(project, null, '机器学习');
      final branch = await repository.addChild(project, root, '监督学习');
      final leaf = await repository.addChild(project, branch, '逻辑回归');

      await expectLater(repository.moveNode(root, leaf), throwsStateError);
      await repository.moveNode(leaf, root, sortOrder: 2);
      final nodes = await repository.getNodes(project);
      expect(nodes.singleWhere((node) => node.id == leaf).parentId, root);
      expect(nodes, hasLength(3));
    },
  );

  test('deletes either the full subtree or promotes direct children', () async {
    final project = await repository.createProject('数学', '');
    final root = await repository.addChild(project, null, '代数');
    final child = await repository.addChild(project, root, '线性代数');
    await repository.addChild(project, child, '向量空间');

    await repository.deleteNode(root, includeChildren: false);
    var nodes = await repository.getNodes(project);
    expect(nodes, hasLength(2));
    expect(nodes.singleWhere((node) => node.id == child).parentId, isNull);

    final secondRoot = await repository.addChild(project, null, '几何');
    final secondChild = await repository.addChild(project, secondRoot, '欧氏几何');
    await repository.addChild(project, secondChild, '相似变换');
    await repository.deleteNode(secondRoot, includeChildren: true);
    nodes = await repository.getNodes(project);
    expect(
      nodes.any((node) => node.id == secondRoot || node.id == secondChild),
      isFalse,
    );
  });

  test('edits are recorded and can be undone', () async {
    final project = await repository.createProject('哲学', '');
    final id = await repository.addChild(project, null, '认识论');
    final node = (await repository.getNodes(project)).single;
    await repository.updateDetailedNode(
      node,
      const KnowledgeNodeDraft(
        title: '知识论',
        summary: '修改后简介',
        content: '**新内容**',
      ),
    );
    expect((await repository.getNodes(project)).single.title, '知识论');
    expect(await repository.history(project), hasLength(1));
    await repository.undoLast(project);
    final restored = (await repository.getNodes(project)).single;
    expect(restored.id, id);
    expect(restored.title, '认识论');
    expect(restored.content, '');
  });

  test(
    'undo restores a deleted subtree and removes a newly created node',
    () async {
      final project = await repository.createProject('历史', '');
      final root = await repository.createManualNode(
        project,
        null,
        const KnowledgeNodeDraft(title: '根节点'),
      );
      await repository.createManualNode(
        project,
        root,
        const KnowledgeNodeDraft(title: '子节点'),
      );
      await repository.deleteNode(root, includeChildren: true);
      expect(await repository.getNodes(project), isEmpty);
      await repository.undoLast(project);
      expect(
        (await repository.getNodes(project)).map((node) => node.title).toSet(),
        {'根节点', '子节点'},
      );
      final created = await repository.createManualNode(
        project,
        null,
        const KnowledgeNodeDraft(title: '临时节点'),
      );
      await repository.undoLast(project);
      expect(
        (await repository.getNodes(project)).any((node) => node.id == created),
        isFalse,
      );
    },
  );

  test('renders a nested Markdown export with structured content', () async {
    final project = await repository.createProject('经济学', '研究体系');
    final root = await repository.createDetailedNode(
      project,
      null,
      const KnowledgeNodeDraft(title: '微观经济学', summary: '研究个体决策。'),
    );
    await repository.createDetailedNode(
      project,
      root,
      const KnowledgeNodeDraft(
        title: '供需理论',
        coreConcept: '价格由供给与需求共同影响。',
        content: '## 均衡\n市场的清算状态。',
      ),
    );
    final output = KnowledgeExportService().renderMarkdown(
      (await repository.getProject(project))!,
      await repository.getNodes(project),
    );
    expect(output, contains('# 经济学'));
    expect(output, contains('## 微观经济学'));
    expect(output, contains('### 供需理论'));
    expect(output, contains('**核心概念**'));
  });

  test('restores a local backup with remapped IDs and relationships', () async {
    final backup = {
      'format': 'mindflow-knowledge-v1',
      'project': {'title': '备份体系', 'description': '恢复测试'},
      'nodes': [
        {'id': 10, 'parentId': null, 'title': '根', 'sortOrder': 0},
        {'id': 11, 'parentId': 10, 'title': '子', 'sortOrder': 0},
      ],
      'relations': [
        {
          'sourceNodeId': 10,
          'targetNodeId': 11,
          'relationType': 'prerequisite',
          'description': '先修',
        },
      ],
    };
    final projectId = await repository.restoreBackup(backup);
    final nodes = await repository.getNodes(projectId);
    expect(nodes, hasLength(2));
    expect(
      nodes.singleWhere((item) => item.title == '子').parentId,
      nodes.singleWhere((item) => item.title == '根').id,
    );
    expect(
      await database.select(database.knowledgeRelations).get(),
      hasLength(1),
    );
  });

  test('AI generation resumes from independently saved branches', () async {
    final provider = _MockKnowledgeProvider(failFromCall: 3);
    final service = KnowledgeAiService(provider, repository);
    final progress = <String>[];
    await expectLater(
      service.generateProject(
        topic: '人工智能',
        scope: '核心领域',
        depth: '深入',
        requirements: '',
        onProgress: progress.add,
      ),
      throwsA(isA<KnowledgeAiProviderFailure>()),
    );
    var projects = await database.select(database.knowledgeProjects).get();
    expect(projects, hasLength(1));
    final projectId = projects.single.id;
    var nodes = await repository.getNodes(projectId);
    final firstBranchId = nodes.singleWhere((item) => item.title == '分支 1').id;
    expect(nodes.any((item) => item.parentId == firstBranchId), isTrue);
    expect(progress.any((item) => item.contains('分支 1')), isTrue);

    provider.failFromCall = null;
    await service.generateProject(
      topic: '人工智能',
      scope: '核心领域',
      depth: '深入',
      requirements: '',
      resumeProjectId: projectId,
    );
    nodes = await repository.getNodes(projectId);
    projects = await database.select(database.knowledgeProjects).get();
    expect(projects.single.generationStatus, contains('complete'));
    expect(nodes.where((item) => item.parentId == null), hasLength(6));
    expect(nodes.any((item) => item.title == '深层概念'), isTrue);
    expect(nodes.where((item) => item.title == '概念例项'), hasLength(6));
  });

  test(
    'OpenAI-compatible adapter sends configuration and accepts JSON output',
    () async {
      final adapter = _MockDioAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://mock.invalid/v1/'))
        ..httpClientAdapter = adapter;
      final provider = OpenAiCompatibleKnowledgeProvider(
        configuration: AiProviderConfiguration(
          providerId: 'mock',
          baseUrl: Uri.parse('https://mock.invalid/v1/'),
          model: 'mock-model',
          temperature: 0.2,
          maxOutputTokens: 1234,
        ),
        apiKey: 'mock-secret',
        dio: dio,
      );
      expect(await provider.generate('test prompt'), '{"result":"ok"}');
      expect(adapter.requestPath, '/v1/chat/completions');
      expect(adapter.requestBody, contains('mock-model'));
      expect(adapter.authorization, 'Bearer mock-secret');
    },
  );

  test('large knowledge trees load and stream structural changes', () async {
    final project = await repository.createProject('大型体系', '性能回归');
    await database.batch((batch) {
      batch.insertAll(
        database.knowledgeNodes,
        List.generate(
          1500,
          (index) => KnowledgeNodesCompanion.insert(
            projectId: project,
            title: '节点 $index',
            sortOrder: Value(index),
          ),
        ),
      );
    });
    expect(await repository.getNodes(project), hasLength(1500));
    final stream = (database.select(
      database.knowledgeNodes,
    )..where((row) => row.projectId.equals(project))).watch();
    final changed = Completer<List<KnowledgeNode>>();
    late final StreamSubscription<List<KnowledgeNode>> subscription;
    subscription = stream.listen((items) {
      if (items.length == 1501 && !changed.isCompleted) changed.complete(items);
    });
    await repository.addChild(project, null, '实时同步节点');
    expect(
      await changed.future.timeout(const Duration(seconds: 2)),
      hasLength(1501),
    );
    await subscription.cancel();
  });

  test('PNG graph exporter writes a valid PNG file', () async {
    final directory = await Directory.systemTemp.createTemp('mindflow-graph-');
    addTearDown(() async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            null,
          );
      if (await directory.exists()) await directory.delete(recursive: true);
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => directory.path,
        );
    final file = await KnowledgeGraphExportService().writePngBytes(
      Uint8List.fromList(const [137, 80, 78, 71, 13, 10, 26, 10]),
      projectTitle: '测试图谱',
    );
    final bytes = await file.readAsBytes();
    expect(bytes, [137, 80, 78, 71, 13, 10, 26, 10]);
  });
}

class _MockKnowledgeProvider implements KnowledgeAiProvider {
  _MockKnowledgeProvider({this.failFromCall});
  int? failFromCall;
  int calls = 0;

  @override
  Future<String> generate(String prompt) async {
    calls++;
    if (failFromCall != null && calls >= failFromCall!) {
      throw const KnowledgeAiProviderFailure('模拟网络中断');
    }
    if (prompt.contains('分析「')) {
      return jsonEncode({
        'branches': List.generate(
          6,
          (i) => {
            'title': '分支 ${i + 1}',
            'summary': '这是关于第 ${i + 1} 个领域的知识概览。',
          },
        ),
      });
    }
    if (prompt.contains('一级分支')) {
      return jsonEncode({
        'nodes': [
          {
            'title': '概念例项',
            'summary': '该节点给出足够具体的概念简介。',
            'coreConcept': '核心概念',
            'principle': '运行原理',
            'content': '## 详细内容\n说明原理与适用边界。',
            'children': [
              {
                'title': '深层概念',
                'summary': '更深一层的知识节点说明。',
                'children': [
                  {'title': '专题细节', 'summary': '细化主题内容。'},
                ],
              },
            ],
          },
        ],
      });
    }
    if (prompt.contains('建立少量准确关系')) {
      return jsonEncode({'relations': []});
    }
    return jsonEncode({
      'findings': ['建议由用户继续检查该体系的遗漏。'],
    });
  }
}

class _MockDioAdapter implements HttpClientAdapter {
  String? requestPath;
  String? requestBody;
  String? authorization;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestPath = options.uri.path;
    authorization = options.headers['Authorization'] as String?;
    if (requestStream != null) {
      requestBody = utf8.decode(
        await requestStream.fold<List<int>>(
          <int>[],
          (bytes, chunk) => bytes..addAll(chunk),
        ),
      );
    }
    return ResponseBody.fromString(
      jsonEncode({
        'choices': [
          {
            'finish_reason': 'stop',
            'message': {'content': '{"result":"ok"}'},
          },
        ],
      }),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

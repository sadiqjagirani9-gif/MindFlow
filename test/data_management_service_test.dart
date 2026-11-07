import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/core/services/data_management_service.dart';
import 'package:mindflow/features/diary/data/diary_repository.dart';
import 'package:mindflow/features/knowledge/data/knowledge_repository.dart';
import 'package:mindflow/features/knowledge/domain/knowledge_tree.dart';
import 'package:mindflow/features/tasks/data/task_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  late AppDatabase database;
  late DataManagementService service;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('mindflow-backup-');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => directory.path,
        );
    database = AppDatabase(NativeDatabase.memory());
    service = DataManagementService(database);
  });

  tearDown(() async {
    await database.close();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          null,
        );
    if (await directory.exists()) await directory.delete(recursive: true);
  });

  test(
    'exports and restores all modules without overwriting existing data',
    () async {
      final tasks = TaskRepository(database);
      await tasks.seedDefaultCategories();
      final category = (await tasks.getCategories()).first;
      await tasks.create(
        TaskRecordsCompanion.insert(
          title: '备份任务',
          categoryId: Value(category.id),
        ),
        reminderTime: DateTime.now().add(const Duration(days: 2)),
      );
      final diaries = DiaryRepository(database);
      final diaryId = await diaries.createEntry(
        '备份日记',
        '本地正文',
        DateTime(2026, 11, 6),
      );
      await diaries.setTags(diaryId, ['备份']);
      final knowledge = KnowledgeRepository(database);
      final project = await knowledge.createProject('备份知识', '测试');
      await knowledge.createDetailedNode(
        project,
        null,
        const KnowledgeNodeDraft(title: '根节点', summary: '结构化内容'),
      );

      final file = await service.exportAll();
      expect(await file.exists(), isTrue);
      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      expect(json['format'], 'mindflow-full-backup-v1');
      expect(json.containsKey('apiKey'), isFalse);

      final result = await service.importAll(file);
      expect(result.tasks, 1);
      expect(result.diaries, 1);
      expect(result.knowledgeProjects, 1);
      expect(await tasks.getAllTasks(), hasLength(2));
      expect(await diaries.getAllEntries(), hasLength(2));
      expect(
        await database.select(database.knowledgeProjects).get(),
        hasLength(2),
      );
    },
  );

  test('rejects malformed backups before importing records', () async {
    final file = File('${directory.path}${Platform.pathSeparator}invalid.json');
    await file.writeAsString(jsonEncode({'format': 'other'}));
    await expectLater(service.importAll(file), throwsFormatException);
    expect(await database.select(database.taskRecords).get(), isEmpty);
    expect(await database.select(database.diaryEntries).get(), isEmpty);
  });

  test('clear removes business data and local diary image files', () async {
    final diaries = DiaryRepository(database);
    final diaryId = await diaries.createEntry('删除', '', DateTime.now());
    final image = await diaries.importImageBytes(
      diaryId,
      Uint8List.fromList([1, 2, 3]),
    );
    await KnowledgeRepository(database).createProject('删除知识', '');
    await TaskRepository(database)
        .create(TaskRecordsCompanion.insert(title: '删除任务'));
    await service.clearAll();
    expect(await database.select(database.taskRecords).get(), isEmpty);
    expect(await database.select(database.diaryEntries).get(), isEmpty);
    expect(await database.select(database.knowledgeProjects).get(), isEmpty);
    expect(await File(image.localPath).exists(), isFalse);
  });
}

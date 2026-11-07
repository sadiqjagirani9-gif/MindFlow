import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/core/database/database_provider.dart';
import 'package:mindflow/features/diary/data/diary_repository.dart';
import 'package:mindflow/features/diary/presentation/diary_hub_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory temporaryDirectory;
  late AppDatabase database;
  late DiaryRepository repository;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'mindflow-diary-',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => temporaryDirectory.path,
        );
    database = AppDatabase(NativeDatabase.memory());
    repository = DiaryRepository(database);
  });

  tearDown(() async {
    await database.close();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          null,
        );
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test(
    'creates, edits, searches, and filters diary entries by month',
    () async {
      final id = await repository.createEntry(
        '远足记录',
        '沿着山路走到了湖边。',
        DateTime(2026, 11, 6),
      );
      var entry = (await repository.getAllEntries()).single;
      expect(entry.id, id);
      expect(entry.title.contains('远足'), isTrue);
      await repository.updateEntry(
        entry,
        '周末远足记录',
        '沿着山路走到了湖边，傍晚返回。',
        DateTime(2026, 12, 2),
      );
      entry = (await repository.getAllEntries()).single;
      expect(entry.content, contains('傍晚'));
      expect(await repository.entriesForMonth(DateTime(2026, 11)), isEmpty);
      expect(
        await repository.entriesForMonth(DateTime(2026, 12)),
        hasLength(1),
      );
      expect(diaryWordCount('你好 world\n'), 7);
    },
  );

  test('stores tags and returns matching diary ids', () async {
    final first = await repository.createEntry(
      '阅读',
      '读完一本书',
      DateTime(2026, 11, 1),
    );
    final second = await repository.createEntry(
      '工作',
      '完成代码',
      DateTime(2026, 11, 2),
    );
    await repository.setTags(first, ['阅读', '生活', '阅读']);
    await repository.setTags(second, ['工作']);
    final tags = await database.select(database.diaryTags).get();
    final reading = tags.singleWhere((tag) => tag.name == '阅读');
    expect(await repository.entryIdsForTag(reading.id), {first});
    expect(
      (await repository.tagsForEntry(first)).map((tag) => tag.name).toSet(),
      {'阅读', '生活'},
    );
  });

  test('copies images into app storage and cleans files on deletion', () async {
    final diaryId = await repository.createEntry(
      '图片',
      '',
      DateTime(2026, 11, 3),
    );
    final source = File(
      '${temporaryDirectory.path}${Platform.pathSeparator}source.jpg',
    );
    await source.writeAsBytes([1, 2, 3, 4, 5]);
    final image = await repository.addImage(diaryId, source.path);
    expect(image.localPath, isNot(source.path));
    expect(await File(image.localPath).exists(), isTrue);
    expect(await repository.imagesForEntry(diaryId), hasLength(1));
    await repository.deleteEntry(diaryId);
    expect(await File(image.localPath).exists(), isFalse);
    expect(await repository.imagesForEntry(diaryId), isEmpty);
  });

  test('diary records persist after closing and reopening SQLite', () async {
    await database.close();
    final file = File(
      '${temporaryDirectory.path}${Platform.pathSeparator}persistent.sqlite',
    );
    database = AppDatabase(NativeDatabase(file));
    repository = DiaryRepository(database);
    await repository.createEntry('持久化', '关闭数据库后仍存在', DateTime(2026, 11, 4));
    await database.close();
    database = AppDatabase(NativeDatabase(file));
    repository = DiaryRepository(database);
    final entries = await repository.getAllEntries();
    expect(entries.single.title, '持久化');
  });

  testWidgets('editor auto-saves content before it closes', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: Scaffold(body: DiaryEditor())),
      ),
    );
    await tester.pumpAndSettle();
    final contentField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField && widget.decoration?.hintText == '记录生活和思考…',
    );
    expect(contentField, findsOneWidget);
    await tester.enterText(contentField, '自动保存的正文');
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();
    expect((await repository.getAllEntries()).single.content, '自动保存的正文');
    await tester.tap(find.byTooltip('保存并关闭'));
    await tester.pumpAndSettle();
    expect((await repository.getAllEntries()).single.content, '自动保存的正文');
  });
}

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class DateOnlyConverter extends TypeConverter<DateTime, int> {
  const DateOnlyConverter();

  @override
  DateTime fromSql(int fromDb) =>
      DateTime.utc(fromDb ~/ 10000, (fromDb ~/ 100) % 100, fromDb % 100);

  @override
  int toSql(DateTime value) =>
      value.year * 10000 + value.month * 100 + value.day;
}

class TaskCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get colorValue =>
      integer().withDefault(const Constant(0xFF6D8F7D))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class TaskRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get dueDate =>
      integer().nullable().map(const DateOnlyConverter())();
  TextColumn get dueTime => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(1))();
  TextColumn get repeatRule => text().withDefault(const Constant('none'))();
  IntColumn get previousOccurrenceId => integer().nullable().references(
    TaskRecords,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get categoryId => integer().nullable().references(
    TaskCategories,
    #id,
    onDelete: KeyAction.setNull,
  )();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class TaskReminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId =>
      integer().references(TaskRecords, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get reminderTime => dateTime()();
  TextColumn get repeatRule => text().withDefault(const Constant('none'))();
  IntColumn get notificationId => integer().unique()();
}

class DiaryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get content => text().withDefault(const Constant(''))();
  IntColumn get diaryDate => integer().map(const DateOnlyConverter())();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class DiaryTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class DiaryTagRelations extends Table {
  IntColumn get diaryId =>
      integer().references(DiaryEntries, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(DiaryTags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>> get primaryKey => {diaryId, tagId};
}

class DiaryImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get diaryId =>
      integer().references(DiaryEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get localPath => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class KnowledgeProjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get generationStatus =>
      text().withDefault(const Constant('idle'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class KnowledgeNodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(
    KnowledgeProjects,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get parentId => integer().nullable().references(
    KnowledgeNodes,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get title => text()();
  TextColumn get summary => text().withDefault(const Constant(''))();
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get coreConcept => text().withDefault(const Constant(''))();
  TextColumn get principle => text().withDefault(const Constant(''))();
  TextColumn get mechanism => text().withDefault(const Constant(''))();
  TextColumn get methods => text().withDefault(const Constant(''))();
  TextColumn get application => text().withDefault(const Constant(''))();
  TextColumn get learningValue => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class KnowledgeRelations extends Table {
  IntColumn get id => integer().autoIncrement()();
  @ReferenceName('sourceRelations')
  IntColumn get sourceNodeId =>
      integer().references(KnowledgeNodes, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('targetRelations')
  IntColumn get targetNodeId =>
      integer().references(KnowledgeNodes, #id, onDelete: KeyAction.cascade)();
  TextColumn get relationType => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
}

class KnowledgeEditHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(
    KnowledgeProjects,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get operationType => text()();
  TextColumn get beforeData => text().nullable()();
  TextColumn get afterData => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    TaskCategories,
    TaskRecords,
    TaskReminders,
    DiaryEntries,
    DiaryTags,
    DiaryTagRelations,
    DiaryImages,
    KnowledgeProjects,
    KnowledgeNodes,
    KnowledgeRelations,
    KnowledgeEditHistories,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(taskRecords, taskRecords.repeatRule);
      }
      if (from < 3) {
        await migrator.addColumn(taskRecords, taskRecords.previousOccurrenceId);
      }
      if (from < 4) {
        await customStatement(
          "UPDATE task_records SET due_date = CAST(strftime('%Y%m%d', due_date, 'unixepoch') AS INTEGER) WHERE due_date IS NOT NULL",
        );
        await customStatement(
          "UPDATE diary_entries SET diary_date = CAST(strftime('%Y%m%d', diary_date, 'unixepoch') AS INTEGER)",
        );
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(p.join(directory.path, 'mindflow.sqlite'));
  return NativeDatabase.createInBackground(file);
});

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/core/database/database_provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>(
  (ref) => DiaryRepository(ref.watch(databaseProvider)),
);

final diaryEntriesProvider = StreamProvider<List<DiaryEntry>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.diaryEntries)..orderBy([
        (row) =>
            OrderingTerm(expression: row.diaryDate, mode: OrderingMode.desc),
      ]))
      .watch();
});

final diaryTagsProvider = StreamProvider<List<DiaryTag>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(
    db.diaryTags,
  )..orderBy([(row) => OrderingTerm(expression: row.name)])).watch();
});

final diaryImagesProvider = StreamProvider.family<List<DiaryImage>, int>((
  ref,
  diaryId,
) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.diaryImages)
        ..where((row) => row.diaryId.equals(diaryId))
        ..orderBy([(row) => OrderingTerm(expression: row.createdAt)]))
      .watch();
});

class DiaryRepository {
  const DiaryRepository(this.db);
  final AppDatabase db;

  Future<int> createEntry(String title, String content, DateTime date) => db
      .into(db.diaryEntries)
      .insert(
        DiaryEntriesCompanion.insert(
          title: Value(title),
          content: Value(content),
          diaryDate: _dateOnlyUtc(date),
        ),
      );

  Future<void> updateEntry(
    DiaryEntry entry,
    String title,
    String content,
    DateTime date,
  ) async {
    await (db.update(
      db.diaryEntries,
    )..where((row) => row.id.equals(entry.id))).write(
      DiaryEntriesCompanion(
        title: Value(title),
        content: Value(content),
        diaryDate: Value(_dateOnlyUtc(date)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteEntry(int id) async {
    final images = await imagesForEntry(id);
    await db.transaction(() async {
      await (db.delete(
        db.diaryEntries,
      )..where((row) => row.id.equals(id))).go();
    });
    for (final image in images) {
      final file = File(image.localPath);
      if (await file.exists()) await file.delete();
    }
  }

  Future<DiaryEntry?> getEntry(int id) => (db.select(
    db.diaryEntries,
  )..where((row) => row.id.equals(id))).getSingleOrNull();

  Future<List<DiaryEntry>> getAllEntries() =>
      (db.select(db.diaryEntries)..orderBy([
            (row) => OrderingTerm(
              expression: row.updatedAt,
              mode: OrderingMode.desc,
            ),
          ]))
          .get();

  Future<int> saveDraft({
    int? id,
    required String title,
    required String content,
    required DateTime date,
  }) async {
    if (id == null) return createEntry(title, content, date);
    final entry = await getEntry(id);
    if (entry == null) return createEntry(title, content, date);
    await updateEntry(entry, title, content, date);
    return id;
  }

  Future<List<DiaryTag>> tagsForEntry(int diaryId) async {
    final query = db.select(db.diaryTags).join([
      innerJoin(
        db.diaryTagRelations,
        db.diaryTagRelations.tagId.equalsExp(db.diaryTags.id),
      ),
    ])..where(db.diaryTagRelations.diaryId.equals(diaryId));
    final rows = await query.get();
    return rows.map((row) => row.readTable(db.diaryTags)).toList();
  }

  Future<void> setTags(int diaryId, Iterable<String> names) async {
    final normalized = names
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toSet();
    await db.transaction(() async {
      await (db.delete(
        db.diaryTagRelations,
      )..where((row) => row.diaryId.equals(diaryId))).go();
      for (final name in normalized) {
        await db
            .into(db.diaryTags)
            .insert(
              DiaryTagsCompanion.insert(name: name),
              mode: InsertMode.insertOrIgnore,
            );
        final tag = await (db.select(
          db.diaryTags,
        )..where((row) => row.name.equals(name))).getSingle();
        await db
            .into(db.diaryTagRelations)
            .insert(
              DiaryTagRelationsCompanion.insert(
                diaryId: diaryId,
                tagId: tag.id,
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
      await (db.delete(db.diaryTags)..where(
            (row) => row.id.isNotInQuery(
              db.selectOnly(db.diaryTagRelations)
                ..addColumns([db.diaryTagRelations.tagId]),
            ),
          ))
          .go();
    });
  }

  Future<List<DiaryImage>> imagesForEntry(int diaryId) =>
      (db.select(db.diaryImages)
            ..where((row) => row.diaryId.equals(diaryId))
            ..orderBy([(row) => OrderingTerm(expression: row.createdAt)]))
          .get();

  Future<DiaryImage> addImage(int diaryId, String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) throw StateError('选择的图片不存在');
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory(p.join(documents.path, 'diary_images'));
    await directory.create(recursive: true);
    final extension = p.extension(sourcePath).toLowerCase();
    final destination = File(
      p.join(
        directory.path,
        '${const Uuid().v4()}${extension.isEmpty ? '.jpg' : extension}',
      ),
    );
    await source.copy(destination.path);
    try {
      final id = await db
          .into(db.diaryImages)
          .insert(
            DiaryImagesCompanion.insert(
              diaryId: diaryId,
              localPath: destination.path,
            ),
          );
      return await (db.select(
        db.diaryImages,
      )..where((row) => row.id.equals(id))).getSingle();
    } catch (_) {
      if (await destination.exists()) await destination.delete();
      rethrow;
    }
  }

  Future<DiaryImage> importImageBytes(
    int diaryId,
    Uint8List bytes, {
    String extension = '.jpg',
  }) async {
    if (bytes.isEmpty || bytes.length > 30 * 1024 * 1024) {
      throw const FormatException('日记图片数据为空或超过 30 MB');
    }
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory(p.join(documents.path, 'diary_images'));
    await directory.create(recursive: true);
    final safeExtension = RegExp(r'^\.[a-zA-Z0-9]{1,5}$').hasMatch(extension)
        ? extension.toLowerCase()
        : '.jpg';
    final destination = File(
      p.join(directory.path, '${const Uuid().v4()}$safeExtension'),
    );
    await destination.writeAsBytes(bytes, flush: true);
    try {
      final id = await db
          .into(db.diaryImages)
          .insert(
            DiaryImagesCompanion.insert(
              diaryId: diaryId,
              localPath: destination.path,
            ),
          );
      return await (db.select(
        db.diaryImages,
      )..where((row) => row.id.equals(id))).getSingle();
    } catch (_) {
      if (await destination.exists()) await destination.delete();
      rethrow;
    }
  }

  Future<void> removeImage(DiaryImage image) async {
    await (db.delete(
      db.diaryImages,
    )..where((row) => row.id.equals(image.id))).go();
    final file = File(image.localPath);
    if (await file.exists()) await file.delete();
  }

  Future<List<DiaryEntry>> entriesForMonth(DateTime month) {
    final first = month.year * 10000 + month.month * 100 + 1;
    final endDate = DateTime(month.year, month.month + 1, 0);
    final last = endDate.year * 10000 + endDate.month * 100 + endDate.day;
    return (db.select(db.diaryEntries)
          ..where((row) => row.diaryDate.isBetweenValues(first, last))
          ..orderBy([
            (row) => OrderingTerm(
              expression: row.diaryDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  Future<Set<int>> entryIdsForTag(int tagId) async {
    final rows = await (db.select(
      db.diaryTagRelations,
    )..where((row) => row.tagId.equals(tagId))).get();
    return rows.map((row) => row.diaryId).toSet();
  }

  DateTime _dateOnlyUtc(DateTime value) =>
      DateTime.utc(value.year, value.month, value.day);
}

int diaryWordCount(String content) =>
    content.replaceAll(RegExp(r'\s+'), '').runes.length;

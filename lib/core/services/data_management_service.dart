// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/features/diary/data/diary_repository.dart';
import 'package:mindflow/features/knowledge/data/knowledge_repository.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DataImportResult {
  const DataImportResult({
    required this.tasks,
    required this.diaries,
    required this.knowledgeProjects,
  });
  final int tasks;
  final int diaries;
  final int knowledgeProjects;
}

class DataStorageInfo {
  const DataStorageInfo({
    required this.tasks,
    required this.diaries,
    required this.knowledgeProjects,
    required this.knowledgeNodes,
    required this.diaryImages,
    required this.databaseBytes,
    required this.imageBytes,
  });
  final int tasks;
  final int diaries;
  final int knowledgeProjects;
  final int knowledgeNodes;
  final int diaryImages;
  final int databaseBytes;
  final int imageBytes;
}

class DataManagementService {
  const DataManagementService(this.db);
  final AppDatabase db;

  Future<File> exportAll() async {
    final categories = await db.select(db.taskCategories).get();
    final tasks = await db.select(db.taskRecords).get();
    final reminders = await db.select(db.taskReminders).get();
    final diaries = await db.select(db.diaryEntries).get();
    final tags = await db.select(db.diaryTags).get();
    final tagRelations = await db.select(db.diaryTagRelations).get();
    final images = await db.select(db.diaryImages).get();
    final projects = await db.select(db.knowledgeProjects).get();
    final nodes = await db.select(db.knowledgeNodes).get();
    final relations = await db.select(db.knowledgeRelations).get();
    final imageJson = <Map<String, Object?>>[];
    for (final image in images) {
      final file = File(image.localPath);
      if (!await file.exists()) continue;
      final bytes = await file.readAsBytes();
      imageJson.add({
        'diaryId': image.diaryId,
        'extension': p.extension(image.localPath),
        'base64': base64Encode(bytes),
      });
    }
    final backup = <String, Object?>{
      'format': 'mindflow-full-backup-v1',
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'taskCategories': categories
          .map(
            (item) => {
              'id': item.id,
              'name': item.name,
              'colorValue': item.colorValue,
            },
          )
          .toList(),
      'tasks': tasks
          .map(
            (item) => {
              'id': item.id,
              'title': item.title,
              'description': item.description,
              'dueDate': item.dueDate?.toIso8601String(),
              'dueTime': item.dueTime,
              'priority': item.priority,
              'repeatRule': item.repeatRule,
              'previousOccurrenceId': item.previousOccurrenceId,
              'categoryId': item.categoryId,
              'isCompleted': item.isCompleted,
              'createdAt': item.createdAt.toUtc().toIso8601String(),
              'updatedAt': item.updatedAt.toUtc().toIso8601String(),
            },
          )
          .toList(),
      'taskReminders': reminders
          .map(
            (item) => {
              'taskId': item.taskId,
              'reminderTime': item.reminderTime.toUtc().toIso8601String(),
              'repeatRule': item.repeatRule,
            },
          )
          .toList(),
      'diaries': diaries
          .map(
            (item) => {
              'id': item.id,
              'title': item.title,
              'content': item.content,
              'diaryDate': item.diaryDate.toIso8601String(),
              'createdAt': item.createdAt.toUtc().toIso8601String(),
              'updatedAt': item.updatedAt.toUtc().toIso8601String(),
            },
          )
          .toList(),
      'diaryTags': tags
          .map((item) => {'id': item.id, 'name': item.name})
          .toList(),
      'diaryTagRelations': tagRelations
          .map((item) => {'diaryId': item.diaryId, 'tagId': item.tagId})
          .toList(),
      'diaryImages': imageJson,
      'knowledgeProjects': projects.map((project) {
        final projectNodes = nodes
            .where((node) => node.projectId == project.id)
            .toList();
        final nodeIds = projectNodes.map((node) => node.id).toSet();
        return {
          'format': 'mindflow-knowledge-v1',
          'project': {
            'title': project.title,
            'description': project.description,
          },
          'nodes': projectNodes
              .map(
                (node) => {
                  'id': node.id,
                  'parentId': node.parentId,
                  'title': node.title,
                  'summary': node.summary,
                  'content': node.content,
                  'coreConcept': node.coreConcept,
                  'principle': node.principle,
                  'mechanism': node.mechanism,
                  'methods': node.methods,
                  'application': node.application,
                  'learningValue': node.learningValue,
                  'sortOrder': node.sortOrder,
                },
              )
              .toList(),
          'relations': relations
              .where(
                (item) =>
                    nodeIds.contains(item.sourceNodeId) &&
                    nodeIds.contains(item.targetNodeId),
              )
              .map(
                (item) => {
                  'sourceNodeId': item.sourceNodeId,
                  'targetNodeId': item.targetNodeId,
                  'relationType': item.relationType,
                  'description': item.description,
                },
              )
              .toList(),
        };
      }).toList(),
    };
    final directory = await getApplicationDocumentsDirectory();
    final stamp = DateFormatForFiles.format(DateTime.now());
    final file = File(p.join(directory.path, 'mindflow-backup-$stamp.json'));
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(backup),
      flush: true,
    );
    return file;
  }

  Future<DataImportResult> importAll(File file) async {
    if (!await file.exists()) throw const FormatException('备份文件不存在');
    if (await file.length() > 300 * 1024 * 1024) {
      throw const FormatException('备份文件超过 300 MB');
    }
    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! Map<String, dynamic> ||
        decoded['format'] != 'mindflow-full-backup-v1') {
      throw const FormatException('不是受支持的 MindFlow 完整备份');
    }
    final rawTasks = _list(decoded, 'tasks');
    final rawCategories = _list(decoded, 'taskCategories');
    final rawReminders = _list(decoded, 'taskReminders');
    final rawDiaries = _list(decoded, 'diaries');
    final rawTags = _list(decoded, 'diaryTags');
    final rawTagRelations = _list(decoded, 'diaryTagRelations');
    final rawImages = _list(decoded, 'diaryImages');
    final rawProjects = _list(decoded, 'knowledgeProjects');
    _validateLimits(rawTasks, rawDiaries, rawProjects, rawImages);
    _validateRecords(
      rawTasks: rawTasks,
      rawCategories: rawCategories,
      rawReminders: rawReminders,
      rawDiaries: rawDiaries,
      rawTags: rawTags,
      rawTagRelations: rawTagRelations,
      rawImages: rawImages,
      rawProjects: rawProjects,
    );

    final categoryMap = <int, int>{};
    final taskMap = <int, int>{};
    for (final raw in rawCategories) {
      final oldId = _int(raw, 'id');
      final name = _string(raw, 'name', max: 80);
      final existing = await (db.select(
        db.taskCategories,
      )..where((row) => row.name.equals(name))).getSingleOrNull();
      final id =
          existing?.id ??
          await db
              .into(db.taskCategories)
              .insert(
                TaskCategoriesCompanion.insert(
                  name: name,
                  colorValue: Value(
                    raw['colorValue'] is int
                        ? raw['colorValue'] as int
                        : 0xFF6D8F7D,
                  ),
                ),
              );
      categoryMap[oldId] = id;
    }
    for (final raw in rawTasks) {
      final oldId = _int(raw, 'id');
      final due = _optionalDate(raw['dueDate']);
      final id = await db
          .into(db.taskRecords)
          .insert(
            TaskRecordsCompanion.insert(
              title: _string(raw, 'title', max: 500),
              description: Value(
                _optionalString(raw['description'], max: 100000),
              ),
              dueDate: Value(
                due == null ? null : DateTime.utc(due.year, due.month, due.day),
              ),
              dueTime: Value(_nullableString(raw['dueTime'], max: 5)),
              priority: Value(
                raw['priority'] is int
                    ? (raw['priority'] as int).clamp(0, 2)
                    : 1,
              ),
              repeatRule: Value(
                _optionalString(raw['repeatRule'], max: 40, fallback: 'none'),
              ),
              categoryId: Value(
                raw['categoryId'] is int
                    ? categoryMap[raw['categoryId'] as int]
                    : null,
              ),
              isCompleted: Value(raw['isCompleted'] == true),
            ),
          );
      taskMap[oldId] = id;
    }
    for (final raw in rawTasks) {
      final previous = raw['previousOccurrenceId'];
      if (previous is! int || taskMap[previous] == null) continue;
      final id = taskMap[_int(raw, 'id')]!;
      await (db.update(
        db.taskRecords,
      )..where((row) => row.id.equals(id))).write(
        TaskRecordsCompanion(previousOccurrenceId: Value(taskMap[previous])),
      );
    }
    for (final raw in rawReminders) {
      final taskId = raw['taskId'];
      if (taskId is! int || taskMap[taskId] == null) continue;
      final mapped = taskMap[taskId]!;
      await db
          .into(db.taskReminders)
          .insert(
            TaskRemindersCompanion.insert(
              taskId: mapped,
              reminderTime: _date(raw, 'reminderTime').toLocal(),
              repeatRule: Value(
                _optionalString(raw['repeatRule'], max: 40, fallback: 'none'),
              ),
              notificationId: mapped,
            ),
          );
    }

    final diaryRepository = DiaryRepository(db);
    final diaryMap = <int, int>{};
    final tagNames = <int, String>{};
    for (final raw in rawTags) {
      tagNames[_int(raw, 'id')] = _string(raw, 'name', max: 80);
    }
    for (final raw in rawDiaries) {
      final id = await diaryRepository.createEntry(
        _optionalString(raw['title'], max: 500),
        _optionalString(raw['content'], max: 2000000),
        _date(raw, 'diaryDate'),
      );
      diaryMap[_int(raw, 'id')] = id;
    }
    final tagsByDiary = <int, Set<String>>{};
    for (final raw in rawTagRelations) {
      final diary = raw['diaryId'];
      final tag = raw['tagId'];
      if (diary is int &&
          tag is int &&
          diaryMap[diary] != null &&
          tagNames[tag] != null) {
        tagsByDiary.putIfAbsent(diaryMap[diary]!, () => {}).add(tagNames[tag]!);
      }
    }
    for (final entry in tagsByDiary.entries) {
      await diaryRepository.setTags(entry.key, entry.value);
    }
    for (final raw in rawImages) {
      final oldDiary = raw['diaryId'];
      final encoded = raw['base64'];
      if (oldDiary is! int || diaryMap[oldDiary] == null || encoded is! String)
        continue;
      Uint8List bytes;
      try {
        bytes = base64Decode(encoded);
      } on FormatException {
        throw const FormatException('备份包含无效图片数据');
      }
      await diaryRepository.importImageBytes(
        diaryMap[oldDiary]!,
        bytes,
        extension: _optionalString(raw['extension'], max: 8, fallback: '.jpg'),
      );
    }

    final knowledgeRepository = KnowledgeRepository(db);
    for (final raw in rawProjects) {
      await knowledgeRepository.restoreBackup(raw);
    }
    return DataImportResult(
      tasks: taskMap.length,
      diaries: diaryMap.length,
      knowledgeProjects: rawProjects.length,
    );
  }

  Future<void> clearAll() async {
    final images = await db.select(db.diaryImages).get();
    await db.transaction(() async {
      await db.delete(db.taskRecords).go();
      await db.delete(db.taskCategories).go();
      await db.delete(db.diaryEntries).go();
      await db.delete(db.diaryTags).go();
      await db.delete(db.knowledgeProjects).go();
    });
    for (final image in images) {
      final file = File(image.localPath);
      if (await file.exists()) await file.delete();
    }
  }

  Future<DataStorageInfo> storageInfo() async {
    final documents = await getApplicationDocumentsDirectory();
    final database = File(p.join(documents.path, 'mindflow.sqlite'));
    final images = await db.select(db.diaryImages).get();
    var imageBytes = 0;
    for (final image in images) {
      final file = File(image.localPath);
      if (await file.exists()) imageBytes += await file.length();
    }
    return DataStorageInfo(
      tasks: await db.taskRecords.count().getSingle(),
      diaries: await db.diaryEntries.count().getSingle(),
      knowledgeProjects: await db.knowledgeProjects.count().getSingle(),
      knowledgeNodes: await db.knowledgeNodes.count().getSingle(),
      diaryImages: images.length,
      databaseBytes: await database.exists() ? await database.length() : 0,
      imageBytes: imageBytes,
    );
  }

  List<Map<String, dynamic>> _list(Map<String, dynamic> root, String key) {
    final value = root[key];
    if (value is! List) throw FormatException('备份缺少 $key 数组');
    return value.map((item) {
      if (item is! Map) throw FormatException('$key 包含无效记录');
      return item.map((key, value) => MapEntry(key.toString(), value));
    }).toList();
  }

  void _validateLimits(List tasks, List diaries, List projects, List images) {
    if (tasks.length > 100000 ||
        diaries.length > 100000 ||
        projects.length > 1000 ||
        images.length > 20000) {
      throw const FormatException('备份记录数量超过安全限制');
    }
  }

  void _validateRecords({
    required List<Map<String, dynamic>> rawTasks,
    required List<Map<String, dynamic>> rawCategories,
    required List<Map<String, dynamic>> rawReminders,
    required List<Map<String, dynamic>> rawDiaries,
    required List<Map<String, dynamic>> rawTags,
    required List<Map<String, dynamic>> rawTagRelations,
    required List<Map<String, dynamic>> rawImages,
    required List<Map<String, dynamic>> rawProjects,
  }) {
    final categoryIds = <int>{};
    for (final raw in rawCategories) {
      final id = _int(raw, 'id');
      if (!categoryIds.add(id)) throw const FormatException('任务分类 ID 重复');
      _string(raw, 'name', max: 80);
    }
    final taskIds = <int>{};
    for (final raw in rawTasks) {
      final id = _int(raw, 'id');
      if (!taskIds.add(id)) throw const FormatException('任务 ID 重复');
      _string(raw, 'title', max: 500);
      _optionalString(raw['description'], max: 100000);
      _optionalDate(raw['dueDate']);
      if (raw['categoryId'] is int &&
          !categoryIds.contains(raw['categoryId'])) {
        throw const FormatException('任务引用了不存在的分类');
      }
    }
    for (final raw in rawTasks) {
      if (raw['previousOccurrenceId'] is int &&
          !taskIds.contains(raw['previousOccurrenceId'])) {
        throw const FormatException('重复任务引用无效');
      }
    }
    for (final raw in rawReminders) {
      if (raw['taskId'] is! int || !taskIds.contains(raw['taskId'])) {
        throw const FormatException('提醒引用了不存在的任务');
      }
      _date(raw, 'reminderTime');
    }

    final diaryIds = <int>{};
    for (final raw in rawDiaries) {
      final id = _int(raw, 'id');
      if (!diaryIds.add(id)) throw const FormatException('日记 ID 重复');
      _optionalString(raw['title'], max: 500);
      _optionalString(raw['content'], max: 2000000);
      _date(raw, 'diaryDate');
    }
    final tagIds = <int>{};
    for (final raw in rawTags) {
      final id = _int(raw, 'id');
      if (!tagIds.add(id)) throw const FormatException('标签 ID 重复');
      _string(raw, 'name', max: 80);
    }
    for (final raw in rawTagRelations) {
      if (raw['diaryId'] is! int ||
          !diaryIds.contains(raw['diaryId']) ||
          raw['tagId'] is! int ||
          !tagIds.contains(raw['tagId'])) {
        throw const FormatException('日记标签关系无效');
      }
    }
    var decodedImageBytes = 0;
    for (final raw in rawImages) {
      if (raw['diaryId'] is! int ||
          !diaryIds.contains(raw['diaryId']) ||
          raw['base64'] is! String) {
        throw const FormatException('日记图片记录无效');
      }
      try {
        final bytes = base64Decode(raw['base64'] as String);
        if (bytes.isEmpty || bytes.length > 30 * 1024 * 1024) {
          throw const FormatException('单张日记图片为空或超过 30 MB');
        }
        decodedImageBytes += bytes.length;
      } on FormatException {
        rethrow;
      }
    }
    if (decodedImageBytes > 250 * 1024 * 1024) {
      throw const FormatException('备份图片总量超过 250 MB');
    }

    for (final project in rawProjects) {
      if (project['format'] != 'mindflow-knowledge-v1' ||
          project['project'] is! Map ||
          project['nodes'] is! List ||
          project['relations'] is! List) {
        throw const FormatException('知识体系备份结构无效');
      }
      final projectInfo = project['project'] as Map;
      if (projectInfo['title'] is! String ||
          (projectInfo['title'] as String).trim().isEmpty) {
        throw const FormatException('知识体系标题无效');
      }
      final nodes = (project['nodes'] as List).whereType<Map>().toList();
      if (nodes.length != (project['nodes'] as List).length ||
          nodes.length > 100000) {
        throw const FormatException('知识节点列表无效或过大');
      }
      final ids = <int>{};
      for (final node in nodes) {
        if (node['id'] is! int ||
            !ids.add(node['id'] as int) ||
            node['title'] is! String ||
            (node['title'] as String).trim().isEmpty) {
          throw const FormatException('知识节点 ID 或标题无效');
        }
      }
      for (final node in nodes) {
        if (node['parentId'] is int && !ids.contains(node['parentId'])) {
          throw const FormatException('知识节点父级不存在');
        }
        final visited = <int>{node['id'] as int};
        Object? parent = node['parentId'];
        while (parent is int) {
          if (!visited.add(parent)) throw const FormatException('知识节点存在循环父子关系');
          final matches = nodes.where((candidate) => candidate['id'] == parent);
          if (matches.isEmpty) throw const FormatException('知识节点父级不存在');
          parent = matches.first['parentId'];
        }
      }
      for (final relation in (project['relations'] as List)) {
        if (relation is! Map ||
            relation['sourceNodeId'] is! int ||
            relation['targetNodeId'] is! int ||
            !ids.contains(relation['sourceNodeId']) ||
            !ids.contains(relation['targetNodeId'])) {
          throw const FormatException('知识关系引用无效');
        }
      }
    }
  }

  int _int(Map<String, dynamic> raw, String key) {
    final value = raw[key];
    if (value is! int || value < 0) throw FormatException('$key 必须是有效整数');
    return value;
  }

  String _string(Map<String, dynamic> raw, String key, {required int max}) {
    final value = raw[key];
    if (value is! String || value.trim().isEmpty || value.length > max) {
      throw FormatException('$key 字段无效');
    }
    return value;
  }

  String _optionalString(
    Object? value, {
    required int max,
    String fallback = '',
  }) {
    if (value == null) return fallback;
    if (value is! String || value.length > max)
      throw const FormatException('文本字段无效或过长');
    return value;
  }

  String? _nullableString(Object? value, {required int max}) {
    if (value == null) return null;
    return _optionalString(value, max: max);
  }

  DateTime _date(Map<String, dynamic> raw, String key) {
    final value = raw[key];
    if (value is! String) throw FormatException('$key 日期无效');
    final parsed = DateTime.tryParse(value);
    if (parsed == null) throw FormatException('$key 日期无效');
    return parsed;
  }

  DateTime? _optionalDate(Object? value) {
    if (value == null) return null;
    if (value is! String) throw const FormatException('日期字段无效');
    final parsed = DateTime.tryParse(value);
    if (parsed == null) throw const FormatException('日期字段无效');
    return parsed;
  }
}

abstract final class DateFormatForFiles {
  static String format(DateTime value) =>
      '${value.year}${_two(value.month)}${_two(value.day)}-${_two(value.hour)}${_two(value.minute)}${_two(value.second)}';
  static String _two(int value) => value.toString().padLeft(2, '0');
}

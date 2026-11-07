import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/core/database/database_provider.dart';
import 'package:mindflow/features/knowledge/domain/knowledge_tree.dart';

final knowledgeRepositoryProvider = Provider<KnowledgeRepository>(
  (ref) => KnowledgeRepository(ref.watch(databaseProvider)),
);

final knowledgeProjectsProvider = StreamProvider<List<KnowledgeProject>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.knowledgeProjects)..orderBy([
        (row) =>
            OrderingTerm(expression: row.updatedAt, mode: OrderingMode.desc),
      ]))
      .watch();
});

final knowledgeNodesProvider = StreamProvider.family<List<KnowledgeNode>, int>((
  ref,
  projectId,
) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.knowledgeNodes)
        ..where((row) => row.projectId.equals(projectId))
        ..orderBy([(row) => OrderingTerm(expression: row.sortOrder)]))
      .watch();
});

class KnowledgeRepository {
  const KnowledgeRepository(this.db);
  final AppDatabase db;

  Future<int> createProject(String title, String description) => db
      .into(db.knowledgeProjects)
      .insert(
        KnowledgeProjectsCompanion.insert(
          title: title,
          description: Value(description),
        ),
      );

  Future<KnowledgeProject?> getProject(int id) => (db.select(
    db.knowledgeProjects,
  )..where((row) => row.id.equals(id))).getSingleOrNull();

  Future<List<KnowledgeNode>> getNodes(int projectId) =>
      (db.select(db.knowledgeNodes)
            ..where((row) => row.projectId.equals(projectId))
            ..orderBy([(row) => OrderingTerm(expression: row.sortOrder)]))
          .get();

  Future<void> setGenerationStatus(int id, String status) async {
    await (db.update(
      db.knowledgeProjects,
    )..where((row) => row.id.equals(id))).write(
      KnowledgeProjectsCompanion(
        generationStatus: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateProject(int id, String title, String description) async {
    final before = await getProject(id);
    if (before == null) return;
    await db.transaction(() async {
      await _history(id, 'project.update', _projectJson(before), {
        'id': id,
        'projectId': id,
        'title': title,
        'description': description,
      });
      await (db.update(
        db.knowledgeProjects,
      )..where((row) => row.id.equals(id))).write(
        KnowledgeProjectsCompanion(
          title: Value(title),
          description: Value(description),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<void> deleteProject(int id) async {
    await (db.delete(
      db.knowledgeProjects,
    )..where((row) => row.id.equals(id))).go();
  }

  Future<int> createNode(
    int projectId,
    String title,
    String summary,
    String content, {
    int? parentId,
    int? sortOrder,
  }) => db
      .into(db.knowledgeNodes)
      .insert(
        KnowledgeNodesCompanion.insert(
          projectId: projectId,
          parentId: Value(parentId),
          title: title,
          summary: Value(summary),
          content: Value(content),
          sortOrder: Value(sortOrder ?? 0),
        ),
      );

  Future<int> createDetailedNode(
    int projectId,
    int? parentId,
    KnowledgeNodeDraft draft, {
    int sortOrder = 0,
  }) => db
      .into(db.knowledgeNodes)
      .insert(
        KnowledgeNodesCompanion.insert(
          projectId: projectId,
          parentId: Value(parentId),
          title: draft.title,
          summary: Value(draft.summary),
          content: Value(draft.content),
          coreConcept: Value(draft.coreConcept),
          principle: Value(draft.principle),
          mechanism: Value(draft.mechanism),
          methods: Value(draft.methods),
          application: Value(draft.application),
          learningValue: Value(draft.learningValue),
          sortOrder: Value(sortOrder),
        ),
      );

  Future<int> createManualNode(
    int projectId,
    int? parentId,
    KnowledgeNodeDraft draft,
  ) async {
    return db.transaction(() async {
      final id = await createDetailedNode(projectId, parentId, draft);
      final node = await (db.select(
        db.knowledgeNodes,
      )..where((row) => row.id.equals(id))).getSingle();
      await _history(projectId, 'node.create', null, _nodeJson(node));
      return id;
    });
  }

  Future<void> replaceGeneratedChildren(
    int parentId,
    List<KnowledgeNodeDraft> children,
  ) async {
    final parent = await (db.select(
      db.knowledgeNodes,
    )..where((row) => row.id.equals(parentId))).getSingle();
    await db.transaction(() async {
      final existing = await (db.select(
        db.knowledgeNodes,
      )..where((row) => row.parentId.equals(parentId))).get();
      final byTitle = {
        for (final node in existing) node.title.toLowerCase(): node,
      };
      for (var index = 0; index < children.length; index++) {
        final draft = children[index];
        final current = byTitle[draft.title.toLowerCase()];
        final nodeId =
            current?.id ??
            await createDetailedNode(
              parent.projectId,
              parentId,
              draft,
              sortOrder: index,
            );
        if (current != null) {
          await (db.update(
            db.knowledgeNodes,
          )..where((row) => row.id.equals(current.id))).write(
            KnowledgeNodesCompanion(
              summary: Value(draft.summary),
              content: Value(draft.content),
              coreConcept: Value(draft.coreConcept),
              principle: Value(draft.principle),
              mechanism: Value(draft.mechanism),
              methods: Value(draft.methods),
              application: Value(draft.application),
              learningValue: Value(draft.learningValue),
              sortOrder: Value(index),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
        await _replaceChildren(parent.projectId, nodeId, draft.children);
      }
    });
  }

  Future<void> _replaceChildren(
    int projectId,
    int parentId,
    List<KnowledgeNodeDraft> children,
  ) async {
    final existing = await (db.select(
      db.knowledgeNodes,
    )..where((row) => row.parentId.equals(parentId))).get();
    final byTitle = {
      for (final node in existing) node.title.toLowerCase(): node,
    };
    for (var i = 0; i < children.length; i++) {
      final draft = children[i];
      final current = byTitle[draft.title.toLowerCase()];
      final id =
          current?.id ??
          await createDetailedNode(projectId, parentId, draft, sortOrder: i);
      if (current != null) {
        await (db.update(
          db.knowledgeNodes,
        )..where((row) => row.id.equals(id))).write(
          KnowledgeNodesCompanion(
            summary: Value(draft.summary),
            content: Value(draft.content),
            coreConcept: Value(draft.coreConcept),
            principle: Value(draft.principle),
            mechanism: Value(draft.mechanism),
            methods: Value(draft.methods),
            application: Value(draft.application),
            learningValue: Value(draft.learningValue),
            sortOrder: Value(i),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
      await _replaceChildren(projectId, id, draft.children);
    }
  }

  Future<void> updateNode(
    KnowledgeNode node,
    String title,
    String summary,
    String content,
  ) async {
    final before = await (db.select(
      db.knowledgeNodes,
    )..where((row) => row.id.equals(node.id))).getSingleOrNull();
    if (before == null) return;
    final after = KnowledgeNodesCompanion(
      title: Value(title),
      summary: Value(summary),
      content: Value(content),
      updatedAt: Value(DateTime.now()),
    );
    await db.transaction(() async {
      await _history(node.projectId, 'node.update', _nodeJson(before), {
        'id': node.id,
        'projectId': node.projectId,
        'parentId': node.parentId,
        'title': title,
        'summary': summary,
        'content': content,
      });
      await (db.update(
        db.knowledgeNodes,
      )..where((row) => row.id.equals(node.id))).write(after);
    });
  }

  Future<void> updateDetailedNode(
    KnowledgeNode node,
    KnowledgeNodeDraft draft,
  ) async {
    await db.transaction(() async {
      await _history(node.projectId, 'node.update', _nodeJson(node), {
        ...draft.toJson(),
        'id': node.id,
        'projectId': node.projectId,
        'parentId': node.parentId,
      });
      await (db.update(
        db.knowledgeNodes,
      )..where((row) => row.id.equals(node.id))).write(
        KnowledgeNodesCompanion(
          title: Value(draft.title),
          summary: Value(draft.summary),
          content: Value(draft.content),
          coreConcept: Value(draft.coreConcept),
          principle: Value(draft.principle),
          mechanism: Value(draft.mechanism),
          methods: Value(draft.methods),
          application: Value(draft.application),
          learningValue: Value(draft.learningValue),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<int> addChild(int projectId, int? parentId, String title) async {
    if (parentId != null) {
      final parent =
          await (db.select(db.knowledgeNodes)..where(
                (row) =>
                    row.id.equals(parentId) & row.projectId.equals(projectId),
              ))
              .getSingleOrNull();
      if (parent == null) throw StateError('父节点不存在');
    }
    return createNode(projectId, title, '', '', parentId: parentId);
  }

  Future<void> moveNode(int nodeId, int? newParentId, {int? sortOrder}) async {
    final node = await (db.select(
      db.knowledgeNodes,
    )..where((row) => row.id.equals(nodeId))).getSingle();
    if (newParentId != null) {
      final parent =
          await (db.select(db.knowledgeNodes)..where(
                (row) =>
                    row.id.equals(newParentId) &
                    row.projectId.equals(node.projectId),
              ))
              .getSingleOrNull();
      if (parent == null) throw StateError('目标父节点不存在或属于其他体系');
      if (newParentId == nodeId || await _isDescendant(newParentId, nodeId)) {
        throw StateError('不能将节点移动到自身或其后代节点下');
      }
    }
    await db.transaction(() async {
      await _history(node.projectId, 'node.move', _nodeJson(node), {
        'id': node.id,
        'projectId': node.projectId,
        'parentId': newParentId,
        'title': node.title,
        'summary': node.summary,
        'content': node.content,
      });
      await (db.update(
        db.knowledgeNodes,
      )..where((row) => row.id.equals(nodeId))).write(
        KnowledgeNodesCompanion(
          parentId: Value(newParentId),
          sortOrder: sortOrder == null
              ? const Value.absent()
              : Value(sortOrder),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<bool> _isDescendant(int possibleChild, int ancestorId) async {
    final all = await db.select(db.knowledgeNodes).get();
    final byParent = <int?, List<int>>{};
    for (final node in all) {
      byParent.putIfAbsent(node.parentId, () => []).add(node.id);
    }
    final stack = <int>[ancestorId];
    while (stack.isNotEmpty) {
      for (final child in byParent[stack.removeLast()] ?? const <int>[]) {
        if (child == possibleChild) return true;
        stack.add(child);
      }
    }
    return false;
  }

  Future<void> deleteNode(int id, {required bool includeChildren}) async {
    final node = await (db.select(
      db.knowledgeNodes,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (node == null) return;
    final children = await _subtree(id);
    await db.transaction(() async {
      await _history(
        node.projectId,
        'node.delete',
        jsonEncode(children.map(_nodeJson).toList()),
        null,
      );
      if (includeChildren) {
        for (final descendant in children.reversed) {
          await (db.delete(
            db.knowledgeNodes,
          )..where((row) => row.id.equals(descendant.id))).go();
        }
      } else {
        final direct = children.where((item) => item.parentId == id);
        for (final child in direct) {
          await (db.update(db.knowledgeNodes)
                ..where((row) => row.id.equals(child.id)))
              .write(KnowledgeNodesCompanion(parentId: Value(node.parentId)));
        }
        await (db.delete(
          db.knowledgeNodes,
        )..where((row) => row.id.equals(id))).go();
      }
    });
  }

  Future<List<KnowledgeNode>> _subtree(int rootId) async {
    final all = await db.select(db.knowledgeNodes).get();
    final result = <KnowledgeNode>[];
    final stack = <int>[rootId];
    while (stack.isNotEmpty) {
      final id = stack.removeLast();
      final node = all.where((item) => item.id == id).firstOrNull;
      if (node == null) continue;
      result.add(node);
      stack.addAll(
        all.where((item) => item.parentId == id).map((item) => item.id),
      );
    }
    return result;
  }

  Future<void> addRelation(
    int sourceId,
    int targetId,
    String type,
    String description,
  ) async {
    if (sourceId == targetId) return;
    final duplicate =
        await (db.select(db.knowledgeRelations)..where(
              (row) =>
                  row.sourceNodeId.equals(sourceId) &
                  row.targetNodeId.equals(targetId) &
                  row.relationType.equals(type),
            ))
            .getSingleOrNull();
    if (duplicate != null) return;
    await db
        .into(db.knowledgeRelations)
        .insert(
          KnowledgeRelationsCompanion.insert(
            sourceNodeId: sourceId,
            targetNodeId: targetId,
            relationType: type,
            description: Value(description),
          ),
        );
  }

  Future<int> restoreBackup(Map<String, dynamic> backup) async {
    if (backup['format'] != 'mindflow-knowledge-v1' ||
        backup['project'] is! Map ||
        backup['nodes'] is! List) {
      throw const FormatException('不支持的 MindFlow 知识备份格式');
    }
    final projectData = backup['project'] as Map;
    final projectId = await createProject(
      projectData['title'] is String
          ? projectData['title'] as String
          : '恢复的知识体系',
      projectData['description'] is String
          ? projectData['description'] as String
          : '',
    );
    final rawNodes = (backup['nodes'] as List).whereType<Map>().toList();
    final idMap = <int, int>{};
    final pending = [...rawNodes];
    while (pending.isNotEmpty) {
      var progressed = false;
      for (final item in [...pending]) {
        final oldId = item['id'];
        final oldParent = item['parentId'];
        if (oldId is! int ||
            (oldParent is int && !idMap.containsKey(oldParent))) {
          continue;
        }
        final newId = await db
            .into(db.knowledgeNodes)
            .insert(
              KnowledgeNodesCompanion.insert(
                projectId: projectId,
                parentId: Value(oldParent is int ? idMap[oldParent] : null),
                title: item['title'] is String
                    ? item['title'] as String
                    : '未命名节点',
                summary: Value(
                  item['summary'] is String ? item['summary'] as String : '',
                ),
                content: Value(
                  item['content'] is String ? item['content'] as String : '',
                ),
                coreConcept: Value(
                  item['coreConcept'] is String
                      ? item['coreConcept'] as String
                      : '',
                ),
                principle: Value(
                  item['principle'] is String
                      ? item['principle'] as String
                      : '',
                ),
                mechanism: Value(
                  item['mechanism'] is String
                      ? item['mechanism'] as String
                      : '',
                ),
                methods: Value(
                  item['methods'] is String ? item['methods'] as String : '',
                ),
                application: Value(
                  item['application'] is String
                      ? item['application'] as String
                      : '',
                ),
                learningValue: Value(
                  item['learningValue'] is String
                      ? item['learningValue'] as String
                      : '',
                ),
                sortOrder: Value(
                  item['sortOrder'] is int ? item['sortOrder'] as int : 0,
                ),
              ),
            );
        idMap[oldId] = newId;
        pending.remove(item);
        progressed = true;
      }
      if (!progressed) throw const FormatException('备份中的父子关系存在缺失或循环');
    }
    final rawRelations = backup['relations'];
    if (rawRelations is List) {
      for (final item in rawRelations.whereType<Map>()) {
        final source = item['sourceNodeId'];
        final target = item['targetNodeId'];
        if (source is int &&
            target is int &&
            idMap[source] != null &&
            idMap[target] != null) {
          await addRelation(
            idMap[source]!,
            idMap[target]!,
            item['relationType'] is String
                ? item['relationType'] as String
                : 'related',
            item['description'] is String ? item['description'] as String : '',
          );
        }
      }
    }
    return projectId;
  }

  Future<void> reorder(int nodeId, int sortOrder) async {
    await (db.update(
      db.knowledgeNodes,
    )..where((row) => row.id.equals(nodeId))).write(
      KnowledgeNodesCompanion(
        sortOrder: Value(sortOrder),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> shiftSibling(int nodeId, int delta) async {
    final node = await (db.select(
      db.knowledgeNodes,
    )..where((row) => row.id.equals(nodeId))).getSingle();
    final siblings =
        await (db.select(db.knowledgeNodes)
              ..where(
                (row) => node.parentId == null
                    ? row.projectId.equals(node.projectId) &
                          row.parentId.isNull()
                    : row.parentId.equals(node.parentId!),
              )
              ..orderBy([(row) => OrderingTerm(expression: row.sortOrder)]))
            .get();
    final from = siblings.indexWhere((item) => item.id == nodeId);
    final to = (from + delta).clamp(0, siblings.length - 1);
    if (from < 0 || from == to) return;
    final reordered = [...siblings];
    final moved = reordered.removeAt(from);
    reordered.insert(to, moved);
    await db.transaction(() async {
      for (var index = 0; index < reordered.length; index++) {
        await (db.update(db.knowledgeNodes)
              ..where((row) => row.id.equals(reordered[index].id)))
            .write(KnowledgeNodesCompanion(sortOrder: Value(index)));
      }
    });
  }

  Future<void> deleteRelation(int relationId) => (db.delete(
    db.knowledgeRelations,
  )..where((row) => row.id.equals(relationId))).go();

  Future<List<KnowledgeEditHistory>> history(int projectId) =>
      (db.select(db.knowledgeEditHistories)
            ..where((row) => row.projectId.equals(projectId))
            ..orderBy([
              (row) => OrderingTerm(
                expression: row.createdAt,
                mode: OrderingMode.desc,
              ),
              (row) =>
                  OrderingTerm(expression: row.id, mode: OrderingMode.desc),
            ]))
          .get();

  Future<void> undoLast(int projectId) async {
    final last =
        await (db.select(db.knowledgeEditHistories)
              ..where((row) => row.projectId.equals(projectId))
              ..orderBy([
                (row) => OrderingTerm(
                  expression: row.createdAt,
                  mode: OrderingMode.desc,
                ),
                (row) =>
                    OrderingTerm(expression: row.id, mode: OrderingMode.desc),
              ])
              ..limit(1))
            .getSingleOrNull();
    if (last == null) return;
    if (last.operationType == 'node.create' && last.beforeData == null) {
      final json = last.afterData == null ? null : jsonDecode(last.afterData!);
      if (json is Map<String, dynamic> && json['id'] is int) {
        await db.transaction(() async {
          await (db.delete(
            db.knowledgeNodes,
          )..where((row) => row.id.equals(json['id'] as int))).go();
          await (db.delete(
            db.knowledgeEditHistories,
          )..where((row) => row.id.equals(last.id))).go();
        });
      }
      return;
    }
    if (last.beforeData == null) return;
    final json = jsonDecode(last.beforeData!);
    if (json is List) {
      final nodes = json
          .whereType<Map>()
          .map(
            (item) => item.map((key, value) => MapEntry(key.toString(), value)),
          )
          .toList();
      await db.transaction(() async {
        final pending = [...nodes];
        while (pending.isNotEmpty) {
          var progressed = false;
          for (final item in [...pending]) {
            final parentId = item['parentId'];
            if (parentId is int) {
              if (pending.any((waiting) => waiting['id'] == parentId)) continue;
              if (!nodes.any((candidate) => candidate['id'] == parentId)) {
                throw const FormatException('无法撤销：父节点不存在');
              }
            }
            await _insertNodeSnapshot(item);
            pending.remove(item);
            progressed = true;
          }
          if (!progressed) throw const FormatException('无法撤销：子树结构无效');
        }
        await (db.delete(
          db.knowledgeEditHistories,
        )..where((row) => row.id.equals(last.id))).go();
      });
      return;
    }
    if (json is Map<String, dynamic> &&
        json['id'] is int &&
        json['projectId'] is int) {
      final id = json['id'] as int;
      if (last.operationType == 'project.update') {
        await (db.update(
          db.knowledgeProjects,
        )..where((row) => row.id.equals(id))).write(
          KnowledgeProjectsCompanion(
            title: Value(json['title'] as String),
            description: Value(json['description'] as String? ?? ''),
            updatedAt: Value(DateTime.now()),
          ),
        );
        await (db.delete(
          db.knowledgeEditHistories,
        )..where((row) => row.id.equals(last.id))).go();
        return;
      }
      final exists = await (db.select(
        db.knowledgeNodes,
      )..where((row) => row.id.equals(id))).getSingleOrNull();
      if (exists == null) {
        await _insertNodeSnapshot(json);
      } else {
        await (db.update(
          db.knowledgeNodes,
        )..where((row) => row.id.equals(id))).write(
          KnowledgeNodesCompanion(
            parentId: Value(json['parentId'] as int?),
            title: Value(json['title'] as String),
            summary: Value(json['summary'] as String? ?? ''),
            content: Value(json['content'] as String? ?? ''),
            coreConcept: Value(json['coreConcept'] as String? ?? ''),
            principle: Value(json['principle'] as String? ?? ''),
            mechanism: Value(json['mechanism'] as String? ?? ''),
            methods: Value(json['methods'] as String? ?? ''),
            application: Value(json['application'] as String? ?? ''),
            learningValue: Value(json['learningValue'] as String? ?? ''),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
      await (db.delete(
        db.knowledgeEditHistories,
      )..where((row) => row.id.equals(last.id))).go();
    }
  }

  Future<void> _insertNodeSnapshot(Map<String, dynamic> json) async {
    await db
        .into(db.knowledgeNodes)
        .insert(
          KnowledgeNodesCompanion.insert(
            id: Value(json['id'] as int),
            projectId: json['projectId'] as int,
            parentId: Value(json['parentId'] as int?),
            title: json['title'] as String,
            summary: Value(json['summary'] as String? ?? ''),
            content: Value(json['content'] as String? ?? ''),
            coreConcept: Value(json['coreConcept'] as String? ?? ''),
            principle: Value(json['principle'] as String? ?? ''),
            mechanism: Value(json['mechanism'] as String? ?? ''),
            methods: Value(json['methods'] as String? ?? ''),
            application: Value(json['application'] as String? ?? ''),
            learningValue: Value(json['learningValue'] as String? ?? ''),
            sortOrder: Value(json['sortOrder'] as int? ?? 0),
          ),
        );
  }

  Future<void> _history(
    int projectId,
    String operation,
    Object? before,
    Object? after,
  ) => db
      .into(db.knowledgeEditHistories)
      .insert(
        KnowledgeEditHistoriesCompanion.insert(
          projectId: projectId,
          operationType: operation,
          beforeData: Value(
            before == null
                ? null
                : before is String
                ? before
                : jsonEncode(before),
          ),
          afterData: Value(
            after == null
                ? null
                : after is String
                ? after
                : jsonEncode(after),
          ),
        ),
      );

  Map<String, Object?> _nodeJson(KnowledgeNode node) => {
    'id': node.id,
    'projectId': node.projectId,
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
  };

  Map<String, Object?> _projectJson(KnowledgeProject project) => {
    'id': project.id,
    'projectId': project.id,
    'title': project.title,
    'description': project.description,
  };
}

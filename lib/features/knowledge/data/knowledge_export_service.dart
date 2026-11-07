// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:mindflow/core/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class KnowledgeExportService {
  Future<File> exportMarkdown(
    KnowledgeProject project,
    List<KnowledgeNode> nodes,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, '${_safe(project.title)}.md'));
    await file.writeAsString(renderMarkdown(project, nodes));
    return file;
  }

  String renderMarkdown(KnowledgeProject project, List<KnowledgeNode> nodes) {
    final byParent = <int?, List<KnowledgeNode>>{};
    for (final node in nodes) {
      byParent.putIfAbsent(node.parentId, () => []).add(node);
    }
    final buffer = StringBuffer(
      '# ${project.title}\n\n${project.description}\n',
    );
    void append(int? parentId, int depth) {
      for (final node in byParent[parentId] ?? const <KnowledgeNode>[]) {
        buffer.writeln('\n${'#' * (depth + 2)} ${node.title}\n');
        if (node.summary.isNotEmpty) buffer.writeln('${node.summary}\n');
        for (final field in [
          ('核心概念', node.coreConcept),
          ('基本原理', node.principle),
          ('关键机制', node.mechanism),
          ('主要方法', node.methods),
          ('实际应用', node.application),
          ('学习价值', node.learningValue),
        ]) {
          if (field.$2.trim().isNotEmpty)
            buffer.writeln('**${field.$1}**\n\n${field.$2}\n');
        }
        if (node.content.trim().isNotEmpty) buffer.writeln('${node.content}\n');
        append(node.id, depth + 1);
      }
    }

    append(null, 0);
    return buffer.toString();
  }

  Future<File> exportBackup(
    KnowledgeProject project,
    List<KnowledgeNode> nodes,
    List<KnowledgeRelation> relations,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      p.join(directory.path, '${_safe(project.title)}.mindflow.json'),
    );
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'format': 'mindflow-knowledge-v1',
        'project': {'title': project.title, 'description': project.description},
        'nodes': nodes
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
            .map(
              (item) => {
                'sourceNodeId': item.sourceNodeId,
                'targetNodeId': item.targetNodeId,
                'relationType': item.relationType,
                'description': item.description,
              },
            )
            .toList(),
      }),
    );
    return file;
  }

  String _safe(String value) => value.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
}

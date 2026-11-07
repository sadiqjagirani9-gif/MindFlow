import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class KnowledgeGraphExportService {
  Future<File> exportBoundary({
    required GlobalKey boundaryKey,
    required String projectTitle,
    double pixelRatio = 2,
  }) async {
    final boundary = boundaryKey.currentContext?.findRenderObject();
    if (boundary is! RenderRepaintBoundary) {
      throw StateError('图谱尚未完成绘制');
    }
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) throw StateError('PNG 编码失败');
      return await writePngBytes(
        data.buffer.asUint8List(),
        projectTitle: projectTitle,
      );
    } finally {
      image.dispose();
    }
  }

  Future<File> writePngBytes(
    Uint8List bytes, {
    required String projectTitle,
  }) async {
    const signature = [137, 80, 78, 71, 13, 10, 26, 10];
    if (bytes.length < signature.length ||
        !signature.asMap().entries.every(
          (entry) => bytes[entry.key] == entry.value,
        )) {
      throw const FormatException('不是有效的 PNG 数据');
    }
    final directory = await getApplicationDocumentsDirectory();
    final safeName = projectTitle.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final file = File(p.join(directory.path, '${safeName}_graph.png'));
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

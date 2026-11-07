// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindflow/app/app.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/features/diary/data/diary_repository.dart';
import 'package:mindflow/features/knowledge/data/knowledge_repository.dart';
import 'package:mindflow/features/tasks/presentation/task_provider.dart';

void main() {
  testWidgets('main navigation opens all four modules', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tasksProvider.overrideWith((ref) => Stream.value(<TaskRecord>[])),
          taskCategoriesProvider.overrideWith(
            (ref) => Stream.value(<TaskCategory>[]),
          ),
          knowledgeProjectsProvider.overrideWith(
            (ref) => Stream.value(<KnowledgeProject>[]),
          ),
          diaryEntriesProvider.overrideWith(
            (ref) => Stream.value(<DiaryEntry>[]),
          ),
        ],
        child: const MindFlowApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('你好，今天也保持清醒'), findsOneWidget);
    await tester.tap(find.text('待办'));
    await tester.pumpAndSettle();
    expect(find.text('今日'), findsOneWidget);
    await tester.tap(find.text('知识'));
    await tester.pumpAndSettle();
    expect(find.text('知识体系'), findsOneWidget);
    await tester.tap(find.text('日记'));
    await tester.pumpAndSettle();
    expect(find.text('今天还没有日记'), findsOneWidget);
  });
}

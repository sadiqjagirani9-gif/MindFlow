import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' show Value;
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/core/services/task_notification_gateway.dart';
import 'package:mindflow/features/tasks/data/task_repository.dart';
import 'package:mindflow/features/tasks/domain/task_service.dart';

void main() {
  late AppDatabase database;
  late TaskRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = TaskRepository(database);
  });

  tearDown(() async => database.close());

  test('calendar date storage is independent of timezone offsets', () {
    const converter = DateOnlyConverter();
    final value = DateTime(2026, 11, 7, 23, 45);

    expect(converter.toSql(value), 20261107);
    expect(converter.fromSql(20261107), DateTime.utc(2026, 11, 7));
  });

  test('seeds the four default categories without duplicates', () async {
    await repository.seedDefaultCategories();
    await repository.seedDefaultCategories();

    final categories = await repository.getCategories();
    expect(categories.map((item) => item.name).toSet(), {
      '学习',
      '生活',
      '工作',
      '其他',
    });
  });

  test('task deletion cascades to its reminder', () async {
    await repository.seedDefaultCategories();
    final category = (await repository.getCategories()).first;
    final taskId = await repository.create(
      TaskRecordsCompanion.insert(
        title: '测试提醒',
        categoryId: Value(category.id),
      ),
      reminderTime: DateTime.now().add(const Duration(days: 1)),
      repeatRule: 'daily',
    );

    expect((await repository.remindersForTask(taskId)), hasLength(1));
    await repository.delete(taskId);
    expect(await repository.remindersForTask(taskId), isEmpty);
  });

  test(
    'task service creates, updates, and deletes with notification cleanup',
    () async {
      final notifications = _FakeNotifications();
      final service = TaskService(repository, notifications);
      final reminder = DateTime.now().add(const Duration(days: 2));
      final id = await service.create(
        task: TaskRecordsCompanion.insert(title: '初始任务'),
        reminderTime: reminder,
        repeatRule: 'weekly',
      );
      expect(notifications.scheduled, [id]);
      var task = (await repository.getAllTasks()).single;
      await service.update(
        task: task.copyWith(title: '修改后的任务'),
        title: '修改后的任务',
        reminderTime: reminder.add(const Duration(hours: 1)),
        repeatRule: 'weekly',
      );
      task = (await repository.getAllTasks()).single;
      expect(task.title, '修改后的任务');
      expect(notifications.cancelled, contains(id));
      expect(
        notifications.scheduled.where((value) => value == id),
        hasLength(2),
      );
      await service.delete(task);
      expect(await repository.getAllTasks(), isEmpty);
      expect(notifications.cancelled.where((value) => value == id).length, 2);
    },
  );

  test(
    'completing a recurring task creates the next one and undo removes it',
    () async {
      final notifications = _FakeNotifications();
      final service = TaskService(repository, notifications);
      final now = DateTime.now();
      final taskId = await repository.create(
        TaskRecordsCompanion.insert(
          title: '每天阅读',
          dueDate: Value(DateTime.utc(now.year, now.month, now.day)),
        ),
        reminderTime: now.add(const Duration(days: 1)),
        repeatRule: 'daily',
      );

      final task = (await repository.getAllTasks()).single;
      await service.toggleCompleted(task);
      var tasks = await repository.getAllTasks();
      expect(tasks, hasLength(2));
      expect(
        tasks.singleWhere((item) => item.id == taskId).isCompleted,
        isTrue,
      );
      final next = tasks.singleWhere(
        (item) => item.previousOccurrenceId == taskId,
      );
      expect(next.repeatRule, 'daily');
      expect(next.dueDate, DateTime.utc(now.year, now.month, now.day + 1));
      expect(notifications.scheduled, contains(next.id));

      await service.toggleCompleted(
        tasks.singleWhere((item) => item.id == taskId),
      );
      tasks = await repository.getAllTasks();
      expect(tasks, hasLength(1));
      expect(tasks.single.isCompleted, isFalse);
      expect(notifications.cancelled, contains(next.id));
    },
  );
}

class _FakeNotifications implements TaskNotificationGateway {
  final scheduled = <int>[];
  final cancelled = <int>[];

  @override
  Future<void> cancel(int id) async => cancelled.add(id);

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required DateTime reminderTime,
    required String repeatRule,
  }) async {
    scheduled.add(id);
  }

  @override
  Future<bool> refreshTimezone() async => false;
}

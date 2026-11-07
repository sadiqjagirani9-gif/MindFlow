import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/core/database/database_provider.dart';

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepository(ref.watch(databaseProvider)),
);

class TaskRepository {
  TaskRepository(this.db);
  final AppDatabase db;

  Stream<List<TaskRecord>> watchTasks() =>
      (db.select(db.taskRecords)..orderBy([
            (row) => OrderingTerm(expression: row.isCompleted),
            (row) =>
                OrderingTerm(expression: row.dueDate, mode: OrderingMode.asc),
            (row) =>
                OrderingTerm(expression: row.priority, mode: OrderingMode.desc),
          ]))
          .watch();

  Stream<List<TaskCategory>> watchCategories() => (db.select(
    db.taskCategories,
  )..orderBy([(row) => OrderingTerm(expression: row.name)])).watch();

  Future<void> seedDefaultCategories() async {
    const defaults = ['学习', '生活', '工作', '其他'];
    await db.batch((batch) {
      batch.insertAll(
        db.taskCategories,
        defaults.map((name) => TaskCategoriesCompanion.insert(name: name)),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Future<int> create(
    TaskRecordsCompanion task, {
    DateTime? reminderTime,
    String repeatRule = 'none',
  }) => db.transaction(() async {
    final id = await db
        .into(db.taskRecords)
        .insert(task.copyWith(repeatRule: Value(repeatRule)));
    if (reminderTime != null) {
      await db
          .into(db.taskReminders)
          .insert(
            TaskRemindersCompanion.insert(
              taskId: id,
              reminderTime: reminderTime,
              repeatRule: Value(repeatRule),
              notificationId: id,
            ),
          );
    }
    return id;
  });

  Future<bool> update(
    TaskRecord task, {
    DateTime? reminderTime,
    String repeatRule = 'none',
  }) => db.transaction(() async {
    final changed = await db
        .update(db.taskRecords)
        .replace(
          task.copyWith(repeatRule: repeatRule, updatedAt: DateTime.now()),
        );
    await (db.delete(
      db.taskReminders,
    )..where((row) => row.taskId.equals(task.id))).go();
    if (reminderTime != null) {
      await db
          .into(db.taskReminders)
          .insert(
            TaskRemindersCompanion.insert(
              taskId: task.id,
              reminderTime: reminderTime,
              repeatRule: Value(repeatRule),
              notificationId: task.id,
            ),
          );
    }
    return changed;
  });

  Future<void> setCompleted(TaskRecord task, bool completed) async {
    await (db.update(
      db.taskRecords,
    )..where((row) => row.id.equals(task.id))).write(
      TaskRecordsCompanion(
        isCompleted: Value(completed),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int?> completeAndCreateNext(
    TaskRecord task, {
    DateTime? nextDueDate,
    DateTime? nextReminderTime,
  }) => db.transaction(() async {
    await (db.update(
      db.taskRecords,
    )..where((row) => row.id.equals(task.id))).write(
      TaskRecordsCompanion(
        isCompleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
    if (task.repeatRule == 'none' || nextDueDate == null) return null;
    final id = await db
        .into(db.taskRecords)
        .insert(
          TaskRecordsCompanion.insert(
            title: task.title,
            description: Value(task.description),
            dueDate: Value(nextDueDate),
            dueTime: Value(task.dueTime),
            priority: Value(task.priority),
            repeatRule: Value(task.repeatRule),
            previousOccurrenceId: Value(task.id),
            categoryId: Value(task.categoryId),
          ),
        );
    if (nextReminderTime != null) {
      await db
          .into(db.taskReminders)
          .insert(
            TaskRemindersCompanion.insert(
              taskId: id,
              reminderTime: nextReminderTime,
              repeatRule: Value(task.repeatRule),
              notificationId: id,
            ),
          );
    }
    return id;
  });

  Future<List<int>> reopenAndDeleteNext(TaskRecord task) =>
      db.transaction(() async {
        final next = await uncompletedNextOccurrences(task.id);
        await (db.update(
          db.taskRecords,
        )..where((row) => row.id.equals(task.id))).write(
          TaskRecordsCompanion(
            isCompleted: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        );
        for (final item in next) {
          await (db.delete(
            db.taskRecords,
          )..where((row) => row.id.equals(item.id))).go();
        }
        return next.map((item) => item.id).toList();
      });

  Future<void> delete(int id) async {
    await (db.delete(db.taskRecords)..where((row) => row.id.equals(id))).go();
  }

  Future<List<TaskReminder>> remindersForTask(int taskId) => (db.select(
    db.taskReminders,
  )..where((row) => row.taskId.equals(taskId))).get();

  Future<List<TaskRecord>> getAllTasks() => db.select(db.taskRecords).get();

  Future<List<TaskRecord>> uncompletedNextOccurrences(int taskId) =>
      (db.select(db.taskRecords)..where(
            (row) =>
                row.previousOccurrenceId.equals(taskId) &
                row.isCompleted.equals(false),
          ))
          .get();

  Future<List<TaskReminder>> getAllReminders() =>
      db.select(db.taskReminders).get();

  Future<List<TaskCategory>> getCategories() =>
      db.select(db.taskCategories).get();

  Future<int> addCategory(String name, int colorValue) => db
      .into(db.taskCategories)
      .insert(
        TaskCategoriesCompanion.insert(
          name: name,
          colorValue: Value(colorValue),
        ),
      );

  Future<void> deleteCategory(int id) async {
    await (db.delete(
      db.taskCategories,
    )..where((row) => row.id.equals(id))).go();
  }
}

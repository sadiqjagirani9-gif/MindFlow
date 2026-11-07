import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/core/services/notification_service.dart';
import 'package:mindflow/core/services/task_notification_gateway.dart';
import 'package:mindflow/features/tasks/data/task_repository.dart';

final taskServiceProvider = Provider<TaskService>(
  (ref) => TaskService(
    ref.watch(taskRepositoryProvider),
    NotificationService.instance,
  ),
);

class TaskService {
  const TaskService(this._repository, this._notifications);
  final TaskRepository _repository;
  final TaskNotificationGateway _notifications;

  Future<int> create({
    required TaskRecordsCompanion task,
    DateTime? reminderTime,
    String repeatRule = 'none',
  }) async {
    final id = await _repository.create(
      task,
      reminderTime: reminderTime,
      repeatRule: repeatRule,
    );
    await _schedule(id, task.title.value, reminderTime, repeatRule);
    return id;
  }

  Future<void> update({
    required TaskRecord task,
    required String title,
    DateTime? reminderTime,
    String repeatRule = 'none',
  }) async {
    await _repository.update(
      task,
      reminderTime: reminderTime,
      repeatRule: repeatRule,
    );
    await _notifications.cancel(task.id);
    if (!task.isCompleted) {
      await _schedule(task.id, title, reminderTime, repeatRule);
    }
  }

  Future<void> delete(TaskRecord task) async {
    await _notifications.cancel(task.id);
    await _repository.delete(task.id);
  }

  Future<void> toggleCompleted(TaskRecord task) async {
    final reminders = await _repository.remindersForTask(task.id);
    final reminder = reminders.isEmpty ? null : reminders.first;
    if (task.isCompleted) {
      final deletedIds = await _repository.reopenAndDeleteNext(task);
      for (final id in deletedIds) {
        await _notifications.cancel(id);
      }
      await _schedule(
        task.id,
        task.title,
        reminder?.reminderTime,
        task.repeatRule,
      );
      return;
    }

    DateTime? nextDueDate;
    DateTime? nextReminder;
    if (task.repeatRule != 'none') {
      final interval = _intervalDays(task.repeatRule);
      final basis = task.dueDate ?? DateTime.now();
      var dueDate = DateTime.utc(basis.year, basis.month, basis.day + interval);
      nextDueDate = dueDate;
      nextReminder = reminder == null
          ? null
          : _addCalendarDays(reminder.reminderTime, interval);
      final today = DateTime.now();
      while (!DateTime(
        dueDate.year,
        dueDate.month,
        dueDate.day,
      ).isAfter(DateTime(today.year, today.month, today.day))) {
        dueDate = dueDate.add(Duration(days: interval));
        nextDueDate = dueDate;
        if (nextReminder != null) {
          nextReminder = nextReminder.add(Duration(days: interval));
        }
      }
    }
    final nextId = await _repository.completeAndCreateNext(
      task,
      nextDueDate: nextDueDate,
      nextReminderTime: nextReminder,
    );
    await _notifications.cancel(task.id);
    if (nextId != null && nextReminder != null) {
      await _schedule(nextId, task.title, nextReminder, task.repeatRule);
    }
  }

  Future<void> synchronizeTimezone() async {
    final changed = await _notifications.refreshTimezone();
    if (!changed) return;
    await rescheduleAll();
  }

  Future<void> rescheduleAll() async {
    final tasks = {
      for (final task in await _repository.getAllTasks()) task.id: task,
    };
    for (final reminder in await _repository.getAllReminders()) {
      final task = tasks[reminder.taskId];
      if (task == null || task.isCompleted) {
        await _notifications.cancel(reminder.notificationId);
        continue;
      }
      await _notifications.cancel(reminder.notificationId);
      await _schedule(
        reminder.notificationId,
        task.title,
        reminder.reminderTime,
        task.repeatRule,
      );
    }
  }

  Future<void> cancelAll() async {
    for (final reminder in await _repository.getAllReminders()) {
      await _notifications.cancel(reminder.notificationId);
    }
  }

  Future<void> _schedule(
    int id,
    String title,
    DateTime? reminderTime,
    String repeatRule,
  ) async {
    if (reminderTime == null) return;
    await _notifications.schedule(
      id: id,
      title: title,
      reminderTime: reminderTime,
      repeatRule: repeatRule,
    );
  }

  int _intervalDays(String rule) {
    if (rule == 'daily') return 1;
    if (rule == 'weekly') return 7;
    final match = RegExp(r'^custom:(\d+)$').firstMatch(rule);
    return match == null ? 1 : int.parse(match.group(1)!);
  }

  DateTime _addCalendarDays(DateTime value, int days) {
    final local = value.toLocal();
    return DateTime(
      local.year,
      local.month,
      local.day + days,
      local.hour,
      local.minute,
    );
  }
}

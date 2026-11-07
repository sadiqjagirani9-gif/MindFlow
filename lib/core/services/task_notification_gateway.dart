abstract interface class TaskNotificationGateway {
  Future<bool> refreshTimezone();

  Future<void> schedule({
    required int id,
    required String title,
    required DateTime reminderTime,
    required String repeatRule,
  });

  Future<void> cancel(int id);
}

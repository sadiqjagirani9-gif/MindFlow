import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:mindflow/core/services/task_notification_gateway.dart';

class NotificationService implements TaskNotificationGateway {
  NotificationService._();
  static final instance = NotificationService._();
  final _plugin = FlutterLocalNotificationsPlugin();
  String? _timezoneId;

  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    try {
      await refreshTimezone();
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(
      android: android,
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings);
  }

  Future<bool> requestPermissions() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final android = await androidPlugin?.requestNotificationsPermission();
    final exact = await androidPlugin?.canScheduleExactNotifications();
    if (exact == false) await androidPlugin?.requestExactAlarmsPermission();
    final ios = await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return android ?? ios ?? false;
  }

  @override
  Future<bool> refreshTimezone() async {
    final timezone = await FlutterTimezone.getLocalTimezone();
    final changed = timezone.identifier != _timezoneId;
    _timezoneId = timezone.identifier;
    tz.setLocalLocation(tz.getLocation(timezone.identifier));
    return changed;
  }

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required DateTime reminderTime,
    required String repeatRule,
  }) async {
    if (!reminderTime.isAfter(DateTime.now())) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_reminders',
        '任务提醒',
        channelDescription: '待办任务的本地提醒',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        '该处理这项待办了',
        tz.TZDateTime.from(reminderTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: _repeatComponents(repeatRule),
      );
    } on Exception {
      await _plugin.zonedSchedule(
        id,
        title,
        '该处理这项待办了',
        tz.TZDateTime.from(reminderTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: _repeatComponents(repeatRule),
      );
    }
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id);

  DateTimeComponents? _repeatComponents(String rule) => switch (rule) {
    'daily' => DateTimeComponents.time,
    'weekly' => DateTimeComponents.dayOfWeekAndTime,
    _ => null,
  };
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final defaultReminderTimeProvider =
    StateNotifierProvider<DefaultReminderTimeController, TimeOfDay>(
      (ref) => DefaultReminderTimeController(),
    );

class DefaultReminderTimeController extends StateNotifier<TimeOfDay> {
  DefaultReminderTimeController() : super(const TimeOfDay(hour: 9, minute: 0)) {
    _restore();
  }

  Future<void> setTime(TimeOfDay time) async {
    state = time;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('default_reminder_hour', time.hour);
    await preferences.setInt('default_reminder_minute', time.minute);
  }

  Future<void> _restore() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final hour = preferences.getInt('default_reminder_hour');
      final minute = preferences.getInt('default_reminder_minute');
      if (hour != null &&
          minute != null &&
          hour >= 0 &&
          hour <= 23 &&
          minute >= 0 &&
          minute <= 59) {
        state = TimeOfDay(hour: hour, minute: minute);
      }
    } catch (_) {
      // Keep the safe 09:00 default when preferences are unavailable.
    }
  }
}

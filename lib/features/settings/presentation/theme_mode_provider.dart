import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController(),
);

class ThemeModeController extends StateNotifier<ThemeMode> {
  bool _hasUserChoice = false;

  ThemeModeController() : super(ThemeMode.system) {
    _restore();
  }

  Future<void> setMode(ThemeMode mode) async {
    _hasUserChoice = true;
    state = mode;
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('theme_mode', mode.name);
    } catch (_) {
      // Keep the selected theme for this process when platform storage is unavailable.
    }
  }

  Future<void> _restore() async {
    try {
      final saved = (await SharedPreferences.getInstance()).getString(
        'theme_mode',
      );
      if (!_hasUserChoice) {
        state = ThemeMode.values.firstWhere(
          (mode) => mode.name == saved,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (_) {
      state = ThemeMode.system;
    }
  }
}

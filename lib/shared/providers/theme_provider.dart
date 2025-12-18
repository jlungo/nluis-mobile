import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  dark,
  system;

  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  static AppThemeMode fromString(String value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
        return AppThemeMode.system;
      default:
        return AppThemeMode.system;
    }
  }

  String get label {
    switch (this) {
      case AppThemeMode.light:
        return 'Mwangaza';
      case AppThemeMode.dark:
        return 'Giza';
      case AppThemeMode.system:
        return 'Mfumo';
    }
  }
}

/// state notifier
class ThemeNotifier extends StateNotifier<AppThemeMode> {
  final SharedPreferences _prefs;
  static const String _key = 'theme_mode';

  ThemeNotifier(this._prefs) : super(AppThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeString = _prefs.getString(_key);
    if (themeString != null) {
      state = AppThemeMode.fromString(themeString);
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    await _prefs.setString(_key, mode.name);
  }

  Future<void> toggleTheme() async {
    final nextMode =
        state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
    await setTheme(nextMode);
  }
}

/// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});

/// Theme mode provider (for MaterialApp)
final themeModeProvider = Provider<ThemeMode>((ref) {
  final appThemeMode = ref.watch(themeProvider);
  return appThemeMode.themeMode;
});

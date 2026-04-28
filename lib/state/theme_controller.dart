import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's light/dark preference.
class ThemeController extends ChangeNotifier {
  ThemeController(this._prefs)
      : _mode = _modeFromString(_prefs.getString(_prefKey));

  static const String _prefKey = 'kadence.theme_mode';

  final SharedPreferences _prefs;
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  bool get isDark {
    if (_mode == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _mode == ThemeMode.dark;
  }

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    await _prefs.setString(_prefKey, _modeToString(mode));
  }

  Future<void> toggleDark() =>
      setMode(isDark ? ThemeMode.light : ThemeMode.dark);

  static ThemeMode _modeFromString(String? value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  static String _modeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }
}

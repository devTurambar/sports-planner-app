import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's light/dark preference and week-start day.
class ThemeController extends ChangeNotifier {
  ThemeController(this._prefs)
      : _mode = _modeFromString(_prefs.getString(_prefKey)),
        _weekStartDay = _prefs.getInt(_weekStartKey) ?? DateTime.monday;

  static const String _prefKey = 'kadence.theme_mode';
  static const String _weekStartKey = 'kadence.week_start_day';

  final SharedPreferences _prefs;
  ThemeMode _mode;
  int _weekStartDay;

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

  /// DateTime.monday (1) or DateTime.sunday (7).
  int get weekStartDay => _weekStartDay;

  bool get weekStartsOnSunday => _weekStartDay == DateTime.sunday;

  Future<void> setWeekStartDay(int day) async {
    if (_weekStartDay == day) return;
    _weekStartDay = day;
    notifyListeners();
    await _prefs.setInt(_weekStartKey, day);
  }

  Future<void> toggleWeekStart() =>
      setWeekStartDay(weekStartsOnSunday ? DateTime.monday : DateTime.sunday);

  static ThemeMode _modeFromString(String? value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.dark;
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

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks whether the user has completed onboarding and remembers their
/// answers so we can seed their first week from them.
class OnboardingController extends ChangeNotifier {
  OnboardingController(this._prefs);

  static const String _completedKey = 'kadence.onboarded';
  static const String _sportsKey = 'kadence.sports';
  static const String _daysKey = 'kadence.training_days';
  static const String _remindersKey = 'kadence.reminders';

  final SharedPreferences _prefs;

  bool get isCompleted => _prefs.getBool(_completedKey) ?? false;

  List<String> get sports => _prefs.getStringList(_sportsKey) ?? const [];
  List<String> get trainingDays =>
      _prefs.getStringList(_daysKey) ?? const ['Mon', 'Wed', 'Fri'];
  bool get remindersEnabled => _prefs.getBool(_remindersKey) ?? false;

  Future<void> setSports(List<String> sports) async {
    await _prefs.setStringList(_sportsKey, sports);
    notifyListeners();
  }

  Future<void> setTrainingDays(List<String> days) async {
    await _prefs.setStringList(_daysKey, days);
    notifyListeners();
  }

  Future<void> setReminders({required bool enabled}) async {
    await _prefs.setBool(_remindersKey, enabled);
    notifyListeners();
  }

  Future<void> complete() async {
    await _prefs.setBool(_completedKey, true);
    notifyListeners();
  }

  Future<void> reset() async {
    await _prefs.remove(_completedKey);
    notifyListeners();
  }
}

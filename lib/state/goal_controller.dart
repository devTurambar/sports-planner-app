import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalController extends ChangeNotifier {
  GoalController(this._prefs) {
    _goal = _prefs.getInt(_key);
  }

  static const _key = 'kadence.weekly_goal';
  final SharedPreferences _prefs;
  int? _goal;

  int? get goal => _goal;
  bool get hasGoal => _goal != null;

  void setGoal(int? value) {
    _goal = value;
    if (value == null) {
      _prefs.remove(_key);
    } else {
      _prefs.setInt(_key, value.clamp(1, 14));
    }
    notifyListeners();
  }
}

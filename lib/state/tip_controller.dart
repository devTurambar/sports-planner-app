import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TipKey {
  weekSwipe('kadence.tip.week_swipe'),
  doubleTap('kadence.tip.double_tap'),
  longPress('kadence.tip.long_press'),
  statsFilter('kadence.tip.stats_filter');

  const TipKey(this.prefsKey);
  final String prefsKey;
}

class TipController extends ChangeNotifier {
  TipController(this._prefs) {
    for (final key in TipKey.values) {
      _seen[key] = _prefs.getBool(key.prefsKey) ?? false;
    }
    _firstActivityCreated =
        _prefs.getBool('kadence.tip.first_activity_created') ?? false;
  }

  final SharedPreferences _prefs;
  final Map<TipKey, bool> _seen = {};
  bool _firstActivityCreated = false;

  bool wasSeen(TipKey key) => _seen[key] ?? false;

  bool shouldShow(TipKey key) => !wasSeen(key);

  bool get firstActivityCreated => _firstActivityCreated;

  void markSeen(TipKey key) {
    if (_seen[key] == true) return;
    _seen[key] = true;
    _prefs.setBool(key.prefsKey, true);
    notifyListeners();
  }

  void onActivityCreated() {
    if (_firstActivityCreated) return;
    _firstActivityCreated = true;
    _prefs.setBool('kadence.tip.first_activity_created', true);
    notifyListeners();
  }

  void reset() {
    for (final key in TipKey.values) {
      _seen[key] = false;
      _prefs.remove(key.prefsKey);
    }
    _firstActivityCreated = false;
    _prefs.remove('kadence.tip.first_activity_created');
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity.dart';
import '../theme/kadence_colors.dart';

class TypeColorController extends ChangeNotifier {
  TypeColorController(this._prefs) {
    _load();
  }

  static const String _prefKey = 'kadence.type_colors';
  static const String _accentPrefKey = 'kadence.accent_color';
  static const int paletteSize = 7;
  static const int defaultAccentIndex = 0;

  static const paletteLabels = [
    'Coral',
    'Blue',
    'Rose',
    'Purple',
    'Teal',
    'Green',
    'Amber',
  ];

  final SharedPreferences _prefs;
  Map<String, int> _overrides = {};
  int _accentIndex = defaultAccentIndex;

  Map<String, int> get overrides => Map.unmodifiable(_overrides);
  int get accentIndex => _accentIndex;

  Color accentTint(KadenceColors colors) => colors.paletteColor(_accentIndex).tint;

  void _load() {
    _accentIndex = _prefs.getInt(_accentPrefKey) ?? defaultAccentIndex;

    final raw = _prefs.getStringList(_prefKey);
    if (raw == null) return;
    for (final entry in raw) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        final idx = int.tryParse(parts[1]);
        if (idx != null && idx >= 0 && idx < paletteSize) {
          _overrides[parts[0]] = idx;
        }
      }
    }
  }

  Future<void> setAccent(int paletteIndex) async {
    final clamped = paletteIndex.clamp(0, paletteSize - 1);
    if (_accentIndex == clamped) return;
    _accentIndex = clamped;
    notifyListeners();
    await _prefs.setInt(_accentPrefKey, clamped);
  }

  Future<void> _persist() async {
    final list = _overrides.entries.map((e) => '${e.key}:${e.value}').toList();
    await _prefs.setStringList(_prefKey, list);
  }

  int? indexFor(ActivityType type) => _overrides[type.name];

  ActivityTypeColors resolve(KadenceColors colors, ActivityType? type) {
    if (type == null) return colors.typeColors(type);
    final idx = _overrides[type.name];
    if (idx != null) return colors.paletteColor(idx);
    return colors.typeColors(type);
  }

  Future<void> setColor(ActivityType type, int paletteIndex) async {
    final clamped = paletteIndex.clamp(0, paletteSize - 1);
    _overrides[type.name] = clamped;
    notifyListeners();
    await _persist();
  }

  Future<void> resetColor(ActivityType type) async {
    _overrides.remove(type.name);
    notifyListeners();
    await _persist();
  }

  Future<void> resetAll() async {
    _overrides = {};
    notifyListeners();
    await _prefs.remove(_prefKey);
  }
}

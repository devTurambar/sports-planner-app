import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's chosen language. A `null` locale means "follow
/// the device's system language" — Flutter's resolver then picks the
/// best match from [supportedLocales], falling back to English when
/// nothing matches.
class LocaleController extends ChangeNotifier {
  LocaleController(this._prefs)
      : _locale = _localeFromTag(_prefs.getString(_prefKey));

  static const String _prefKey = 'kadence.locale';

  /// Locales the app ships translations for. The first entry is the
  /// fallback Flutter uses when the device locale isn't supported.
  ///
  /// `Locale('pt')` is the base — European Portuguese content. A
  /// `pt-BR` device resolves to the more specific `Locale('pt', 'BR')`
  /// override (`app_pt_BR.arb`). A bare `pt` or `pt-PT` device falls
  /// to the base.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('es'),
    Locale('fr'),
  ];

  final SharedPreferences _prefs;
  Locale? _locale;

  /// `null` means "use the system locale".
  Locale? get locale => _locale;

  bool get followsSystem => _locale == null;

  Future<void> setLocale(Locale? value) async {
    if (_locale == value) return;
    _locale = value;
    notifyListeners();
    if (value == null) {
      await _prefs.remove(_prefKey);
    } else {
      await _prefs.setString(_prefKey, _localeToTag(value));
    }
  }

  /// Parse a stored language tag (e.g. "en", "pt-PT") back into one
  /// of [supportedLocales]. Returns `null` for unknown / missing tags.
  static Locale? _localeFromTag(String? tag) {
    if (tag == null || tag.isEmpty) return null;
    final parts = tag.split(RegExp(r'[-_]'));
    final language = parts[0];
    final country = parts.length > 1 ? parts[1] : null;
    for (final loc in supportedLocales) {
      if (loc.languageCode == language && loc.countryCode == country) {
        return loc;
      }
    }
    // Fallback: language-only match (e.g. saved "pt" matches "pt_PT").
    for (final loc in supportedLocales) {
      if (loc.languageCode == language) return loc;
    }
    return null;
  }

  static String _localeToTag(Locale loc) {
    if (loc.countryCode == null || loc.countryCode!.isEmpty) {
      return loc.languageCode;
    }
    return '${loc.languageCode}-${loc.countryCode}';
  }
}

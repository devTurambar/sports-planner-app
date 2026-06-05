import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_controller.dart';

/// Tracks whether the user has Kadence Pro.
///
/// Backed by SharedPreferences for now. When purchase infrastructure
/// (RevenueCat / in_app_purchase) is wired up, swap the backing store
/// without changing the public API.
class ProController extends ChangeNotifier {
  ProController(this._prefs, {required AuthController authController})
      : _authController = authController {
    _isPro = _prefs.getBool(_key) ?? true;
    // If not Pro but still signed in (e.g. sub expired between
    // sessions), force sign-out on startup so sync doesn't run.
    if (!_isPro && _authController.isSignedIn) {
      _authController.signOut();
    }
  }

  static const _key = 'kadence.is_pro';
  final SharedPreferences _prefs;
  final AuthController _authController;
  late bool _isPro;

  bool get isPro => _isPro;

  /// Grant or revoke Pro status.
  ///
  /// Called by purchase logic once entitlements are verified, or
  /// manually for testing. When downgrading (true → false), forces
  /// sign-out so cloud sync stops immediately.
  void setPro(bool value) {
    if (_isPro == value) return;
    _isPro = value;
    _prefs.setBool(_key, value);
    if (!value) _authController.signOut();
    notifyListeners();
  }
}

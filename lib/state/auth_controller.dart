import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'plan_controller.dart';
import 'sync_service.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required SharedPreferences prefs,
    required PlanController planController,
  })  : _prefs = prefs,
        _planController = planController {
    _subscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      _onAuthStateChange,
    );
    _session = Supabase.instance.client.auth.currentSession;
    // If already signed in on startup, sync immediately.
    if (_session != null) {
      _runSync(_session!.user.id);
    }
  }

  final SharedPreferences _prefs;
  final PlanController _planController;
  Session? _session;
  late final StreamSubscription<AuthState> _subscription;
  bool _syncing = false;

  bool get isSignedIn => _session != null;
  bool get isSyncing => _syncing;
  Session? get session => _session;
  User? get user => _session?.user;

  String? get displayName {
    final meta = user?.userMetadata;
    if (meta == null) return null;
    return (meta['full_name'] ?? meta['name']) as String?;
  }

  String? get avatarUrl {
    final meta = user?.userMetadata;
    return meta?['avatar_url'] as String?;
  }

  void _onAuthStateChange(AuthState data) {
    final previous = _session;
    _session = data.session;

    if (_session != null && previous == null) {
      // Just signed in — run sync.
      _runSync(_session!.user.id);
    } else if (_session == null && previous != null) {
      // Signed out — clear user from plan controller but keep ownership
      // so we can track pending deletes and recognize the same user.
      _planController.setUserId(null);
    }

    notifyListeners();
  }

  Future<void> _runSync(String userId) async {
    _syncing = true;
    notifyListeners();

    try {
      final merged = await SyncService.syncOnSignIn(
        prefs: _prefs,
        userId: userId,
        localData: _planController.byDate,
      );
      _planController.setUserId(userId);
      _planController.replaceAll(merged);
    } catch (e) {
      // Sync failed (offline, etc.) — still set user so pushes work.
      _planController.setUserId(userId);
      debugPrint('Sync failed: $e');
    }

    _syncing = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.kadence://login-callback/',
    );
  }

  Future<void> signInWithApple() async {
    await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'io.supabase.kadence://login-callback/',
    );
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

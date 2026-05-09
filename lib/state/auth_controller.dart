import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends ChangeNotifier {
  AuthController() {
    _subscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) {
        _session = data.session;
        notifyListeners();
      },
    );
    _session = Supabase.instance.client.auth.currentSession;
  }

  Session? _session;
  late final StreamSubscription<AuthState> _subscription;

  bool get isSignedIn => _session != null;
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

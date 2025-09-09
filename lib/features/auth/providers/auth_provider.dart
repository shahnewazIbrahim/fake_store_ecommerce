import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProviderCustom extends ChangeNotifier {
  final _svc = AuthService();
  User? user;
  bool enabled = true;

  void init() {
    try {
      _svc.onAuthStateChanged.listen((u) { user = u; notifyListeners(); });
    } catch (_) {
      enabled = false;
      notifyListeners();
    }
  }

  Future<void> signInAnon() async {
    if (!enabled) throw Exception('Firebase not configured');
    await _svc.signInAnonymously();
  }

  Future<void> signOut() => _svc.signOut();
}

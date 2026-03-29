import 'dart:async';

import 'package:carolie_tracking_app/src/domain/entities/app_user.dart';
import 'package:carolie_tracking_app/src/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier with WidgetsBindingObserver {
  AuthController(this._authRepository) {
    _subscription = _authRepository.watchAuthState().listen((user) {
      _currentUser = user;
      _isInitialized = true;
      notifyListeners();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  final AuthRepository _authRepository;
  StreamSubscription<AppUser?>? _subscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _authRepository.reloadUser();
    }
  }

  AppUser? _currentUser;
  bool _isBusy = false;
  bool _isInitialized = false;

  AppUser? get currentUser => _currentUser;
  bool get isBusy => _isBusy;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _currentUser != null;

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _runBusyAction(
      () => _authRepository.signInWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<void> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) {
    return _runBusyAction(
      () => _authRepository.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<void> signInWithGoogle() {
    return _runBusyAction(_authRepository.signInWithGoogle);
  }

  Future<void> signInAnonymously() {
    return _runBusyAction(_authRepository.signInAnonymously);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _runBusyAction(() => _authRepository.sendPasswordResetEmail(email));
  }

  Future<void> resendVerificationEmail() {
    return _authRepository.resendVerificationEmail();
  }

  Future<void> signOut() {
    return _runBusyAction(_authRepository.signOut);
  }

  Future<void> _runBusyAction(Future<void> Function() action) async {
    _isBusy = true;
    notifyListeners();
    try {
      await action();
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    super.dispose();
  }
}

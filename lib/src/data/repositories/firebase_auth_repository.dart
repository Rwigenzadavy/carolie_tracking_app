import 'package:carolie_tracking_app/src/data/models/app_user_model.dart';
import 'package:carolie_tracking_app/src/domain/entities/app_user.dart';
import 'package:carolie_tracking_app/src/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    return _mapUser(user);
  }

  @override
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credentials.user?.updateDisplayName(name);
  }

  @override
  Stream<AppUser?> watchAuthState() {
    return _firebaseAuth.authStateChanges().map(
      (user) => user == null ? null : _mapUser(user),
    );
  }

  AppUserModel _mapUser(User user) {
    return AppUserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
    );
  }
}

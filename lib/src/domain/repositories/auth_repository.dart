import 'package:carolie_tracking_app/src/domain/entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> watchAuthState();

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle();

  Future<void> signInAnonymously();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> resendVerificationEmail();

  Future<void> reloadUser();

  Future<void> signOut();
}

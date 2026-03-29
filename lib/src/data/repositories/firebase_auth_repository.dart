import 'package:carolie_tracking_app/src/core/firebase/firebase_collection_names.dart';
import 'package:carolie_tracking_app/src/data/models/app_user_model.dart';
import 'package:carolie_tracking_app/src/domain/entities/app_user.dart';
import 'package:carolie_tracking_app/src/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final credentials = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await _upsertUser(credentials.user);
  }

  @override
  Future<void> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credentials.user?.updateDisplayName(name.trim());
    await credentials.user?.reload();
    try {
      await credentials.user?.sendEmailVerification();
    } catch (_) {
      // Verification email failed (e.g. rate limit) — account is still created.
    }
    await _upsertUser(
      _firebaseAuth.currentUser,
      displayNameOverride: name.trim(),
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn.instance.authenticate();
    final authorizationClient = googleUser.authorizationClient;
    final authorization =
        await authorizationClient.authorizationForScopes(const <String>[]) ??
        await authorizationClient.authorizeScopes(const <String>[]);

    final authentication = googleUser.authentication;
    final idToken = authentication.idToken;

    if (idToken == null || idToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message: 'Google Sign-In did not return a valid ID token.',
      );
    }

    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
      accessToken: authorization.accessToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    await _upsertUser(userCredential.user);
  }

  @override
  Future<void> signInAnonymously() async {
    final credentials = await _firebaseAuth.signInAnonymously();
    await credentials.user?.updateDisplayName('Guest');
    await _upsertUser(credentials.user, displayNameOverride: 'Guest');
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  @override
  Future<void> resendVerificationEmail() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      GoogleSignIn.instance.signOut(),
    ]);
  }

  @override
  Stream<AppUser?> watchAuthState() {
    return _firebaseAuth.userChanges().asyncMap((user) async {
      if (user == null) {
        return null;
      }

      final refreshedUser = _firebaseAuth.currentUser ?? user;
      await _upsertUser(refreshedUser);
      return _mapUser(refreshedUser);
    });
  }

  Future<void> _upsertUser(User? user, {String? displayNameOverride}) async {
    if (user == null) {
      return;
    }

    final name =
        displayNameOverride ?? user.displayName ?? user.email?.split('@').first ?? '';
    if (name.isEmpty) return;

    final model = AppUserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: name,
      emailVerified: user.emailVerified,
      photoUrl: user.photoURL,
    );

    await _firestore
        .collection(FirebaseCollectionNames.users)
        .doc(user.uid)
        .set({
          ...model.toMap(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  AppUser _mapUser(User user) {
    return AppUserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName:
          user.displayName ?? user.email?.split('@').first ?? '',
      emailVerified: user.emailVerified,
      photoUrl: user.photoURL,
    );
  }
}

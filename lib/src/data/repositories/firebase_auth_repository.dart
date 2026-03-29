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
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

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
    await credentials.user?.sendEmailVerification();
    await _upsertUser(
      _firebaseAuth.currentUser,
      displayNameOverride: name.trim(),
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'sign_in_canceled',
        message: 'Google sign-in was canceled.',
      );
    }

    final authentication = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    await _upsertUser(userCredential.user);
  }

  @override
  Future<void> signInAnonymously() async {
    final credentials = await _firebaseAuth.signInAnonymously();
    await _upsertUser(
      credentials.user,
      displayNameOverride: 'Guest User',
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Stream<AppUser?> watchAuthState() {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) {
        return null;
      }

      await user.reload();
      final refreshedUser = _firebaseAuth.currentUser ?? user;
      await _upsertUser(refreshedUser);
      return _mapUser(refreshedUser);
    });
  }

  Future<void> _upsertUser(
    User? user, {
    String? displayNameOverride,
  }) async {
    if (user == null) {
      return;
    }

    final model = AppUserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: displayNameOverride ?? user.displayName ?? 'Carolie User',
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
      displayName: user.displayName ?? 'Carolie User',
      emailVerified: user.emailVerified,
      photoUrl: user.photoURL,
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

String authErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-credential':
        return 'That sign-in attempt could not be verified. Please try again.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'wrong-password':
      case 'invalid-password':
        return 'The password you entered is incorrect.';
      case 'user-not-found':
        return 'No account was found for that email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists for that email address.';
      case 'weak-password':
        return 'Choose a stronger password with at least 8 characters.';
      case 'too-many-requests':
        return 'Too many sign-in attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled for the app yet.';
    }

    return error.message ?? 'Authentication failed. Please try again.';
  }

  if (error is GoogleSignInException) {
    switch (error.code) {
      case GoogleSignInExceptionCode.canceled:
        return 'Google sign-in was canceled.';
      case GoogleSignInExceptionCode.clientConfigurationError:
        return 'Google sign-in is not configured correctly for this app.';
      case GoogleSignInExceptionCode.interrupted:
        return 'Google sign-in was interrupted. Please try again.';
      case GoogleSignInExceptionCode.providerConfigurationError:
        return 'Google sign-in is not available because the iOS app configuration is incomplete.';
      case GoogleSignInExceptionCode.uiUnavailable:
        return 'Google sign-in is unavailable right now. Please try again.';
      case GoogleSignInExceptionCode.userMismatch:
        return 'Please sign out of Google and try again with the correct account.';
      case GoogleSignInExceptionCode.unknownError:
        return error.description ?? 'Google sign-in failed. Please try again.';
    }
  }

  return error.toString();
}

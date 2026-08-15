import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/firebase/firebase_bootstrap.dart';

/// TEMPORARY: Google sign-in is swapped for a simple username/password gate
/// while testing the admin portal locally. Flip this back to `true` (and it
/// reverts to Google-only) before shipping to production.
const bool kAdminUseGoogleSignIn = false;

/// TEMPORARY credentials for the password gate above. Backed by a dedicated
/// Firebase Auth account (not the real owner Google account) so Firestore's
/// `request.auth != null` rule is still satisfied. Remove alongside
/// [kAdminUseGoogleSignIn] before production.
const String kTempAdminUsername = 'gokuladmin';
const String kTempAdminPassword = 'GokulAdmin#2026';
const String _tempAdminEmail = 'temp-admin@gokul-portfolio-dbdda.firebaseapp.com';

class AdminAuthService {
  bool get isEnabled => FirebaseBootstrap.isReady;

  FirebaseAuth get _auth => FirebaseAuth.instance;

  String get allowedEmail => const String.fromEnvironment(
    'ADMIN_ALLOWED_EMAIL',
    defaultValue: 'gokulofficialcommunication@gmail.com',
  );

  Stream<User?> authStateChanges() {
    if (!isEnabled) {
      return Stream.value(null);
    }
    return _auth.authStateChanges();
  }

  bool isOwner(User? user) {
    final email = user?.email?.toLowerCase();
    if (email == allowedEmail.toLowerCase()) return true;
    // TEMPORARY: accept the password-gate's dedicated account too. Remove
    // this branch when kAdminUseGoogleSignIn is reverted to true.
    if (!kAdminUseGoogleSignIn && email == _tempAdminEmail.toLowerCase()) {
      return true;
    }
    return false;
  }

  /// TEMPORARY password-based sign-in — see [kAdminUseGoogleSignIn].
  Future<String?> signInWithPassword(String username, String password) async {
    if (!isEnabled) {
      return FirebaseBootstrap.statusMessage;
    }
    if (username.trim() != kTempAdminUsername || password != kTempAdminPassword) {
      return 'Incorrect username or password.';
    }
    try {
      await _auth.signInWithEmailAndPassword(
        email: _tempAdminEmail,
        password: kTempAdminPassword,
      );
      return null;
    } catch (error) {
      return 'Sign-in failed: $error';
    }
  }

  Future<String?> signInWithGoogle() async {
    if (!isEnabled) {
      return FirebaseBootstrap.statusMessage;
    }

    try {
      UserCredential credential;

      if (kIsWeb) {
        final provider =
            GoogleAuthProvider()
              ..setCustomParameters({'prompt': 'select_account'});
        credential = await _auth.signInWithPopup(provider);
      } else {
        final googleSignIn = GoogleSignIn();
        final account = await googleSignIn.signIn();

        if (account == null) {
          return 'Google sign-in was cancelled.';
        }

        final googleAuth = await account.authentication;
        final authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        credential = await _auth.signInWithCredential(authCredential);
      }

      if (!isOwner(credential.user)) {
        return 'Access denied for ${credential.user?.email ?? 'this account'}.';
      }

      return null;
    } catch (error) {
      return 'Google sign-in failed: $error';
    }
  }

  Future<void> signOut() async {
    if (!isEnabled) {
      return;
    }

    if (!kIsWeb) {
      await GoogleSignIn().signOut();
    }

    await _auth.signOut();
  }
}

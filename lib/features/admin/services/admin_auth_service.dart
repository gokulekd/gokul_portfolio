import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/firebase/firebase_bootstrap.dart';

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
    return user?.email?.toLowerCase() == allowedEmail.toLowerCase();
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
        await signOut();
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

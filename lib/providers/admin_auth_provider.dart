import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/firebase/firebase_bootstrap.dart';
import 'service_providers.dart';

// ─── State ─────────────────────────────────────────────────────────────────

class AdminAuthState {
  const AdminAuthState({
    this.currentUser,
    this.isSigningIn = false,
    this.errorMessage,
  });

  final User? currentUser;
  final bool isSigningIn;
  final String? errorMessage;

  bool get hasAccess => currentUser != null;

  AdminAuthState copyWith({
    User? Function()? currentUser,
    bool? isSigningIn,
    String? Function()? errorMessage,
  }) {
    return AdminAuthState(
      currentUser: currentUser != null ? currentUser() : this.currentUser,
      isSigningIn: isSigningIn ?? this.isSigningIn,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

// ─── Notifier ───────────────────────────────────────────────────────────────

class AdminAuthNotifier extends Notifier<AdminAuthState> {
  @override
  AdminAuthState build() {
    final authService = ref.read(adminAuthServiceProvider);
    final portfolioService = ref.read(firebasePortfolioServiceProvider);

    final sub = authService.authStateChanges().listen((user) async {
      if (user == null) {
        state = state.copyWith(currentUser: () => null);
        return;
      }

      if (!authService.isOwner(user)) {
        state = state.copyWith(
          currentUser: () => null,
          errorMessage: () => 'Only the owner email can access the admin portal.',
        );
        await authService.signOut();
        return;
      }

      state = state.copyWith(currentUser: () => user, errorMessage: () => null);

      try {
        await portfolioService.ensureSeedData(
          ownerEmail: user.email ?? authService.allowedEmail,
        );
      } on FirebaseException catch (error) {
        if (error.code == 'permission-denied') {
          state = state.copyWith(
            errorMessage: () =>
                'Signed in successfully, but Firestore rules are blocking admin data access.',
          );
          return;
        }
        state = state.copyWith(
          errorMessage: () => 'Admin setup failed: ${error.message ?? error.code}',
        );
      } catch (error) {
        state = state.copyWith(errorMessage: () => 'Admin setup failed: $error');
      }
    });

    ref.onDispose(sub.cancel);

    return const AdminAuthState();
  }

  bool get isFirebaseReady => ref.read(adminAuthServiceProvider).isEnabled;
  String get allowedEmail => ref.read(adminAuthServiceProvider).allowedEmail;
  String get firebaseStatusMessage => FirebaseBootstrap.statusMessage;

  Future<void> signIn() async {
    state = state.copyWith(isSigningIn: true, errorMessage: () => null);
    final result = await ref.read(adminAuthServiceProvider).signInWithGoogle();
    if (result != null) state = state.copyWith(errorMessage: () => result);
    state = state.copyWith(isSigningIn: false);
  }

  Future<void> signOut() => ref.read(adminAuthServiceProvider).signOut();
}

final adminAuthProvider = NotifierProvider<AdminAuthNotifier, AdminAuthState>(
  AdminAuthNotifier.new,
);

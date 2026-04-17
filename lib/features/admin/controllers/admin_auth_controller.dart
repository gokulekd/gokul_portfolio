import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../services/firebase_portfolio_service.dart';
import '../services/admin_auth_service.dart';

class AdminAuthController extends GetxController {
  final AdminAuthService _authService = Get.find<AdminAuthService>();
  final FirebasePortfolioService _portfolioService =
      Get.find<FirebasePortfolioService>();

  final currentUser = Rxn<User>();
  final isSigningIn = false.obs;
  final errorMessage = RxnString();

  StreamSubscription<User?>? _authSubscription;

  bool get isFirebaseReady => _authService.isEnabled;
  bool get hasAccess => _authService.isOwner(currentUser.value);
  String get allowedEmail => _authService.allowedEmail;
  String get firebaseStatusMessage => FirebaseBootstrap.statusMessage;

  @override
  void onInit() {
    super.onInit();
    _authSubscription = _authService.authStateChanges().listen(_handleAuth);
  }

  Future<void> _handleAuth(User? user) async {
    currentUser.value = user;

    if (user == null) {
      return;
    }

    if (!_authService.isOwner(user)) {
      errorMessage.value = 'Only the owner email can access the admin portal.';
      await _authService.signOut();
      return;
    }

    errorMessage.value = null;

    await _portfolioService.ensureSeedData(
      ownerEmail: user.email ?? _authService.allowedEmail,
    );
  }

  Future<void> signIn() async {
    isSigningIn.value = true;
    errorMessage.value = null;

    final result = await _authService.signInWithGoogle();
    if (result != null) {
      errorMessage.value = result;
    }

    isSigningIn.value = false;
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}

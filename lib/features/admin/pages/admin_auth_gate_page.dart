import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../controllers/admin_auth_controller.dart';
import 'admin_portal_page.dart';

class AdminAuthGatePage extends StatelessWidget {
  AdminAuthGatePage({super.key});

  final AdminAuthController controller = Get.put(AdminAuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isFirebaseReady) {
        return _AdminSetupState(
          message: controller.firebaseStatusMessage,
          allowedEmail: controller.allowedEmail,
        );
      }

      if (controller.hasAccess) {
        return AdminPortalPage();
      }

      return _AdminLoginState(controller: controller);
    });
  }
}

class _AdminSetupState extends StatelessWidget {
  const _AdminSetupState({required this.message, required this.allowedEmail});

  final String message;
  final String allowedEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0E),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF14171A),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'FIREBASE SETUP REQUIRED',
                      style: GoogleFonts.manrope(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Admin auth is wired, but Firebase credentials are not configured yet.',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: GoogleFonts.manrope(
                      color: Colors.white70,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Expected owner email: $allowedEmail',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Add your Firebase dart-defines for the target platform, then restart the app. Once configured, Google sign-in and Firestore content streams will become active automatically.',
                    style: GoogleFonts.manrope(
                      color: Colors.white60,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminLoginState extends StatelessWidget {
  const _AdminLoginState({required this.controller});

  final AdminAuthController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0E),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryGreen.withValues(alpha: 0.08),
              const Color(0xFF0B0C0E),
              const Color(0xFF111316),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 420,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(
                              alpha: 0.14,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'OWNER AUTHENTICATION',
                            style: GoogleFonts.manrope(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Sign in to manage the live portfolio from Firebase.',
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 34,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'This admin portal is wired for Google authentication and Firestore-backed section/content control. Only the approved owner email can enter.',
                          style: GoogleFonts.manrope(
                            color: Colors.white70,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 420,
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14171A),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin Sign-In',
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Allowed email: ${controller.allowedEmail}',
                              style: GoogleFonts.manrope(
                                color: Colors.white60,
                                height: 1.6,
                              ),
                            ),
                            if (controller.errorMessage.value != null) ...[
                              const SizedBox(height: 18),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFF7C7C,
                                  ).withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFFF7C7C,
                                    ).withValues(alpha: 0.18),
                                  ),
                                ),
                                child: Text(
                                  controller.errorMessage.value!,
                                  style: GoogleFonts.manrope(
                                    color: Colors.white,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed:
                                    controller.isSigningIn.value
                                        ? null
                                        : controller.signIn,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primaryGreen,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                icon:
                                    controller.isSigningIn.value
                                        ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.black,
                                                ),
                                          ),
                                        )
                                        : const Icon(Icons.login_rounded),
                                label: Text(
                                  controller.isSigningIn.value
                                      ? 'Signing in...'
                                      : 'Continue with Google',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

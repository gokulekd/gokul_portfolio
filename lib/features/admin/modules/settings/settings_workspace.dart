import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/admin_auth_provider.dart';
import '../../../../core/providers/admin_portal_provider.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/dialog_widgets.dart';
import '../../shared/preview_tile.dart';

class SettingsWorkspace extends ConsumerStatefulWidget {
  const SettingsWorkspace({
    super.key,
    required this.isCompact,
  });

  final bool isCompact;

  @override
  ConsumerState<SettingsWorkspace> createState() => _SettingsWorkspaceState();
}

class _SettingsWorkspaceState extends ConsumerState<SettingsWorkspace> {
  void _confirmDangerAction(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog<void>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1A1C1F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFFF7C7C),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            content: Text(
              message,
              style: GoogleFonts.manrope(color: Colors.white70, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.manrope(color: Colors.white54),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  onConfirm();
                },
                child: Text(
                  'Confirm',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFFFF7C7C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(adminAuthProvider);
    final authNotifier = ref.read(adminAuthProvider.notifier);
    final portalNotifier = ref.read(adminPortalProvider.notifier);
    final portalState = ref.watch(adminPortalProvider);

    final settingsPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'SETTINGS',
            title: 'Admin configuration',
            description: 'Manage your account and irreversible platform actions.',
          ),
          const SizedBox(height: 24),

          SectionLabel(label: 'ACCOUNT'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: authState.currentUser?.photoURL != null
                      ? ClipOval(
                        child: Image.network(
                          authState.currentUser!.photoURL!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.person_rounded,
                                color: AppColors.primaryGreen,
                              ),
                        ),
                      )
                      : const Icon(
                        Icons.person_rounded,
                        color: AppColors.primaryGreen,
                      ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authState.currentUser?.displayName ?? 'Admin',
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        authState.currentUser?.email ?? authNotifier.allowedEmail,
                        style: GoogleFonts.manrope(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Owner',
                    style: GoogleFonts.manrope(
                      color: AppColors.primaryGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          SectionLabel(label: 'DANGER ZONE'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7C7C).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFFF7C7C).withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFFF7C7C),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Irreversible actions',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFFFF7C7C),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    AdminGhostButton(
                      label: 'Sign out',
                      icon: Icons.logout_rounded,
                      onPressed: () => _confirmDangerAction(
                        context,
                        'Sign out',
                        'You will be returned to the login screen. Any unsaved changes will be lost.',
                        () => authNotifier.signOut(),
                      ),
                    ),
                    AdminGhostButton(
                      label: 'Re-seed Firestore',
                      icon: Icons.restore_rounded,
                      onPressed: () => _confirmDangerAction(
                        context,
                        'Re-seed Firestore',
                        'This will insert default data for any empty collections. Existing data is not overwritten.',
                        () => portalNotifier.reseedFirestore(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final infoPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'SYSTEM INFO',
            title: 'Platform status',
            description: 'Current state of Firebase and connected services.',
          ),
          const SizedBox(height: 18),
          PreviewTile(
            title: 'Firebase',
            value: portalNotifier.isFirebaseConnected
                ? portalState.firestoreErrorMessage == null
                    ? 'Connected & syncing'
                    : 'Connected, fallback mode'
                : 'Not connected',
            icon: portalState.firestoreErrorMessage == null && portalNotifier.isFirebaseConnected
                ? Icons.cloud_done_rounded
                : Icons.cloud_off_rounded,
            color: portalNotifier.isFirebaseConnected
                ? portalState.firestoreErrorMessage == null
                    ? AppColors.primaryGreen
                    : const Color(0xFFFFB44C)
                : const Color(0xFFFF7C7C),
          ),
          const SizedBox(height: 10),
          PreviewTile(
            title: 'Auth',
            value: authState.currentUser != null
                ? 'Signed in as owner'
                : 'Not signed in',
            icon: Icons.verified_user_rounded,
            color: authState.currentUser != null
                ? AppColors.primaryGreen
                : Colors.white38,
          ),
          const SizedBox(height: 10),
          PreviewTile(
            title: 'Live sections',
            value:
                '${portalNotifier.sectionConfigs.where((s) => s.isVisible).length} visible',
            icon: Icons.view_sidebar_rounded,
            color: const Color(0xFF5CD6FF),
          ),
          const SizedBox(height: 10),
          PreviewTile(
            title: 'Projects',
            value: '${portalNotifier.projects.length} in collection',
            icon: Icons.workspaces_rounded,
            color: const Color(0xFFFFB44C),
          ),
        ],
      ),
    );

    if (widget.isCompact) {
      return Column(
        children: [settingsPanel, const SizedBox(height: 18), infoPanel],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: settingsPanel),
        const SizedBox(width: 18),
        Expanded(flex: 5, child: infoPanel),
      ],
    );
  }
}


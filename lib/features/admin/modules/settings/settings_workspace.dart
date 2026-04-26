import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../controllers/admin_auth_controller.dart';
import '../../controllers/admin_portal_controller.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/dialog_widgets.dart';
import '../../shared/preview_tile.dart';

class SettingsWorkspace extends StatefulWidget {
  const SettingsWorkspace({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  @override
  State<SettingsWorkspace> createState() => _SettingsWorkspaceState();
}

class _SettingsWorkspaceState extends State<SettingsWorkspace> {
  bool _notifyNewSubmissions = true;
  bool _notifyProjectUpdates = false;
  bool _notifyBlogSync = true;
  bool _analyticsEnabled = true;
  bool _maintenanceMode = false;

  final _authController = Get.find<AdminAuthController>();

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
    final settingsPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'SETTINGS',
            title: 'Admin configuration',
            description:
                'Manage your account, notifications, and site-level settings.',
          ),
          const SizedBox(height: 24),

          SectionLabel(label: 'ACCOUNT'),
          const SizedBox(height: 12),
          Obx(() {
            final user = _authController.currentUser.value;
            return Container(
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
                    child:
                        user?.photoURL != null
                            ? ClipOval(
                              child: Image.network(
                                user!.photoURL!,
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
                          user?.displayName ?? 'Admin',
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          user?.email ?? _authController.allowedEmail,
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
            );
          }),

          const SizedBox(height: 24),
          SectionLabel(label: 'NOTIFICATIONS'),
          const SizedBox(height: 12),
          SettingsToggleRow(
            icon: Icons.inbox_rounded,
            label: 'New submission alerts',
            description: 'Notify when a visitor submits a contact form',
            value: _notifyNewSubmissions,
            onChanged: (v) => setState(() => _notifyNewSubmissions = v),
          ),
          const SizedBox(height: 10),
          SettingsToggleRow(
            icon: Icons.workspaces_rounded,
            label: 'Project update alerts',
            description: 'Notify when a project is published or edited',
            value: _notifyProjectUpdates,
            onChanged: (v) => setState(() => _notifyProjectUpdates = v),
          ),
          const SizedBox(height: 10),
          SettingsToggleRow(
            icon: Icons.sync_rounded,
            label: 'Dev.to blog sync alerts',
            description: 'Notify when new articles are fetched from Dev.to',
            value: _notifyBlogSync,
            onChanged: (v) => setState(() => _notifyBlogSync = v),
          ),

          const SizedBox(height: 24),
          SectionLabel(label: 'SITE CONFIG'),
          const SizedBox(height: 12),
          SettingsToggleRow(
            icon: Icons.analytics_rounded,
            label: 'Analytics tracking',
            description: 'Enable visitor analytics on the public portfolio',
            value: _analyticsEnabled,
            onChanged: (v) => setState(() => _analyticsEnabled = v),
          ),
          const SizedBox(height: 10),
          SettingsToggleRow(
            icon: Icons.construction_rounded,
            label: 'Maintenance mode',
            description: 'Show a maintenance page instead of the portfolio',
            value: _maintenanceMode,
            color: const Color(0xFFFFB44C),
            onChanged: (v) => setState(() => _maintenanceMode = v),
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
                      onPressed:
                          () => _confirmDangerAction(
                            context,
                            'Sign out',
                            'You will be returned to the login screen. Any unsaved changes will be lost.',
                            _authController.signOut,
                          ),
                    ),
                    AdminGhostButton(
                      label: 'Re-seed Firestore',
                      icon: Icons.restore_rounded,
                      onPressed:
                          () => _confirmDangerAction(
                            context,
                            'Re-seed Firestore',
                            'This will insert default data for any empty collections. Existing data is not overwritten.',
                            () => widget.controller.reseedFirestore(),
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
          Obx(
            () => PreviewTile(
              title: 'Firebase',
              value:
                  widget.controller.isFirebaseConnected
                      ? widget.controller.hasFirestoreAccess
                          ? 'Connected & syncing'
                          : 'Connected, fallback mode'
                      : 'Not connected',
              icon:
                  widget.controller.hasFirestoreAccess
                      ? Icons.cloud_done_rounded
                      : Icons.cloud_off_rounded,
              color:
                  widget.controller.isFirebaseConnected
                      ? widget.controller.hasFirestoreAccess
                          ? AppColors.primaryGreen
                          : const Color(0xFFFFB44C)
                      : const Color(0xFFFF7C7C),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => PreviewTile(
              title: 'Auth',
              value:
                  _authController.currentUser.value != null
                      ? 'Signed in as owner'
                      : 'Not signed in',
              icon: Icons.verified_user_rounded,
              color:
                  _authController.currentUser.value != null
                      ? AppColors.primaryGreen
                      : Colors.white38,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => PreviewTile(
              title: 'Live sections',
              value:
                  '${widget.controller.sectionConfigs.where((s) => s.isVisible).length} visible',
              icon: Icons.view_sidebar_rounded,
              color: const Color(0xFF5CD6FF),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => PreviewTile(
              title: 'Projects',
              value: '${widget.controller.projects.length} in collection',
              icon: Icons.workspaces_rounded,
              color: const Color(0xFFFFB44C),
            ),
          ),
          const SizedBox(height: 10),
          PreviewTile(
            title: 'Notifications',
            value:
                [
                      if (_notifyNewSubmissions) 'Submissions',
                      if (_notifyBlogSync) 'Blog sync',
                      if (_notifyProjectUpdates) 'Projects',
                    ].isEmpty
                    ? 'All off'
                    : [
                      if (_notifyNewSubmissions) 'Submissions',
                      if (_notifyBlogSync) 'Blog sync',
                      if (_notifyProjectUpdates) 'Projects',
                    ].join(', '),
            icon: Icons.notifications_active_rounded,
            color: const Color(0xFFB57AFF),
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

class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
    this.color,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primaryGreen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: c, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.manrope(
                    color: Colors.white38,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: c,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

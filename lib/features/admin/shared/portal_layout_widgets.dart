import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../controllers/admin_portal_controller.dart';
import '../models/admin_portal_models.dart';
import 'admin_portal_components.dart';

class PortalTopBar extends StatelessWidget {
  const PortalTopBar({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasFirestoreAccess = controller.hasFirestoreAccess;

      final actions = Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(
            width: isCompact ? double.infinity : 280,
            child: const AdminSearchField(),
          ),
          const _TopBarPill(
            icon: Icons.notifications_active_rounded,
            label: '3 new leads',
            isHighlighted: true,
          ),
          _TopBarPill(
            icon:
                hasFirestoreAccess
                    ? Icons.cloud_done_rounded
                    : Icons.cloud_off_rounded,
            label: hasFirestoreAccess ? 'Sync ready' : 'Fallback mode',
            isHighlighted: hasFirestoreAccess,
            tone: hasFirestoreAccess ? null : const Color(0xFFFFB44C),
          ),
        ],
      );

      final isOnDashboard =
          controller.selectedModule.value == AdminModule.dashboard;

      if (isCompact) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Builder(
                  builder:
                      (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(
                          Icons.menu_rounded,
                          color: Colors.white,
                        ),
                      ),
                ),
                if (!isOnDashboard) ...[
                  const SizedBox(width: 4),
                  _BackToDashboardButton(controller: controller),
                  const SizedBox(width: 4),
                ] else
                  const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.activeModule.title,
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            actions,
          ],
        );
      }

      return Row(
        children: [
          if (!isOnDashboard) ...[
            _BackToDashboardButton(controller: controller),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Text(
              'Admin Workspace',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          actions,
        ],
      );
    });
  }
}

class _BackToDashboardButton extends StatelessWidget {
  const _BackToDashboardButton({required this.controller});

  final AdminPortalController controller;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => controller.selectModule(AdminModule.dashboard),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white70,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.04),
      ),
      icon: const Icon(Icons.arrow_back_rounded, size: 16),
      label: Text(
        'Dashboard',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
        ),
      ),
    );
  }
}

class _TopBarPill extends StatelessWidget {
  const _TopBarPill({
    required this.icon,
    required this.label,
    this.isHighlighted = false,
    this.tone,
  });

  final IconData icon;
  final String label;
  final bool isHighlighted;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final effectiveTone = tone ?? AppColors.primaryGreen;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color:
            isHighlighted
                ? effectiveTone.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              isHighlighted
                  ? effectiveTone.withValues(alpha: 0.22)
                  : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isHighlighted ? effectiveTone : Colors.white70,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.manrope(
              color: isHighlighted ? effectiveTone : Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class HeroHeader extends StatelessWidget {
  const HeroHeader({super.key, required this.controller});

  final AdminPortalController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final firestoreIssue = controller.firestoreErrorMessage.value;

      return AdminSurfaceCard(
        padding: const EdgeInsets.all(28),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryGreen.withValues(alpha: 0.12),
                const Color(0xFF57D4FF).withValues(alpha: 0.10),
                Colors.white.withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          controller.activeModule.subtitle.toUpperCase(),
                          style: GoogleFonts.manrope(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        controller.pageTitle,
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          height: 1.05,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        controller.pageDescription,
                        style: GoogleFonts.manrope(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.65,
                        ),
                      ),
                      if (firestoreIssue != null) ...[
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFFB44C,
                            ).withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(
                                0xFFFFB44C,
                              ).withValues(alpha: 0.20),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.lock_outline_rounded,
                                color: Color(0xFFFFC261),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  firestoreIssue,
                                  style: GoogleFonts.manrope(
                                    color: Colors.white,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          AdminPrimaryButton(
                            label:
                                controller.selectedModule.value ==
                                        AdminModule.dashboard
                                    ? 'Open Site Structure'
                                    : 'Create New Entry',
                            icon:
                                controller.selectedModule.value ==
                                        AdminModule.dashboard
                                    ? Icons.view_agenda_rounded
                                    : Icons.add_rounded,
                            onPressed: () {
                              if (controller.selectedModule.value ==
                                  AdminModule.dashboard) {
                                controller.selectModule(
                                  AdminModule.siteStructure,
                                );
                              }
                            },
                          ),
                          AdminGhostButton(
                            label: 'Preview Live Site',
                            icon: Icons.open_in_new_rounded,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 270),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.24),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color:
                                  controller.hasFirestoreAccess
                                      ? AppColors.primaryGreen
                                      : const Color(0xFFFFC261),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              controller.hasFirestoreAccess
                                  ? 'Live sync architecture'
                                  : 'Fallback architecture',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          controller.hasFirestoreAccess
                              ? 'Ready for Firebase wiring'
                              : 'Firestore rules need update',
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          controller.hasFirestoreAccess
                              ? 'This shell is structured so visibility rules, content collections, and notifications can plug into real data without replacing the UI.'
                              : 'The admin UI is still available with local fallback data, but Firestore reads and writes are currently blocked.',
                          style: GoogleFonts.manrope(
                            color: Colors.white60,
                            height: 1.6,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../../../models/firebase_content_models.dart';
import '../../controllers/admin_portal_controller.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/preview_tile.dart';

class SiteStructureWorkspace extends StatelessWidget {
  const SiteStructureWorkspace({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final sectionList = AdminSurfaceCard(
      child: Obx(() {
        final sections = controller.sectionConfigs;
        final liveCount = sections.where((s) => s.isVisible).length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionHeader(
              eyebrow: 'SITE STRUCTURE',
              title: 'Section visibility',
              description:
                  '$liveCount of ${sections.length} sections are visible. Toggling updates Firestore immediately.',
            ),
            const SizedBox(height: 18),
            ...sections.map(
              (section) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SectionRow(
                  section: section,
                  onChanged:
                      (val) => controller.updateSectionVisibility(section, val),
                ),
              ),
            ),
          ],
        );
      }),
    );

    final statsPanel = AdminSurfaceCard(
      child: Obx(() {
        final sections = controller.sectionConfigs;
        final liveCount = sections.where((s) => s.isVisible).length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminSectionHeader(
              eyebrow: 'STRUCTURE STATS',
              title: 'Section overview',
              description:
                  'Current visibility state of all portfolio sections.',
            ),
            const SizedBox(height: 18),
            PreviewTile(
              title: 'Total sections',
              value: '${sections.length} sections configured',
              icon: Icons.view_sidebar_rounded,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 12),
            PreviewTile(
              title: 'Live sections',
              value: '$liveCount sections visible',
              icon: Icons.visibility_rounded,
              color: const Color(0xFF5CD6FF),
            ),
            const SizedBox(height: 12),
            PreviewTile(
              title: 'Hidden sections',
              value: '${sections.length - liveCount} sections hidden',
              icon: Icons.visibility_off_rounded,
              color: const Color(0xFFFF7C7C),
            ),
            const SizedBox(height: 12),
            PreviewTile(
              title: 'Data source',
              value:
                  controller.isFirebaseConnected
                      ? 'Live Firestore sync'
                      : 'Local fallback data',
              icon: Icons.cloud_sync_rounded,
              color: const Color(0xFFFFB44C),
            ),
          ],
        );
      }),
    );

    if (isCompact) {
      return Column(
        children: [sectionList, const SizedBox(height: 18), statsPanel],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: sectionList),
        const SizedBox(width: 18),
        Expanded(flex: 4, child: statsPanel),
      ],
    );
  }
}

class SectionRow extends StatelessWidget {
  const SectionRow({super.key, required this.section, required this.onChanged});

  final SiteSectionConfig section;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              section.displayOrder.toString().padLeft(2, '0'),
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  section.description,
                  style: GoogleFonts.manrope(
                    color: Colors.white60,
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AdminStateChip(
                state:
                    section.isVisible
                        ? AdminItemState.live
                        : AdminItemState.hidden,
              ),
              const SizedBox(height: 10),
              Text(
                section.updatedAt == null
                    ? 'Synced document'
                    : 'Firestore linked',
                style: GoogleFonts.manrope(
                  color: Colors.white54,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Switch(
            value: section.isVisible,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }
}

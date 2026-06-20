import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../../../providers/admin_portal_provider.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/admin_portal_components.dart';

class SiteStructureWorkspace extends ConsumerWidget {
  const SiteStructureWorkspace({
    super.key,
    required this.isCompact,
  });

  final bool isCompact;

  static const _pageIcons = <String, IconData>{
    SitePageKeys.home: Icons.home_rounded,
    SitePageKeys.about: Icons.person_rounded,
    SitePageKeys.myWork: Icons.workspaces_rounded,
    SitePageKeys.resume: Icons.description_rounded,
    SitePageKeys.blog: Icons.edit_note_rounded,
  };

  static const _pageColors = <String, Color>{
    SitePageKeys.home: AppColors.primaryGreen,
    SitePageKeys.about: Color(0xFF5CD6FF),
    SitePageKeys.myWork: Color(0xFFFFB44C),
    SitePageKeys.resume: Color(0xFFFF7C7C),
    SitePageKeys.blog: Color(0xFFB57AFF),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adminPortalProvider.notifier);
    final pages = notifier.pageConfigs;
    final liveCount = pages.where((p) => p.isVisible).length;

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'SITE STRUCTURE',
            title: 'Page visibility',
            description:
                '$liveCount of ${pages.length} pages are visible. Toggling updates Firestore immediately.',
          ),
          const SizedBox(height: 18),
          ...pages.map(
            (page) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PageRow(
                page: page,
                icon: _pageIcons[page.key] ?? Icons.web_rounded,
                color: _pageColors[page.key] ?? AppColors.primaryGreen,
                onChanged: (val) => notifier.updatePageVisibility(page, val),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageRow extends StatelessWidget {
  const _PageRow({
    required this.page,
    required this.icon,
    required this.color,
    required this.onChanged,
  });

  final SitePageConfig page;
  final IconData icon;
  final Color color;
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
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  page.title,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        page.route,
                        style: GoogleFonts.manrope(
                          color: Colors.white54,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AdminStateChip(
            state: page.isVisible ? AdminItemState.live : AdminItemState.hidden,
          ),
          const SizedBox(width: 12),
          Switch(
            value: page.isVisible,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }
}

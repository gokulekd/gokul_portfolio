import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../../../models/firebase_content_models.dart';
import '../../controllers/admin_portal_controller.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/preview_tile.dart';

class ManagePagesWorkspace extends StatelessWidget {
  const ManagePagesWorkspace({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  static const _pages = [
    _PageEntry(
      icon: Icons.home_rounded,
      name: 'Home Page',
      route: '/',
      description: 'Hero section, intro, and CTA',
      defaultLive: true,
      color: AppColors.primaryGreen,
      sectionKey: SiteSectionKeys.hero,
    ),
    _PageEntry(
      icon: Icons.person_rounded,
      name: 'About / Skills',
      route: '/#about',
      description: 'Skills, experience timeline, and stack',
      defaultLive: true,
      color: Color(0xFF5CD6FF),
      sectionKey: SiteSectionKeys.skillsExperience,
    ),
    _PageEntry(
      icon: Icons.workspaces_rounded,
      name: 'Projects',
      route: '/#projects',
      description: 'Featured work and portfolio items',
      defaultLive: true,
      color: Color(0xFFFFB44C),
      sectionKey: SiteSectionKeys.featuredProjects,
    ),
    _PageEntry(
      icon: Icons.workspace_premium_rounded,
      name: 'Achievements',
      route: '/#achievements',
      description: 'Milestones, metrics, and proof points',
      defaultLive: true,
      color: Color(0xFFFF7C7C),
      sectionKey: SiteSectionKeys.achievements,
    ),
    _PageEntry(
      icon: Icons.auto_awesome_rounded,
      name: 'Guiding Principles',
      route: '/#principles',
      description: 'Values and creative operating philosophy',
      defaultLive: true,
      color: Color(0xFFB57AFF),
      sectionKey: SiteSectionKeys.guidingPrinciples,
    ),
    _PageEntry(
      icon: Icons.route_rounded,
      name: 'Freelance Process',
      route: '/#process',
      description: 'Client journey and collaboration flow',
      defaultLive: true,
      color: Color(0xFF57D4FF),
      sectionKey: SiteSectionKeys.freelanceProcess,
    ),
    _PageEntry(
      icon: Icons.record_voice_over_rounded,
      name: 'Testimonials',
      route: '/#testimonials',
      description: 'Client feedback and social proof',
      defaultLive: false,
      color: Color(0xFFFFD700),
      sectionKey: SiteSectionKeys.testimonials,
    ),
    _PageEntry(
      icon: Icons.quiz_rounded,
      name: 'FAQ',
      route: '/#faq',
      description: 'Frequently asked questions',
      defaultLive: false,
      color: Color(0xFF5CD6FF),
      sectionKey: SiteSectionKeys.faq,
    ),
    _PageEntry(
      icon: Icons.mail_rounded,
      name: 'Contact Us',
      route: '/#contact',
      description: 'Contact form and social links',
      defaultLive: true,
      color: AppColors.primaryGreen,
      sectionKey: SiteSectionKeys.contact,
    ),
    _PageEntry(
      icon: Icons.edit_note_rounded,
      name: 'Blog',
      route: '/blog',
      description: 'Editorial posts and articles',
      defaultLive: false,
      color: Color(0xFFFFB44C),
    ),
    _PageEntry(
      icon: Icons.admin_panel_settings_rounded,
      name: 'Admin Portal',
      route: '/admin',
      description: 'Backend management workspace',
      defaultLive: true,
      color: Color(0xFFFF7C7C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pageList = AdminSurfaceCard(
      child: Obx(() {
        final sections = controller.liveSections;
        final liveCount =
            _pages.where((p) {
              if (p.sectionKey == null) return p.defaultLive;
              final section = sections.firstWhereOrNull(
                (s) => s.key == p.sectionKey,
              );
              return section?.isVisible ?? p.defaultLive;
            }).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionHeader(
              eyebrow: 'PORTFOLIO PAGES',
              title: 'All pages across your site',
              description:
                  '$liveCount of ${_pages.length} pages are currently live. Toggle visibility to show or hide sections.',
            ),
            const SizedBox(height: 18),
            ..._pages.map((page) {
              final section =
                  page.sectionKey != null
                      ? sections.firstWhereOrNull(
                        (s) => s.key == page.sectionKey,
                      )
                      : null;
              final isLive = section?.isVisible ?? page.defaultLive;
              final canToggle = section != null;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PageRow(
                  page: page,
                  controller: controller,
                  section: section,
                  isLive: isLive,
                  canToggle: canToggle,
                ),
              );
            }),
          ],
        );
      }),
    );

    final statsPanel = AdminSurfaceCard(
      child: Obx(() {
        final sections = controller.liveSections;
        final liveCount =
            _pages.where((p) {
              if (p.sectionKey == null) return p.defaultLive;
              final section = sections.firstWhereOrNull(
                (s) => s.key == p.sectionKey,
              );
              return section?.isVisible ?? p.defaultLive;
            }).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminSectionHeader(
              eyebrow: 'PAGE STATS',
              title: 'Site overview',
              description:
                  'Summary of all pages and their current publish status.',
            ),
            const SizedBox(height: 18),
            PreviewTile(
              title: 'Total pages',
              value: '${_pages.length} pages configured',
              icon: Icons.web_rounded,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 12),
            PreviewTile(
              title: 'Live pages',
              value: '$liveCount pages published',
              icon: Icons.visibility_rounded,
              color: const Color(0xFF5CD6FF),
            ),
            const SizedBox(height: 12),
            PreviewTile(
              title: 'Draft pages',
              value: '${_pages.length - liveCount} hidden from public',
              icon: Icons.visibility_off_rounded,
              color: const Color(0xFFFF7C7C),
            ),
          ],
        );
      }),
    );

    if (isCompact) {
      return Column(
        children: [pageList, const SizedBox(height: 18), statsPanel],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: pageList),
        const SizedBox(width: 18),
        Expanded(flex: 4, child: statsPanel),
      ],
    );
  }
}

class _PageEntry {
  const _PageEntry({
    required this.icon,
    required this.name,
    required this.route,
    required this.description,
    required this.defaultLive,
    required this.color,
    this.sectionKey,
  });

  final IconData icon;
  final String name;
  final String route;
  final String description;
  final bool defaultLive;
  final Color color;
  final String? sectionKey;
}

class _PageRow extends StatelessWidget {
  const _PageRow({
    required this.page,
    required this.controller,
    required this.section,
    required this.isLive,
    required this.canToggle,
  });

  final _PageEntry page;
  final AdminPortalController controller;
  final SiteSectionConfig? section;
  final bool isLive;
  final bool canToggle;

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(page.icon, color: page.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  page.name,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
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
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AdminStateChip(
                state: isLive ? AdminItemState.live : AdminItemState.hidden,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: canToggle ? '' : 'Connect Firestore to toggle',
                    child: Transform.scale(
                      scale: 0.82,
                      child: Switch(
                        value: isLive,
                        onChanged:
                            canToggle
                                ? (val) => controller.updateSectionVisibility(
                                  section!,
                                  val,
                                )
                                : null,
                        activeThumbColor: AppColors.primaryGreen,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.open_in_new_rounded,
                      color: Colors.white54,
                      size: 16,
                    ),
                    tooltip: 'Preview',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/portfolio_controller.dart';
import '../../features/admin/modules/projects/models/app_project.dart';
import '../../routes/app_routes.dart';
import '../../utils/responsive_helper.dart';

// Accent palette — cycles through cards
const _kAccents = [
  Color(0xFF6C63FF), // violet
  Color(0xFF00C9A7), // teal
  Color(0xFFFF6B6B), // coral
  Color(0xFFFFB347), // amber
];

class FeaturedProjectsSection extends StatelessWidget {
  const FeaturedProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : isTablet ? 60 : 80,
        horizontal: isMobile ? 16 : isTablet ? 24 : 40,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SectionHeader(isMobile: isMobile, isTablet: isTablet),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: _ClientButton(isMobile: isMobile, isTablet: isTablet, controller: controller),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: _SectionHeader(isMobile: isMobile, isTablet: isTablet)),
                    const SizedBox(width: 16),
                    _ClientButton(isMobile: isMobile, isTablet: isTablet, controller: controller),
                  ],
                ),

          SizedBox(height: isMobile ? 32 : isTablet ? 48 : 60),

          Obx(() {
            final featured = controller.featuredAppProjects;
            if (featured.isEmpty) return const SizedBox.shrink();
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: featured.length,
              separatorBuilder: (_, __) => const SizedBox(height: 28),
              itemBuilder: (context, index) => AppProjectCard(
                project: featured[index],
                index: index,
              ),
            );
          }),

          SizedBox(height: isMobile ? 24 : 40),

          Center(
            child: OutlinedButton(
              onPressed: () {
                controller.changePage(3);
                Get.offNamed(AppRoutes.projects);
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 32,
                  vertical: isMobile ? 14 : 16,
                ),
                side: const BorderSide(color: Colors.black87),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "View All Projects",
                style: GoogleFonts.manrope(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.isMobile, required this.isTablet});
  final bool isMobile;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "SELECTED WORK",
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.black38,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Featured Projects",
          style: GoogleFonts.manrope(
            fontSize: isMobile ? 28 : isTablet ? 40 : 48,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            height: 1.1,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ClientButton extends StatelessWidget {
  const _ClientButton({
    required this.isMobile,
    required this.isTablet,
    required this.controller,
  });
  final bool isMobile;
  final bool isTablet;
  final PortfolioController controller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        controller.changePage(5);
        Get.offNamed(AppRoutes.contact);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 24,
          vertical: isMobile ? 14 : 16,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        "Become a client",
        style: GoogleFonts.manrope(
          fontSize: isMobile ? 14 : 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── AppProject Card ──────────────────────────────────────────────────────────

class AppProjectCard extends StatefulWidget {
  const AppProjectCard({super.key, required this.project, required this.index});
  final AppProject project;
  final int index;

  @override
  State<AppProjectCard> createState() => _AppProjectCardState();
}

class _AppProjectCardState extends State<AppProjectCard> {
  bool _hovered = false;

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final accent = _kAccents[widget.index % _kAccents.length];
    final indexLabel = (widget.index + 1).toString().padLeft(2, '0');

    // Alternate layout direction on desktop
    final flipLayout = !isMobile && widget.index.isOdd;

    final bannerWidget = _BannerImage(
      url: project.appBannerUrl,
      accent: accent,
      flipGradient: flipLayout,
    );

    final infoWidget = _InfoPanel(
      project: project,
      isMobile: isMobile,
      accent: accent,
      indexLabel: indexLabel,
      onLaunch: _launch,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0F12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hovered
                ? accent.withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.07),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? accent.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.3),
              blurRadius: _hovered ? 40 : 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 300, child: bannerWidget),
                  infoWidget,
                ],
              )
            : SizedBox(
                height: 460,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: flipLayout
                      ? [
                          Expanded(
                            flex: 4,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                bottomLeft: Radius.circular(24),
                              ),
                              child: bannerWidget,
                            ),
                          ),
                          Expanded(flex: 5, child: infoWidget),
                        ]
                      : [
                          Expanded(flex: 5, child: infoWidget),
                          Expanded(
                            flex: 4,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                              child: bannerWidget,
                            ),
                          ),
                        ],
                ),
              ),
      ),
    );
  }

  AppProject get project => widget.project;
}

// ─── Banner with gradient overlay ────────────────────────────────────────────

class _BannerImage extends StatelessWidget {
  const _BannerImage({
    required this.url,
    required this.accent,
    required this.flipGradient,
  });
  final String url;
  final Color accent;
  final bool flipGradient;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Subtle tinted background
        Container(color: accent.withValues(alpha: 0.06)),

        // Project banner
        if (url.isNotEmpty)
          Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          )
        else
          Center(
            child: Icon(Icons.image_rounded, color: Colors.white12, size: 48),
          ),

        // Gradient fade toward the info panel side
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: flipGradient ? Alignment.centerRight : Alignment.centerLeft,
                end: flipGradient ? Alignment.centerLeft : Alignment.centerRight,
                colors: [
                  const Color(0xFF0D0F12).withValues(alpha: 0.55),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5],
              ),
            ),
          ),
        ),

        // Subtle accent glow at top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 3,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent.withValues(alpha: 0.0), accent, accent.withValues(alpha: 0.0)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Info Panel ───────────────────────────────────────────────────────────────

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.project,
    required this.isMobile,
    required this.accent,
    required this.indexLabel,
    required this.onLaunch,
  });

  final AppProject project;
  final bool isMobile;
  final Color accent;
  final String indexLabel;
  final Future<void> Function(String) onLaunch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0D0F12),
            Color.lerp(const Color(0xFF0D0F12), accent, 0.06)!,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Index number
          Text(
            indexLabel,
            style: GoogleFonts.manrope(
              color: accent.withValues(alpha: 0.5),
              fontSize: isMobile ? 12 : 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),

          // Icon + Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (project.appIconUrl.isNotEmpty) ...[
                Container(
                  width: isMobile ? 42 : 52,
                  height: isMobile ? 42 : 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: accent.withValues(alpha: 0.25)),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    project.appIconUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.white.withValues(alpha: 0.05),
                      child: const Icon(Icons.apps_rounded, color: Colors.white24, size: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Text(
                  project.appName,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: isMobile ? 20 : 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Divider accent line
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 2,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          if (project.appDescription.isNotEmpty)
            Text(
              project.appDescription,
              style: GoogleFonts.manrope(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: isMobile ? 13 : 14,
                height: 1.65,
              ),
              maxLines: isMobile ? 5 : 4,
              overflow: TextOverflow.ellipsis,
            ),

          const SizedBox(height: 24),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (project.appWebsiteUrl.isNotEmpty)
                _LinkPill(
                  label: 'Website',
                  icon: Icons.language_rounded,
                  accent: accent,
                  onTap: () => onLaunch(project.appWebsiteUrl),
                  filled: true,
                ),
              if (project.githubUrl?.isNotEmpty ?? false)
                _LinkPill(
                  label: 'GitHub',
                  icon: Icons.code_rounded,
                  onTap: () => onLaunch(project.githubUrl!),
                ),
              _LinkPill(
                label: project.playStoreUrl?.isNotEmpty ?? false
                    ? 'Play Store'
                    : 'Play Store · Soon',
                icon: Icons.shop_rounded,
                accent: const Color(0xFF34A853),
                onTap: project.playStoreUrl?.isNotEmpty ?? false
                    ? () => onLaunch(project.playStoreUrl!)
                    : null,
              ),
              _LinkPill(
                label: project.appStoreUrl?.isNotEmpty ?? false
                    ? 'App Store'
                    : 'App Store · Soon',
                icon: Icons.apple_rounded,
                accent: const Color(0xFF5CD6FF),
                onTap: project.appStoreUrl?.isNotEmpty ?? false
                    ? () => onLaunch(project.appStoreUrl!)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Link Pill ────────────────────────────────────────────────────────────────

class _LinkPill extends StatefulWidget {
  const _LinkPill({
    required this.label,
    required this.icon,
    // nullable — null means "coming soon" (disabled)
    required this.onTap,
    this.accent,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? accent;
  final bool filled;

  @override
  State<_LinkPill> createState() => _LinkPillState();
}

class _LinkPillState extends State<_LinkPill> {
  bool _hovered = false;

  bool get _disabled => widget.onTap == null;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.accent ?? Colors.white70;
    final color = _disabled ? baseColor.withValues(alpha: 0.3) : baseColor;
    final bg = _disabled
        ? (widget.accent ?? Colors.white).withValues(alpha: 0.03)
        : widget.filled
            ? (_hovered ? baseColor.withValues(alpha: 0.22) : baseColor.withValues(alpha: 0.13))
            : (_hovered
                ? (widget.accent ?? Colors.white).withValues(alpha: 0.13)
                : (widget.accent ?? Colors.white).withValues(alpha: 0.07));

    return MouseRegion(
      onEnter: _disabled ? null : (_) => setState(() => _hovered = true),
      onExit: _disabled ? null : (_) => setState(() => _hovered = false),
      cursor: _disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: _disabled
                  ? (widget.accent ?? Colors.white).withValues(alpha: 0.08)
                  : (widget.accent ?? Colors.white).withValues(alpha: _hovered ? 0.35 : 0.18),
              style: _disabled ? BorderStyle.solid : BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 14, color: color),
              const SizedBox(width: 7),
              Text(
                widget.label,
                style: GoogleFonts.manrope(
                  color: color,
                  fontSize: 13,
                  fontWeight: _disabled ? FontWeight.w500 : FontWeight.w600,
                ),
              ),
              if (widget.filled && !_disabled) ...[
                const SizedBox(width: 5),
                Icon(Icons.arrow_outward_rounded, size: 12, color: color.withValues(alpha: 0.7)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

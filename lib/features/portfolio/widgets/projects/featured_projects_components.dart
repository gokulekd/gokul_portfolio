import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../features/admin/modules/projects/models/app_project.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/responsive_helper.dart';

// Accent palette — cycles through cards
const kAccents = [
  Color(0xFF6C63FF), // violet
  Color(0xFF00C9A7), // teal
  Color(0xFFFF6B6B), // coral
  Color(0xFFFFB347), // amber
];

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.isMobile, required this.isTablet});
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

class ClientButton extends ConsumerWidget {
  const ClientButton({super.key, required this.isMobile,
    required this.isTablet,});
  final bool isMobile;
  final bool isTablet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(portfolioProvider.notifier).changePage(5);
        context.go(AppRoutes.contact);
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
    final accent = kAccents[widget.index % kAccents.length];
    final indexLabel = (widget.index + 1).toString().padLeft(2, '0');

    // Alternate layout direction on desktop
    final flipLayout = !isMobile && widget.index.isOdd;

    final bannerWidget = BannerImage(
      url: project.appBannerUrl,
      accent: accent,
      flipGradient: flipLayout,
    );

    final infoWidget = InfoPanel(
      project: project,
      isMobile: isMobile,
      accent: accent,
      indexLabel: indexLabel,
      onLaunch: _launch,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(
          AppRoutes.projectDetail.replaceFirst(':id', project.id),
        ),
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
      ),
    );
  }

  AppProject get project => widget.project;
}

// ─── Banner with gradient overlay ────────────────────────────────────────────

class BannerImage extends StatelessWidget {
  const BannerImage({super.key, required this.url,
    required this.accent,
    required this.flipGradient,});
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

class InfoPanel extends StatelessWidget {
  const InfoPanel({super.key, required this.project,
    required this.isMobile,
    required this.accent,
    required this.indexLabel,
    required this.onLaunch,});

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
              maxLines: project.techStack.isNotEmpty
                  ? (isMobile ? 3 : 2)
                  : (isMobile ? 5 : 4),
              overflow: TextOverflow.ellipsis,
            ),

          if (project.techStack.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: project.techStack.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: accent.withValues(alpha: 0.25)),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.manrope(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )).toList(),
            ),
          ],

          const SizedBox(height: 20),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (project.appWebsiteUrl.isNotEmpty)
                LinkPill(
                  label: 'Website',
                  icon: Icons.language_rounded,
                  accent: accent,
                  onTap: () => onLaunch(project.appWebsiteUrl),
                  filled: true,
                ),
              if (project.githubUrl?.isNotEmpty ?? false)
                LinkPill(
                  label: 'GitHub',
                  icon: Icons.code_rounded,
                  onTap: () => onLaunch(project.githubUrl!),
                ),
              LinkPill(
                label: project.playStoreUrl?.isNotEmpty ?? false
                    ? 'Play Store'
                    : 'Play Store · Soon',
                icon: Icons.shop_rounded,
                accent: const Color(0xFF34A853),
                onTap: project.playStoreUrl?.isNotEmpty ?? false
                    ? () => onLaunch(project.playStoreUrl!)
                    : null,
              ),
              LinkPill(
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

// ─── Link Button ─────────────────────────────────────────────────────────────

class LinkPill extends StatefulWidget {
  const LinkPill({super.key, required this.label,
    required this.icon,
    required this.onTap,
    this.accent,
    this.filled = false,});

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? accent;
  final bool filled;

  @override
  State<LinkPill> createState() => _LinkPillState();
}

class _LinkPillState extends State<LinkPill> {
  bool _hovered = false;

  bool get _disabled => widget.onTap == null;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.accent ?? Colors.white;
    final isDisabled = _disabled;

    final bg = isDisabled
        ? Colors.white.withValues(alpha: 0.04)
        : widget.filled
            ? (_hovered ? baseColor.withValues(alpha: 0.95) : baseColor.withValues(alpha: 0.85))
            : (_hovered
                ? Colors.white.withValues(alpha: 0.10)
                : Colors.white.withValues(alpha: 0.06));

    final fgColor = isDisabled
        ? Colors.white24
        : widget.filled
            ? Colors.black
            : (widget.accent ?? Colors.white70);

    final borderColor = isDisabled
        ? Colors.white.withValues(alpha: 0.08)
        : widget.filled
            ? Colors.transparent
            : (widget.accent ?? Colors.white).withValues(alpha: _hovered ? 0.5 : 0.25);

    return MouseRegion(
      onEnter: isDisabled ? null : (_) => setState(() => _hovered = true),
      onExit: isDisabled ? null : (_) => setState(() => _hovered = false),
      cursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 15, color: fgColor),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.manrope(
                  color: fgColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (!isDisabled) ...[
                const SizedBox(width: 5),
                Icon(Icons.arrow_outward_rounded, size: 12, color: fgColor.withValues(alpha: 0.6)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

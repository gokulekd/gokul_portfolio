import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../features/admin/modules/projects/models/app_project.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/responsive_helper.dart';

// Card surface colors — flat dark charcoal, no per-card accent cycling.
const _kCardBg = Color(0xFF141414);
const _kPanelBg = Color(0xFF161616);

// Max tech-stack tags rendered before collapsing the rest into a "+N" chip.
const _kMaxTechTags = 8;

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

    final bannerWidget = BannerImage(url: project.appBannerUrl);

    final infoWidget = InfoPanel(
      project: project,
      isMobile: isMobile,
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
          color: _kCardBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _hovered
                ? AppColors.primaryGreen.withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.07),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? AppColors.primaryGreen.withValues(alpha: 0.15)
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
                  SizedBox(height: 260, child: bannerWidget),
                  infoWidget,
                ],
              )
            : ConstrainedBox(
                // Grows to fit whatever the info panel needs (long
                // descriptions, many tech tags) instead of clipping it —
                // 440 is just a floor so short cards still look substantial.
                constraints: const BoxConstraints(minHeight: 440),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 35, child: infoWidget),
                      Expanded(
                        flex: 65,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(28),
                            bottomRight: Radius.circular(28),
                          ),
                          child: bannerWidget,
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

  AppProject get project => widget.project;
}

// ─── Banner with gradient overlay ────────────────────────────────────────────

class BannerImage extends StatelessWidget {
  const BannerImage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Neutral backdrop so partially-transparent/loading images don't flash white
        Container(color: const Color(0xFF1C1C1C)),

        // Project screenshot / preview
        if (url.isNotEmpty)
          Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Center(
              child: Icon(Icons.image_rounded, color: Colors.white12, size: 48),
            ),
          )
        else
          Center(
            child: Icon(Icons.image_rounded, color: Colors.white12, size: 48),
          ),

        // Thin seam blend where the image meets the info panel
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  _kCardBg.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.08],
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
  const InfoPanel({
    super.key,
    required this.project,
    required this.isMobile,
    required this.onLaunch,
  });

  final AppProject project;
  final bool isMobile;
  final Future<void> Function(String) onLaunch;

  /// The link the big primary button should open — prefer the live site,
  /// fall back to the repo if there's no website yet.
  String? get _primaryUrl {
    if (project.appWebsiteUrl.isNotEmpty) return project.appWebsiteUrl;
    if (project.githubUrl?.isNotEmpty ?? false) return project.githubUrl;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Secondary links: whatever wasn't already used as the primary CTA.
    final primary = _primaryUrl;
    final secondaryLinks = <(IconData, String)>[
      if (project.appWebsiteUrl.isNotEmpty && primary != project.appWebsiteUrl)
        (Icons.language_rounded, project.appWebsiteUrl),
      if ((project.githubUrl?.isNotEmpty ?? false) && primary != project.githubUrl)
        (Icons.code_rounded, project.githubUrl!),
      if (project.playStoreUrl?.isNotEmpty ?? false)
        (Icons.shop_rounded, project.playStoreUrl!),
      if (project.appStoreUrl?.isNotEmpty ?? false)
        (Icons.apple_rounded, project.appStoreUrl!),
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 36),
      color: _kPanelBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // App name
          Text(
            project.appName,
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: isMobile ? 22 : 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.15,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),

          if (project.appDescription.isNotEmpty)
            Text(
              project.appDescription,
              style: GoogleFonts.manrope(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: isMobile ? 13 : 14,
                height: 1.55,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

          if (project.techStack.isNotEmpty) ...[
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Cap how many tags render — an unusually long tech stack
                // shouldn't be able to balloon the card's height unbounded.
                for (final tag in project.techStack.take(_kMaxTechTags))
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.10),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                if (project.techStack.length > _kMaxTechTags)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Text(
                      '+${project.techStack.length - _kMaxTechTags}',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
              ],
            ),
          ],

          const SizedBox(height: 28),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (primary != null) CheckItButton(onTap: () => onLaunch(primary)),
              if (secondaryLinks.isNotEmpty) ...[
                const SizedBox(width: 10),
                ...secondaryLinks.map(
                  (link) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconLinkButton(
                      icon: link.$1,
                      onTap: () => onLaunch(link.$2),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Primary CTA ("Check it ↗") ──────────────────────────────────────────────

class CheckItButton extends StatefulWidget {
  const CheckItButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  State<CheckItButton> createState() => _CheckItButtonState();
}

class _CheckItButtonState extends State<CheckItButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.primaryGreen
                : AppColors.primaryGreen.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Check it',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.north_east_rounded, size: 15, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Secondary icon-only link (GitHub / Play Store / App Store) ─────────────

class IconLinkButton extends StatefulWidget {
  const IconLinkButton({super.key, required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<IconLinkButton> createState() => _IconLinkButtonState();
}

class _IconLinkButtonState extends State<IconLinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: _hovered ? 0.12 : 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Icon(widget.icon, size: 17, color: Colors.white70),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/admin/modules/projects/models/app_project.dart';
import '../controllers/portfolio_controller.dart';
import '../utils/responsive_helper.dart';
import '../widgets/shared/custom_widgets.dart';

const _kAccents = [
  Color(0xFF6C63FF),
  Color(0xFF00C9A7),
  Color(0xFFFF6B6B),
  Color(0xFFFFB347),
];

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projectId = Get.parameters['id'] ?? '';
    final controller = Get.find<PortfolioController>();

    final AppProject? project = controller.appProjects
        .firstWhereOrNull((p) => p.id == projectId);

    if (project == null) {
      return Scaffold(
        appBar: const CustomAppBar(),
        drawer: const CustomDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_off_rounded, size: 64, color: Colors.black26),
              const SizedBox(height: 16),
              Text(
                'Project not found',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Go back',
                  style: GoogleFonts.manrope(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _ProjectDetailView(project: project);
  }
}

class _ProjectDetailView extends StatelessWidget {
  const _ProjectDetailView({required this.project});
  final AppProject project;

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    // Pick accent based on display order
    final accent = _kAccents[project.displayOrder % _kAccents.length];

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      backgroundColor: const Color(0xFF0D0F12),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Banner ────────────────────────────────────────────────────
            _BannerSection(project: project, accent: accent, isMobile: isMobile),

            // ── Content ───────────────────────────────────────────────────
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : isTablet ? 32 : 48,
                    vertical: isMobile ? 32 : 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row: icon + name
                      _ProjectHeader(project: project, accent: accent, isMobile: isMobile),
                      const SizedBox(height: 24),

                      // Accent divider
                      Row(children: [
                        Container(width: 48, height: 3, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 8),
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: accent.withValues(alpha: 0.4), shape: BoxShape.circle)),
                      ]),
                      const SizedBox(height: 28),

                      // Description
                      if (project.appDescription.isNotEmpty) ...[
                        Text(
                          'About this project',
                          style: GoogleFonts.manrope(
                            fontSize: isMobile ? 13 : 14,
                            fontWeight: FontWeight.w700,
                            color: accent,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          project.appDescription,
                          style: GoogleFonts.manrope(
                            fontSize: isMobile ? 15 : 17,
                            color: Colors.white.withValues(alpha: 0.75),
                            height: 1.75,
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],

                      // Links
                      Text(
                        'Links',
                        style: GoogleFonts.manrope(
                          fontSize: isMobile ? 13 : 14,
                          fontWeight: FontWeight.w700,
                          color: accent,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          if (project.appWebsiteUrl.isNotEmpty)
                            _DetailLinkButton(
                              label: 'Visit Website',
                              icon: Icons.language_rounded,
                              accent: accent,
                              filled: true,
                              onTap: () => _launch(project.appWebsiteUrl),
                            ),
                          if (project.githubUrl?.isNotEmpty ?? false)
                            _DetailLinkButton(
                              label: 'View on GitHub',
                              icon: Icons.code_rounded,
                              onTap: () => _launch(project.githubUrl!),
                            ),
                          if (project.playStoreUrl?.isNotEmpty ?? false)
                            _DetailLinkButton(
                              label: 'Play Store',
                              icon: Icons.shop_rounded,
                              accent: const Color(0xFF34A853),
                              onTap: () => _launch(project.playStoreUrl!),
                            ),
                          if (project.appStoreUrl?.isNotEmpty ?? false)
                            _DetailLinkButton(
                              label: 'App Store',
                              icon: Icons.apple_rounded,
                              accent: const Color(0xFF5CD6FF),
                              onTap: () => _launch(project.appStoreUrl!),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerSection extends StatelessWidget {
  const _BannerSection({
    required this.project,
    required this.accent,
    required this.isMobile,
  });
  final AppProject project;
  final Color accent;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Banner image
        SizedBox(
          height: isMobile ? 240 : 420,
          width: double.infinity,
          child: project.appBannerUrl.isNotEmpty
              ? Image.network(project.appBannerUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: accent.withValues(alpha: 0.12)))
              : Container(
                  color: accent.withValues(alpha: 0.12),
                  child: Center(child: Icon(Icons.image_rounded, color: Colors.white12, size: 64)),
                ),
        ),
        // Gradient overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: isMobile ? 100 : 180,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, const Color(0xFF0D0F12)],
              ),
            ),
          ),
        ),
        // Accent line at top
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
        // Back button
        Positioned(
          top: 12,
          left: 12,
          child: SafeArea(
            child: Material(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Get.back(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text('Back', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectHeader extends StatelessWidget {
  const _ProjectHeader({required this.project, required this.accent, required this.isMobile});
  final AppProject project;
  final Color accent;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (project.appIconUrl.isNotEmpty) ...[
          Container(
            width: isMobile ? 56 : 72,
            height: isMobile ? 56 : 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: accent.withValues(alpha: 0.3)),
              boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.2), blurRadius: 16)],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(project.appIconUrl, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                      color: Colors.white10,
                      child: const Icon(Icons.apps_rounded, color: Colors.white24, size: 28),
                    )),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Text(
            project.appName,
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 26 : 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.15,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailLinkButton extends StatefulWidget {
  const _DetailLinkButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.accent,
    this.filled = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? accent;
  final bool filled;

  @override
  State<_DetailLinkButton> createState() => _DetailLinkButtonState();
}

class _DetailLinkButtonState extends State<_DetailLinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.accent ?? Colors.white70;
    final bg = widget.filled
        ? (_hovered ? color.withValues(alpha: 0.25) : color.withValues(alpha: 0.15))
        : (_hovered ? color.withValues(alpha: 0.12) : color.withValues(alpha: 0.07));

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
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withValues(alpha: _hovered ? 0.5 : 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.manrope(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_outward_rounded, size: 13, color: color.withValues(alpha: 0.7)),
            ],
          ),
        ),
      ),
    );
  }
}

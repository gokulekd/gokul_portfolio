import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../features/admin/modules/projects/models/app_project.dart';
import '../../../widgets/projects/featured_projects_section.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/shared/custom_widgets.dart';
import '../../../widgets/shared/footer_section.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProjectsHeroSection(),
            _FeaturedProjectsSection(),
            _AllProjectsSection(),
            _ProjectsCTASection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 1. Hero Section
// ─────────────────────────────────────────────

class _ProjectsHeroSection extends StatefulWidget {
  const _ProjectsHeroSection();

  @override
  State<_ProjectsHeroSection> createState() => _ProjectsHeroSectionState();
}

class _ProjectsHeroSectionState extends State<_ProjectsHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final hPad = isMobile ? 20.0 : isTablet ? 48.0 : 88.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0A0A0A),
                  const Color(0xFF111111),
                  const Color(0xFF0A0A0A),
                ]
              : [Colors.grey[50]!, Colors.grey[100]!, Colors.grey[50]!],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(hPad, isMobile ? 40 : 64, hPad, isMobile ? 40 : 64),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Portfolio / My Work',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isMobile ? 16 : 24),

                // Large heading
                Text(
                  'My Work',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 60 : isTablet ? 88 : 108,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                    height: 0.92,
                    letterSpacing: isMobile ? -2.5 : -4.5,
                  ),
                ),

                SizedBox(height: isMobile ? 20 : 32),

                // Tagline
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 560),
                  child: Text(
                    'A curated collection of projects I have built with passion — from mobile apps to full-stack solutions.',
                    style: GoogleFonts.manrope(
                      fontSize: isMobile ? 16 : 19,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurface.withValues(alpha: 0.55),
                      height: 1.6,
                    ),
                  ),
                ),

                SizedBox(height: isMobile ? 28 : 40),

                // Stats pills
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _StatPill(label: '25+ Projects', icon: Icons.folder_outlined),
                    _StatPill(label: 'Mobile & Web', icon: Icons.devices_outlined),
                    _StatPill(label: '2024 – Present', icon: Icons.calendar_today_outlined),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatPill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.primaryGreen),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 2. Featured Projects
// ─────────────────────────────────────────────

class _FeaturedProjectsSection extends StatelessWidget {
  const _FeaturedProjectsSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final colorScheme = Theme.of(context).colorScheme;
    final hPad = isMobile ? 20.0 : isTablet ? 48.0 : 88.0;

    return Obx(() {
      final featured = controller.featuredAppProjects;
      if (featured.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.fromLTRB(hPad, isMobile ? 48 : 80, hPad, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '{02} - Featured Work',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Featured Projects',
              style: GoogleFonts.inter(
                fontSize: isMobile ? 36 : 52,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: -1.5,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hand-picked highlights from my portfolio',
              style: GoogleFonts.manrope(
                fontSize: isMobile ? 15 : 17,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 52),
            ...featured.asMap().entries.map((entry) {
              final index = entry.key;
              final project = entry.value;
              return Column(
                children: [
                  AppProjectCard(project: project, index: index),
                  if (index < featured.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: colorScheme.surfaceContainerHighest)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                border: Border.all(color: AppColors.primaryGreen, width: 2),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: colorScheme.surfaceContainerHighest)),
                        ],
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      );
    });
  }
}


// ─────────────────────────────────────────────
// 3. All Projects Grid
// ─────────────────────────────────────────────

class _AllProjectsSection extends StatefulWidget {
  const _AllProjectsSection();

  @override
  State<_AllProjectsSection> createState() => _AllProjectsSectionState();
}

class _AllProjectsSectionState extends State<_AllProjectsSection> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final colorScheme = Theme.of(context).colorScheme;
    final hPad = isMobile ? 20.0 : isTablet ? 48.0 : 88.0;

    return Obx(() {
      final all = controller.publishedAppProjects;
      final filtered = all;

      return Padding(
        padding: EdgeInsets.fromLTRB(hPad, isMobile ? 56 : 88, hPad, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section label
            Row(
              children: [
                Text(
                  '{03} - All Work',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'All Projects',
              style: GoogleFonts.inter(
                fontSize: isMobile ? 36 : 52,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: -1.5,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 28),

            // Projects grid
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No projects in this category yet.',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final cols = isMobile ? 1 : isTablet ? 2 : 3;
                  final spacing = 20.0;
                  final cardWidth = (constraints.maxWidth - spacing * (cols - 1)) / cols;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: filtered.map((project) => SizedBox(
                      width: cardWidth,
                      child: _AppProjectGridCard(project: project),
                    )).toList(),
                  );
                },
              ),
          ],
        ),
      );
    });
  }
}

class _AppProjectGridCard extends StatelessWidget {
  final AppProject project;

  const _AppProjectGridCard({required this.project});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.surfaceContainerHighest),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          if (project.appBannerUrl.isNotEmpty)
            Image.network(
              project.appBannerUrl,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (_, __, ___) =>
                  _ImagePlaceholder(colorScheme: colorScheme),
            )
          else
            _ImagePlaceholder(colorScheme: colorScheme),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon + Name
                Row(
                  children: [
                    if (project.appIconUrl.isNotEmpty)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: colorScheme.surfaceContainerHighest,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          project.appIconUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox(),
                        ),
                      ),
                    if (project.appIconUrl.isNotEmpty)
                      const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        project.appName,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (project.appDescription.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    project.appDescription,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: colorScheme.onSurface.withValues(alpha: 0.55),
                      height: 1.6,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (project.techStack.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: project.techStack.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.22)),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.manrope(
                          color: AppColors.primaryGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
                const SizedBox(height: 14),
                // Store / link buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (project.playStoreUrl != null &&
                        project.playStoreUrl!.isNotEmpty)
                      _ActionBtn(
                        icon: Icons.shop_rounded,
                        label: 'Play Store',
                        onTap: () => _launch(project.playStoreUrl!),
                        colorScheme: colorScheme,
                      ),
                    if (project.appStoreUrl != null &&
                        project.appStoreUrl!.isNotEmpty)
                      _ActionBtn(
                        icon: Icons.apple_rounded,
                        label: 'App Store',
                        onTap: () => _launch(project.appStoreUrl!),
                        colorScheme: colorScheme,
                      ),
                    if (project.appWebsiteUrl.isNotEmpty)
                      _ActionBtn(
                        icon: Icons.language_rounded,
                        label: 'Website',
                        onTap: () => _launch(project.appWebsiteUrl),
                        colorScheme: colorScheme,
                        filled: true,
                      ),
                    if (project.githubUrl != null &&
                        project.githubUrl!.isNotEmpty)
                      _ActionBtn(
                        icon: Icons.code_rounded,
                        label: 'GitHub',
                        onTap: () => _launch(project.githubUrl!),
                        colorScheme: colorScheme,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 4. CTA Section
// ─────────────────────────────────────────────

class _ProjectsCTASection extends StatelessWidget {
  const _ProjectsCTASection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hPad = isMobile ? 20.0 : isTablet ? 48.0 : 88.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 56 : 88, hPad, isMobile ? 40 : 64),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 28 : 56,
          vertical: isMobile ? 40 : 64,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryGreen.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                "Let's collaborate",
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Have a Project in Mind?',
              style: GoogleFonts.inter(
                fontSize: isMobile ? 32 : 48,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.15,
                letterSpacing: -1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "I'm always excited to work on new and challenging projects.\nLet's discuss how we can bring your ideas to life!",
              style: GoogleFonts.manrope(
                fontSize: isMobile ? 15 : 17,
                color: Colors.white.withValues(alpha: 0.6),
                height: 1.7,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            ElevatedButton(
              onPressed: controller.launchEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 28 : 40,
                  vertical: isMobile ? 14 : 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Start a Project',
                    style: GoogleFonts.manrope(
                      fontSize: isMobile ? 15 : 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.rocket_launch_outlined,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  final ColorScheme colorScheme;

  const _ImagePlaceholder({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final bool filled;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.colorScheme,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: filled ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: filled
                ? AppColors.primaryGreen
                : colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: filled ? Colors.black : colorScheme.onSurface,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: filled ? Colors.black : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

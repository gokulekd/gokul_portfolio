import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../controllers/portfolio_controller.dart';
import '../models/portfolio_models.dart';
import '../utils/responsive_helper.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/footer_section.dart';

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
      final featured = controller.featuredProjects;

      return Padding(
        padding: EdgeInsets.fromLTRB(hPad, isMobile ? 48 : 80, hPad, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section label
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

            if (featured.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'Featured projects will appear here once published.',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...featured.take(3).toList().asMap().entries.map((entry) {
                final index = entry.key;
                final project = entry.value;
                return Column(
                  children: [
                    _FeaturedCard(project: project, isReversed: index.isOdd),
                    if (index < featured.take(3).length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: colorScheme.surfaceContainerHighest,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  border: Border.all(
                                    color: AppColors.primaryGreen,
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: colorScheme.surfaceContainerHighest,
                                thickness: 1,
                              ),
                            ),
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

class _FeaturedCard extends StatelessWidget {
  final Project project;
  final bool isReversed;

  const _FeaturedCard({required this.project, this.isReversed = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final colorScheme = Theme.of(context).colorScheme;
    final compact = isMobile || isTablet;

    final image = _ProjectImage(imageUrl: project.imageUrl);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Category badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryGreen.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            project.category,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreen,
              letterSpacing: 0.4,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Title
        Text(
          project.title,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 24 : 30,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 14),

        // Description card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.surfaceContainerHighest),
          ),
          child: Text(
            project.description,
            style: GoogleFonts.manrope(
              fontSize: 15,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.7,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 20),

        // Tech chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: project.technologies.take(5).map((tech) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tech,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 24),

        // Action buttons
        Row(
          children: [
            if (project.githubUrl != null)
              _ActionBtn(
                icon: FontAwesomeIcons.github,
                label: 'View Code',
                onTap: () => controller.launchUrlFromString(project.githubUrl!),
                colorScheme: colorScheme,
              ),
            if (project.githubUrl != null && project.liveUrl != null)
              const SizedBox(width: 12),
            if (project.liveUrl != null)
              _ActionBtn(
                icon: Icons.open_in_new,
                label: 'Live Demo',
                onTap: () => controller.launchUrlFromString(project.liveUrl!),
                colorScheme: colorScheme,
                filled: true,
              ),
          ],
        ),
      ],
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [image, const SizedBox(height: 28), content],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: isReversed
          ? [
              Expanded(flex: 5, child: content),
              const SizedBox(width: 52),
              Expanded(flex: 6, child: image),
            ]
          : [
              Expanded(flex: 6, child: image),
              const SizedBox(width: 52),
              Expanded(flex: 5, child: content),
            ],
    );
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
  String _selected = 'All';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final colorScheme = Theme.of(context).colorScheme;
    final hPad = isMobile ? 20.0 : isTablet ? 48.0 : 88.0;

    return Obx(() {
      final all = controller.publishedProjects;
      final categories = ['All', ...{...all.map((p) => p.category)}];
      final filtered = _selected == 'All'
          ? all
          : all.where((p) => p.category == _selected).toList();

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

            // Category filter tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final active = cat == _selected;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _selected = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primaryGreen
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          cat,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: active ? Colors.black : colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 36),

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
                      child: _ProjectGridCard(project: project),
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

class _ProjectGridCard extends StatelessWidget {
  final Project project;

  const _ProjectGridCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: project.imageUrl.isNotEmpty
                  ? Image.network(
                      project.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _ImagePlaceholder(colorScheme: colorScheme),
                    )
                  : _ImagePlaceholder(colorScheme: colorScheme),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    project.category,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkGreen,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Title
                Text(
                  project.title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.3,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  project.description,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                    height: 1.6,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),

                // Tech chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: project.technologies.take(3).map((tech) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tech,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 16),

                // Buttons
                Row(
                  children: [
                    if (project.githubUrl != null)
                      _ActionBtn(
                        icon: FontAwesomeIcons.github,
                        label: 'Code',
                        onTap: () => controller.launchUrlFromString(project.githubUrl!),
                        colorScheme: colorScheme,
                      ),
                    if (project.githubUrl != null && project.liveUrl != null)
                      const SizedBox(width: 10),
                    if (project.liveUrl != null)
                      _ActionBtn(
                        icon: Icons.open_in_new,
                        label: 'Live',
                        onTap: () => controller.launchUrlFromString(project.liveUrl!),
                        colorScheme: colorScheme,
                        filled: true,
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

class _ProjectImage extends StatelessWidget {
  final String imageUrl;

  const _ProjectImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.12),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _ImagePlaceholder(colorScheme: colorScheme),
                )
              : _ImagePlaceholder(colorScheme: colorScheme),
        ),
      ),
    );
  }
}

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

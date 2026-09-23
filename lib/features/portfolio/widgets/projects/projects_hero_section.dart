import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../shared/custom_widgets.dart';

/// Kinds of work typed out one after another in the hero subtitle.
const _kWork = [
  'mobile apps.',
  'cross-platform products.',
  'polished interfaces.',
  'full-stack solutions.',
  'ideas as real apps.',
];

/// My Work page hero, laid out like the About and Blog page heroes:
/// the profile card on the left, and a "My work" heading with an animated
/// subtitle, intro, CTAs and project stats on the right.
class ProjectsHeroSection extends ConsumerStatefulWidget {
  const ProjectsHeroSection({super.key});

  @override
  ConsumerState<ProjectsHeroSection> createState() =>
      _ProjectsHeroSectionState();
}

class _ProjectsHeroSectionState extends ConsumerState<ProjectsHeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _textController;
  late final AnimationController _contentController;
  late final AnimationController _ctaController;

  @override
  void initState() {
    super.initState();
    _textController = _fadeController();
    _contentController = _fadeController();
    _ctaController = _fadeController();
    _startAfter(300, _textController);
    _startAfter(500, _contentController);
    _startAfter(700, _ctaController);
  }

  AnimationController _fadeController() => AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  void _startAfter(int ms, AnimationController controller) {
    Future.delayed(Duration(milliseconds: ms), () {
      if (mounted) controller.forward();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _contentController.dispose();
    _ctaController.dispose();
    super.dispose();
  }

  Widget _fadeIn(AnimationController controller, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: controller, curve: Curves.easeOut),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final horizontalPadding =
        isMobile
            ? 16.0
            : isTablet
            ? 40.0
            : 80.0;
    final verticalPadding =
        isMobile
            ? 32.0
            : isTablet
            ? 48.0
            : 64.0;

    final profileCard = ProfileHeroCard(
      imageRadius:
          isMobile
              ? 80.0
              : isTablet
              ? 100.0
              : 120.0,
      nameFontSize:
          isMobile
              ? 28.0
              : isTablet
              ? 36.0
              : 42.0,
      titleFontSize:
          isMobile
              ? 16.0
              : isTablet
              ? 18.0
              : 20.0,
      socialIconScale:
          isMobile
              ? 1.2
              : isTablet
              ? 1.35
              : 1.5,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? const [
                    Color(0xFF0A0A0A),
                    Color(0xFF111111),
                    Color(0xFF0A0A0A),
                  ]
                  : [Colors.grey[50]!, Colors.grey[100]!, Colors.grey[50]!],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child:
            isMobile
                ? Column(
                  children: [
                    profileCard,
                    const SizedBox(height: 40),
                    _buildContent(context, centered: true),
                  ],
                )
                : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 2, child: profileCard),
                    SizedBox(width: isTablet ? 40 : 80),
                    Expanded(flex: 3, child: _buildContent(context)),
                  ],
                ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {bool centered = false}) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(portfolioProvider);
    final crossAlign =
        centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;
    final wrapAlign = centered ? WrapAlignment.center : WrapAlignment.start;

    final projects = state.publishedAppProjects;
    final featured = state.featuredAppProjects.length;
    final techCount = projects.expand((p) => p.techStack).toSet().length;

    return Column(
      crossAxisAlignment: crossAlign,
      mainAxisSize: MainAxisSize.min,
      children: [
        _fadeIn(
          _textController,
          Column(
            crossAxisAlignment: crossAlign,
            children: [
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
              SizedBox(height: isMobile ? 12 : 16),
              Text(
                'My work',
                textAlign: textAlign,
                style: GoogleFonts.inter(
                  fontSize:
                      isMobile
                          ? 52
                          : isTablet
                          ? 72
                          : 88,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  height: 0.95,
                  letterSpacing: isMobile ? -2.0 : -3.5,
                ),
              ),
              SizedBox(height: isMobile ? 20 : 28),
              TypewriterSubtitle(
                prefix: 'I ship ',
                words: _kWork,
                textAlign: textAlign,
                fontSize:
                    isMobile
                        ? 22
                        : isTablet
                        ? 28
                        : 34,
              ),
              SizedBox(height: isMobile ? 20 : 28),
            ],
          ),
        ),
        _fadeIn(
          _contentController,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              'A curated collection of projects I have built with passion, '
              'from mobile apps to full-stack solutions.',
              textAlign: textAlign,
              style: GoogleFonts.manrope(
                fontSize:
                    isMobile
                        ? 16
                        : isTablet
                        ? 18
                        : 19,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.65),
                height: 1.6,
              ),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 28 : 36),
        _fadeIn(
          _ctaController,
          Column(
            crossAxisAlignment: crossAlign,
            children: [
              Wrap(
                spacing: 14,
                runSpacing: 14,
                alignment: wrapAlign,
                children: [
                  HeroActionButton(
                    label: 'Start a project',
                    icon: Icons.rocket_launch_outlined,
                    isPrimary: true,
                    onPressed:
                        () =>
                            ref.read(portfolioProvider.notifier).launchEmail(),
                  ),
                  HeroActionButton(
                    label: 'Download CV',
                    icon: Icons.download_rounded,
                    onPressed:
                        () =>
                            ref.read(portfolioProvider.notifier).launchResume(),
                  ),
                ],
              ),
              if (projects.isNotEmpty) ...[
                SizedBox(height: isMobile ? 28 : 36),
                Wrap(
                  spacing: isMobile ? 24 : 36,
                  runSpacing: 16,
                  alignment: wrapAlign,
                  children: [
                    HeroStat(
                      value: '${projects.length}',
                      label: projects.length == 1 ? 'Project' : 'Projects',
                    ),
                    if (featured > 0)
                      HeroStat(value: '$featured', label: 'Featured'),
                    if (techCount > 0)
                      HeroStat(
                        value: '$techCount',
                        label:
                            techCount == 1 ? 'Technology' : 'Technologies',
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

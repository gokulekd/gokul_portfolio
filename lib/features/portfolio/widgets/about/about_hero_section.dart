import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../shared/custom_widgets.dart';

class AboutHeroSection extends ConsumerStatefulWidget {
  const AboutHeroSection({super.key});

  @override
  ConsumerState<AboutHeroSection> createState() => _AboutHeroSectionState();
}

class _AboutHeroSectionState extends ConsumerState<AboutHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _socialController;
  late AnimationController _taglineController;
  late AnimationController _contentController;

  late Animation<double> _textOpacity;
  late Animation<double> _socialOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<double> _contentOpacity;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _socialController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _socialOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _socialController, curve: Curves.easeOut),
    );

    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _contentController.forward();
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      _taglineController.forward();
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _socialController.forward();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _socialController.dispose();
    _taglineController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Widget _buildExperienceBadge(BuildContext context) {
    return AnimatedBuilder(
      animation: _socialController,
      builder:
          (context, child) => Opacity(
            opacity: _socialOpacity.value,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                '3+ YRS EXPERIENCE',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildLeftColumn(
    BuildContext context,
    double imageRadius,
    double nameFontSize,
    double titleFontSize,
    double socialIconScale,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileHeroCard(
          imageRadius: imageRadius,
          nameFontSize: nameFontSize,
          titleFontSize: titleFontSize,
          socialIconScale: socialIconScale,
        ),
        const SizedBox(height: 32),
        Center(child: _buildExperienceBadge(context)),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Heading
        AnimatedBuilder(
          animation: _textController,
          builder: (context, child) => Opacity(
            opacity: _textOpacity.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      'Portfolio / About',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 12 : 16),
                Text(
                  'About me',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 52 : isTablet ? 72 : 88,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 0.95,
                    letterSpacing: isMobile ? -2.0 : -3.5,
                  ),
                ),
                SizedBox(height: isMobile ? 32 : 40),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _contentController,
          builder:
              (context, child) => Opacity(
                opacity: _contentOpacity.value,
                child: Text(
                  "I'm a dynamic Flutter Developer with 3+ years of hands-on experience building scalable, cross-platform mobile applications. I bring proven expertise in Flutter, Firebase, Bloc, and GetX — with a passion for creating pixel-perfect UIs using Figma. Skilled in API integration, payment systems, and location-based services.",
                  style: GoogleFonts.manrope(
                    fontSize:
                        isMobile
                            ? 18
                            : isTablet
                            ? 22
                            : 24,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.5,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
        ),
        const SizedBox(height: 28),
        AnimatedBuilder(
          animation: _taglineController,
          builder:
              (context, child) => Opacity(
                opacity: _taglineOpacity.value,
                child: Text(
                  "Over 3 years I've delivered government apps, social platforms, payment systems, and HRM tools — consistently recognised for clean, maintainable code and on-time delivery across freelance and full-time roles.",
                  style: GoogleFonts.manrope(
                    fontSize:
                        isMobile
                            ? 16
                            : isTablet
                            ? 18
                            : 20,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                    height: 1.6,
                  ),
                ),
              ),
        ),
        const SizedBox(height: 28),
        AnimatedBuilder(
          animation: _taglineController,
          builder:
              (context, child) => Opacity(
                opacity: _taglineOpacity.value,
                child: Text(
                  "Let's create something amazing together!",
                  style: GoogleFonts.manrope(
                    fontSize:
                        isMobile
                            ? 16
                            : isTablet
                            ? 18
                            : 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
              ),
        ),
      ],
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
    final imageRadius =
        isMobile
            ? 80.0
            : isTablet
            ? 100.0
            : 120.0;
    final nameFontSize =
        isMobile
            ? 28.0
            : isTablet
            ? 36.0
            : 42.0;
    final titleFontSize =
        isMobile
            ? 16.0
            : isTablet
            ? 18.0
            : 20.0;
    final socialIconScale =
        isMobile
            ? 1.2
            : isTablet
            ? 1.35
            : 1.5;
    final spacingBetweenSections =
        isMobile
            ? 24.0
            : isTablet
            ? 40.0
            : 80.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    const Color(0xFF0A0A0A),
                    const Color(0xFF111111),
                    const Color(0xFF0A0A0A),
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
                ? _buildMobileLayout(
                  context,
                  imageRadius,
                  nameFontSize,
                  titleFontSize,
                  socialIconScale,
                )
                : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildLeftColumn(
                        context,
                        imageRadius,
                        nameFontSize,
                        titleFontSize,
                        socialIconScale,
                      ),
                    ),
                    SizedBox(width: spacingBetweenSections),
                    Expanded(flex: 3, child: _buildRightColumn(context)),
                  ],
                ),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    double imageRadius,
    double nameFontSize,
    double titleFontSize,
    double socialIconScale,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfileHeroCard(
          imageRadius: imageRadius,
          nameFontSize: nameFontSize,
          titleFontSize: titleFontSize,
          socialIconScale: socialIconScale,
        ),
        const SizedBox(height: 24),
        _buildExperienceBadge(context),
        const SizedBox(height: 40),
        AnimatedBuilder(
          animation: _contentController,
          builder:
              (context, child) => Opacity(
                opacity: _contentOpacity.value,
                child: Text(
                  "I'm a dynamic Flutter Developer with 3+ years of hands-on experience building scalable, cross-platform mobile applications. I bring proven expertise in Flutter, Firebase, Bloc, and GetX — with a passion for creating pixel-perfect UIs using Figma. Skilled in API integration, payment systems, and location-based services.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.5,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: _taglineController,
          builder:
              (context, child) => Opacity(
                opacity: _taglineOpacity.value,
                child: Text(
                  "Over 3 years I've delivered government apps, social platforms, payment systems, and HRM tools — consistently recognised for clean, maintainable code and on-time delivery across freelance and full-time roles.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                    height: 1.6,
                  ),
                ),
              ),
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: _taglineController,
          builder:
              (context, child) => Opacity(
                opacity: _taglineOpacity.value,
                child: Text(
                  "Let's create something amazing together!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
              ),
        ),
      ],
    );
  }
}

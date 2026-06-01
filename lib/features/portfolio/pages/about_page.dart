import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../models/portfolio_models.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/shared/available_badge.dart';
import '../../../widgets/shared/custom_widgets.dart';
import '../../../widgets/shared/footer_section.dart';
import '../../../widgets/home/skills_section.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AboutHeroSection(controller: controller),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
              child: _EducationExperienceSection(controller: controller),
            ),
            const SizedBox(height: 32),
            const SkillsSection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

class _AboutHeroSection extends StatefulWidget {
  const _AboutHeroSection({required this.controller});

  final PortfolioController controller;

  @override
  State<_AboutHeroSection> createState() => _AboutHeroSectionState();
}

class _AboutHeroSectionState extends State<_AboutHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _textController;
  late AnimationController _socialController;
  late AnimationController _taglineController;
  late AnimationController _contentController;
  late AnimationController _pulseController;

  late Animation<double> _imageScale;
  late Animation<double> _imageOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _socialOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<double> _contentOpacity;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _imageScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeOutCubic),
    );
    _imageOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _imageController, curve: Curves.easeOut));

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

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _imageController.forward();
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
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    _socialController.dispose();
    _taglineController.dispose();
    _contentController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedSocialIcon(Widget child, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  Widget _buildProfileImage(double imageRadius, String profileImageUrl) {
    return AnimatedBuilder(
      animation: Listenable.merge([_imageController, _pulseController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _imageScale.value * _pulseAnimation.value,
          child: Opacity(
            opacity: _imageOpacity.value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: imageRadius,
                backgroundColor: Colors.grey[300],
                backgroundImage: const AssetImage(
                  'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeftColumn(
    BuildContext context,
    double imageRadius,
    double nameFontSize,
    double titleFontSize,
    double socialIconScale,
    String profileImageUrl,
  ) {
    final controller = widget.controller;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: _buildProfileImage(imageRadius, profileImageUrl)),
        const SizedBox(height: 16),
        const Center(child: AvailableForWorkBadge()),
        const SizedBox(height: 16),
        Center(
          child: AnimatedBuilder(
            animation: _textController,
            builder:
                (context, child) => Opacity(
                  opacity: _textOpacity.value,
                  child: Column(
                    children: [
                      Text(
                        controller.personalInfo.value.name,
                        style: GoogleFonts.inter(
                          fontSize: nameFontSize,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.personalInfo.value.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: titleFontSize,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: AnimatedBuilder(
            animation: _socialController,
            builder:
                (context, child) => Opacity(
                  opacity: _socialOpacity.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        controller.personalInfo.value.socialLinks
                            .take(3)
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) {
                              final index = entry.key;
                              final link = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index < 2 ? 24 : 0,
                                ),
                                child: Transform.scale(
                                  scale: socialIconScale,
                                  child: _buildAnimatedSocialIcon(
                                    SocialIconButton(
                                      platform: link.platform,
                                      url: link.url,
                                      icon: _iconForPlatform(link.platform),
                                    ),
                                    index,
                                  ),
                                ),
                              );
                            })
                            .toList(),
                  ),
                ),
          ),
        ),
        const SizedBox(height: 32),
        AnimatedBuilder(
          animation: _socialController,
          builder:
              (context, child) => Opacity(
                opacity: _socialOpacity.value,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
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
              ),
        ),
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
    final greetingFontSize =
        isMobile
            ? 36.0
            : isTablet
            ? 48.0
            : 72.0;
    final taglineFontSize =
        isMobile
            ? 28.0
            : isTablet
            ? 40.0
            : 58.0;
    final bioFontSize =
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

    final info = widget.controller.personalInfo.value;
    final githubStats = widget.controller.githubStats.value;
    final profileImageUrl =
        githubStats?.avatarUrl.isNotEmpty == true
            ? githubStats!.avatarUrl
            : info.profileImageUrl;

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
                  greetingFontSize,
                  taglineFontSize,
                  bioFontSize,
                  socialIconScale,
                  profileImageUrl,
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
                        profileImageUrl,
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
    double greetingFontSize,
    double taglineFontSize,
    double bioFontSize,
    double socialIconScale,
    String profileImageUrl,
  ) {
    final controller = widget.controller;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: _buildProfileImage(imageRadius, profileImageUrl)),
        const SizedBox(height: 16),
        const AvailableForWorkBadge(),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _textController,
          builder:
              (context, child) => Opacity(
                opacity: _textOpacity.value,
                child: Column(
                  children: [
                    Text(
                      controller.personalInfo.value.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: nameFontSize,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.personalInfo.value.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: titleFontSize,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
        ),
        const SizedBox(height: 32),
        AnimatedBuilder(
          animation: _socialController,
          builder:
              (context, child) => Opacity(
                opacity: _socialOpacity.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      controller.personalInfo.value.socialLinks
                          .take(3)
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                            final index = entry.key;
                            final link = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index < 2 ? 16 : 0,
                              ),
                              child: Transform.scale(
                                scale: socialIconScale,
                                child: _buildAnimatedSocialIcon(
                                  SocialIconButton(
                                    platform: link.platform,
                                    url: link.url,
                                    icon: _iconForPlatform(link.platform),
                                  ),
                                  index,
                                ),
                              ),
                            );
                          })
                          .toList(),
                ),
              ),
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: _socialController,
          builder:
              (context, child) => Opacity(
                opacity: _socialOpacity.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    '3+ YRS EXPERIENCE',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
        ),
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

  IconData _iconForPlatform(String platform) {
    switch (platform.toLowerCase()) {
      case 'twitter':
      case 'x':
      case 'twitter/x':
        return FontAwesomeIcons.xTwitter;
      case 'linkedin':
        return FontAwesomeIcons.linkedinIn;
      case 'github':
        return FontAwesomeIcons.github;
      case 'medium':
        return FontAwesomeIcons.medium;
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'facebook':
        return FontAwesomeIcons.facebook;
      default:
        return FontAwesomeIcons.globe;
    }
  }
}

class _EducationExperienceSection extends StatelessWidget {
  const _EducationExperienceSection({required this.controller});

  final PortfolioController controller;

  static const List<_EducationEntry> _educationEntries = [
    _EducationEntry(
      title: "BSc Mathematics",
      period: "Jun 2013 – Jun 2016",
      description:
          "Devaswom Board Pampa College, Parumala. Built a strong analytical and problem-solving foundation.",
    ),
    _EducationEntry(
      title: "Higher Secondary — Computer Science",
      period: "Jun 2011 – Jun 2013",
      description:
          "Govt. Higher Secondary School, Budhanoor. First exposure to programming and computer fundamentals.",
    ),
    _EducationEntry(
      title: "Flutter & Mobile Development",
      period: "2021 – Present",
      description:
          "Continuous self-learning — Flutter, Dart, Firebase, Bloc, GetX, Figma, REST APIs, and payment integrations.",
    ),
    _EducationEntry(
      title: "Internship — Brototype, Kochi",
      period: "Oct 2021 – Oct 2022",
      description:
          "Intensive full-stack Flutter training. Built real-world projects with Google Maps, Firebase, and GetX state management.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isCompact =
        ResponsiveHelper.isMobile(context) ||
        ResponsiveHelper.isTablet(context);

    return isCompact
        ? Column(
          children: [
            _EducationPanel(entries: _educationEntries),
            const SizedBox(height: 20),
            _ExperiencePanel(experiences: controller.experiences.toList()),
          ],
        )
        : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _EducationPanel(entries: _educationEntries)),
            const SizedBox(width: 24),
            Expanded(
              child: _ExperiencePanel(
                experiences: controller.experiences.toList(),
              ),
            ),
          ],
        );
  }
}

class _EducationPanel extends StatelessWidget {
  const _EducationPanel({required this.entries});

  final List<_EducationEntry> entries;

  @override
  Widget build(BuildContext context) {
    return _DarkInfoPanel(
      title: "Formal Education",
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSingleColumn = constraints.maxWidth < 520;
          final items =
              entries
                  .map(
                    (entry) => _EducationItemCard(
                      title: entry.title,
                      period: entry.period,
                      description: entry.description,
                    ),
                  )
                  .toList();

          if (isSingleColumn) {
            return Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  items[i],
                  if (i < items.length - 1) const SizedBox(height: 28),
                ],
              ],
            );
          }

          return Wrap(
            spacing: 28,
            runSpacing: 28,
            children:
                items
                    .map(
                      (item) => SizedBox(
                        width: (constraints.maxWidth - 28) / 2,
                        child: item,
                      ),
                    )
                    .toList(),
          );
        },
      ),
    );
  }
}

class _ExperiencePanel extends StatelessWidget {
  const _ExperiencePanel({required this.experiences});

  final List<Experience> experiences;

  @override
  Widget build(BuildContext context) {
    final splitIndex = (experiences.length / 2).ceil();
    final left = experiences.take(splitIndex).toList();
    final right = experiences.skip(splitIndex).toList();
    final isSingleColumn =
        ResponsiveHelper.isMobile(context) || experiences.length < 3;

    return _DarkInfoPanel(
      title: "Work Experience",
      child:
          isSingleColumn
              ? Column(
                children: [
                  for (int i = 0; i < experiences.length; i++) ...[
                    _ExperienceBullet(experience: experiences[i]),
                    if (i < experiences.length - 1) const SizedBox(height: 22),
                  ],
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < left.length; i++) ...[
                          _ExperienceBullet(experience: left[i]),
                          if (i < left.length - 1) const SizedBox(height: 22),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 28),
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < right.length; i++) ...[
                          _ExperienceBullet(experience: right[i]),
                          if (i < right.length - 1) const SizedBox(height: 22),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}

class _DarkInfoPanel extends StatelessWidget {
  const _DarkInfoPanel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          const _AccentWaveDivider(),
          const SizedBox(height: 34),
          child,
        ],
      ),
    );
  }
}

class _EducationItemCard extends StatelessWidget {
  const _EducationItemCard({
    required this.title,
    required this.period,
    required this.description,
  });

  final String title;
  final String period;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          period,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.85),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.72),
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _ExperienceBullet extends StatelessWidget {
  const _ExperienceBullet({required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryGreen, width: 2),
          ),
          child: Center(
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                experience.position,
                style: GoogleFonts.manrope(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${experience.company} • ${experience.duration}',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.78),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                experience.description,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.68),
                  height: 1.5,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccentWaveDivider extends StatelessWidget {
  const _AccentWaveDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 14,
      child: CustomPaint(painter: _WaveLinePainter()),
    );
  }
}

class _WaveLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primaryGreen.withValues(alpha: 0.78)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4;

    final path = Path();
    const waveWidth = 12.0;
    final halfHeight = size.height / 2;
    path.moveTo(0, halfHeight);

    for (double x = 0; x < size.width; x += waveWidth) {
      path.quadraticBezierTo(
        x + waveWidth / 4,
        0,
        x + waveWidth / 2,
        halfHeight,
      );
      path.quadraticBezierTo(
        x + 3 * waveWidth / 4,
        size.height,
        x + waveWidth,
        halfHeight,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EducationEntry {
  const _EducationEntry({
    required this.title,
    required this.period,
    required this.description,
  });

  final String title;
  final String period;
  final String description;
}

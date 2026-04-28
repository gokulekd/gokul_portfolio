import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../controllers/portfolio_controller.dart';
import '../models/portfolio_models.dart';
import '../utils/responsive_helper.dart';
import '../widgets/available_badge.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/footer_section.dart';
import '../widgets/skills_section.dart';

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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: _AboutContactSection(controller: controller),
            ),
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
    _imageOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeOut),
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

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
                backgroundImage: profileImageUrl.startsWith('http')
                    ? NetworkImage(profileImageUrl) as ImageProvider
                    : const AssetImage(
                        'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
                      ),
                onBackgroundImageError: (_, __) {},
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
            builder: (context, child) => Opacity(
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
            builder: (context, child) => Opacity(
              opacity: _socialOpacity.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.personalInfo.value.socialLinks
                    .take(3)
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final link = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(right: index < 2 ? 24 : 0),
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
          builder: (context, child) => Opacity(
            opacity: _socialOpacity.value,
            child: Center(
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
                  '(2024 - PRESENT)',
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
        AnimatedBuilder(
          animation: _contentController,
          builder: (context, child) => Opacity(
            opacity: _contentOpacity.value,
            child: Text(
              "Hi, I'm Gokul, a passionate mobile app developer and designer with a love for creating visually stunning experiences. With a strong background in design and front-end development, I specialize in crafting responsive mobile apps that not only look great but also provide seamless interactions across all devices.",
              style: GoogleFonts.manrope(
                fontSize: isMobile ? 18 : isTablet ? 22 : 24,
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
          builder: (context, child) => Opacity(
            opacity: _taglineOpacity.value,
            child: Text(
              "Over the years, I've had the opportunity to work with a diverse range of clients, from startups to established brands, helping them bring their visions to life online.",
              style: GoogleFonts.manrope(
                fontSize: isMobile ? 16 : isTablet ? 18 : 20,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                height: 1.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        AnimatedBuilder(
          animation: _taglineController,
          builder: (context, child) => Opacity(
            opacity: _taglineOpacity.value,
            child: Text(
              "Let's create something amazing together!",
              style: GoogleFonts.manrope(
                fontSize: isMobile ? 16 : isTablet ? 18 : 20,
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

    final horizontalPadding = isMobile ? 16.0 : isTablet ? 40.0 : 80.0;
    final verticalPadding = isMobile ? 32.0 : isTablet ? 48.0 : 64.0;
    final imageRadius = isMobile ? 80.0 : isTablet ? 100.0 : 120.0;
    final nameFontSize = isMobile ? 28.0 : isTablet ? 36.0 : 42.0;
    final titleFontSize = isMobile ? 16.0 : isTablet ? 18.0 : 20.0;
    final greetingFontSize = isMobile ? 36.0 : isTablet ? 48.0 : 72.0;
    final taglineFontSize = isMobile ? 28.0 : isTablet ? 40.0 : 58.0;
    final bioFontSize = isMobile ? 16.0 : isTablet ? 18.0 : 20.0;
    final socialIconScale = isMobile ? 1.2 : isTablet ? 1.35 : 1.5;
    final spacingBetweenSections = isMobile ? 24.0 : isTablet ? 40.0 : 80.0;

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
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page heading
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
                        fontSize: isMobile ? 52 : isTablet ? 80 : 96,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 0.95,
                        letterSpacing: isMobile ? -2.0 : -4.0,
                      ),
                    ),
                    SizedBox(height: isMobile ? 32 : 48),
                  ],
                ),
              ),
            ),
            // Left / right body
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
                      Expanded(
                        flex: 3,
                        child: _buildRightColumn(context),
                      ),
                    ],
                  ),
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
          builder: (context, child) => Opacity(
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
          builder: (context, child) => Opacity(
            opacity: _socialOpacity.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: controller.personalInfo.value.socialLinks
                  .take(3)
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                    final index = entry.key;
                    final link = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(right: index < 2 ? 16 : 0),
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
          builder: (context, child) => Opacity(
            opacity: _socialOpacity.value,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                '(2024 - PRESENT)',
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
          builder: (context, child) => Opacity(
            opacity: _contentOpacity.value,
            child: Text(
              "Hi, I'm Gokul, a passionate mobile app developer and designer with a love for creating visually stunning experiences. With a strong background in design and front-end development, I specialize in crafting responsive mobile apps that not only look great but also provide seamless interactions across all devices.",
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
          builder: (context, child) => Opacity(
            opacity: _taglineOpacity.value,
            child: Text(
              "Over the years, I've had the opportunity to work with a diverse range of clients, from startups to established brands, helping them bring their visions to life online.",
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                height: 1.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: _taglineController,
          builder: (context, child) => Opacity(
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
      title: "Academic Foundation",
      period: "Add degree and years",
      description: "Add your university, course, and graduation timeline here.",
    ),
    _EducationEntry(
      title: "Specialized Learning",
      period: "Add certifications or training",
      description:
          "Use this block for certifications, focused coursework, or bootcamps.",
    ),
    _EducationEntry(
      title: "Technical Focus",
      period: "Computer science and product skills",
      description:
          "Summarize the areas you studied most deeply and what they prepared you for.",
    ),
    _EducationEntry(
      title: "Continuous Learning",
      period: "Self-directed growth",
      description:
          "Highlight the learning habits, programs, or communities that sharpen your craft.",
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

class _AboutContactSection extends StatefulWidget {
  const _AboutContactSection({required this.controller});

  final PortfolioController controller;

  @override
  State<_AboutContactSection> createState() => _AboutContactSectionState();
}

class _AboutContactSectionState extends State<_AboutContactSection> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompact =
        ResponsiveHelper.isMobile(context) ||
        ResponsiveHelper.isTablet(context);
    final socialLinks = widget.controller.personalInfo.value.socialLinks
        .take(4)
        .toList(growable: false);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child:
          isCompact
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContactCopy(context),
                  const SizedBox(height: 28),
                  _buildContactFormCard(context, colorScheme),
                  const SizedBox(height: 24),
                  _buildContactDetails(context, socialLinks, colorScheme),
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: _buildContactCopy(context)),
                  const SizedBox(width: 36),
                  Expanded(
                    flex: 5,
                    child: _buildContactFormCard(context, colorScheme),
                  ),
                ],
              ),
    );
  }

  Widget _buildContactCopy(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact me',
          style: GoogleFonts.manrope(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 14),
        const _AccentWaveDivider(),
        const SizedBox(height: 24),
        Text(
          "I'm always interested in new opportunities and meaningful collaborations. If you have a product idea, freelance project, or just want to connect, reach out.",
          style: GoogleFonts.manrope(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.72),
            height: 1.7,
          ),
        ),
        const SizedBox(height: 28),
        _buildContactDetails(
          context,
          widget.controller.personalInfo.value.socialLinks
              .take(4)
              .toList(growable: false),
          Theme.of(context).colorScheme,
        ),
      ],
    );
  }

  Widget _buildContactFormCard(BuildContext context, ColorScheme colorScheme) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 22 : 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get in touch",
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 36 : 42,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2F2F2F),
              height: 1.05,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 28),
          _buildInquiryField(
            controller: _nameController,
            hintText: 'Name',
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          _buildInquiryField(
            controller: _emailController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          _buildInquiryField(
            controller: _messageController,
            hintText: 'Leave me a message',
            maxLines: 6,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitInquiry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F2F2F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              child: Text(
                'Send Message',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF2F2F2F),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFB5B5B5),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: maxLines > 1 ? 24 : 22,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildContactDetails(
    BuildContext context,
    List socialLinks,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactDetailRow(
          icon: FontAwesomeIcons.envelope,
          label: 'Email',
          value: widget.controller.personalInfo.value.email,
        ),
        const SizedBox(height: 18),
        _buildContactDetailRow(
          icon: FontAwesomeIcons.locationDot,
          label: 'Location',
          value: widget.controller.personalInfo.value.location,
        ),
        const SizedBox(height: 28),
        Text(
          'Socials',
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              socialLinks
                  .map<Widget>(
                    (link) => InkWell(
                      onTap: () => widget.controller.launchSocialLink(link.url),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _iconForPlatform(link.platform),
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              link.platform,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildContactDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: AppColors.primaryGreen),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submitInquiry() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      Get.snackbar(
        'Missing details',
        'Please fill in name, email, and message.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    widget.controller.launchEmail(
      subject: 'Portfolio enquiry from $name',
      body: 'Name: $name\nEmail: $email\n\nMessage:\n$message\n',
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

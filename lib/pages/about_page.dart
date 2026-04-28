import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../controllers/portfolio_controller.dart';
import '../models/portfolio_models.dart';
import '../utils/responsive_helper.dart';
import '../widgets/custom_widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final theme = Theme.of(context);
    final sectionShadow = Colors.black.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.16 : 0.08,
    );

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AboutHeroSection(controller: controller),
              const SizedBox(height: 48),
              _EducationExperienceSection(controller: controller),
              const SizedBox(height: 32),
              _AboutContactSection(controller: controller),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: sectionShadow,
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Me',
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.personalInfo.value.bio,
                      style: GoogleFonts.manrope(fontSize: 16, height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "I'm passionate about creating beautiful, functional mobile applications that provide exceptional user experiences. With expertise in Flutter development, I specialize in building cross-platform apps that work seamlessly on both iOS and Android.",
                      style: GoogleFonts.manrope(fontSize: 16, height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "When I'm not coding, you can find me exploring new technologies, contributing to open-source projects, or sharing my knowledge through blog posts and tutorials.",
                      style: GoogleFonts.manrope(fontSize: 16, height: 1.6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: sectionShadow,
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skills & Technologies',
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          [
                                'Flutter',
                                'Dart',
                                'Firebase',
                                'REST APIs',
                                'Git',
                                'Material Design',
                                'Provider',
                                'GetX',
                                'SQLite',
                                'Android Studio',
                                'VS Code',
                                'Figma',
                              ]
                              .map(
                                (skill) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF10B981,
                                    ).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF10B981,
                                      ).withValues(alpha: 0.28),
                                    ),
                                  ),
                                  child: Text(
                                    skill,
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      color: AppColors.darkGreen,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutHeroSection extends StatelessWidget {
  const _AboutHeroSection({required this.controller});

  final PortfolioController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isCompact = isMobile || isTablet;
    final info = controller.personalInfo.value;
    final githubStats = controller.githubStats.value;
    final profileImage =
        githubStats?.avatarUrl.isNotEmpty == true
            ? githubStats!.avatarUrl
            : info.profileImageUrl;
    final socialLinks = info.socialLinks.take(3).toList(growable: false);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isMobile ? 6 : 24,
        isMobile ? 12 : 28,
        isMobile ? 6 : 24,
        isMobile ? 24 : 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Available for freelance work',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 18 : 24),
          Text(
            "About me",
            style: GoogleFonts.manrope(
              fontSize:
                  isMobile
                      ? 56
                      : isTablet
                      ? 84
                      : 92,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface,
              height: 0.95,
              letterSpacing: -3.2,
            ),
          ),
          SizedBox(height: isMobile ? 36 : 54),
          isCompact
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIdentityColumn(
                    context,
                    imageUrl: profileImage,
                    socialLinks: socialLinks,
                  ),
                  const SizedBox(height: 32),
                  _buildNarrativeColumn(context),
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildIdentityColumn(
                      context,
                      imageUrl: profileImage,
                      socialLinks: socialLinks,
                    ),
                  ),
                  const SizedBox(width: 72),
                  Expanded(flex: 6, child: _buildNarrativeColumn(context)),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildIdentityColumn(
    BuildContext context, {
    required String imageUrl,
    required List socialLinks,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = ResponsiveHelper.isMobile(context);
    final info = controller.personalInfo.value;
    final linkedIn = info.socialLinks.firstWhereOrNull(
      (link) => link.platform.toLowerCase() == 'linkedin',
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: isMobile ? 64 : 78,
                height: isMobile ? 64 : 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surfaceContainerHighest,
                ),
                clipBehavior: Clip.antiAlias,
                child:
                    imageUrl.isEmpty
                        ? Icon(
                          Icons.person,
                          size: 32,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        )
                        : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Icon(
                                Icons.person,
                                size: 32,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                        ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Wrap(
                    spacing: 14,
                    runSpacing: 12,
                    children:
                        socialLinks
                            .map<Widget>(
                              (link) => _buildInlineSocialIcon(
                                context,
                                icon: _iconForPlatform(link.platform),
                                onTap:
                                    () => controller.launchSocialLink(link.url),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            info.email,
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 22 : 25,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "I’m Gokul, a passionate mobile app developer with a love for creating visually stunning and user-friendly digital experiences.",
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 16 : 17,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              height: 1.55,
            ),
          ),
          SizedBox(height: isMobile ? 28 : 38),
          if (linkedIn != null)
            InkWell(
              onTap: () => controller.launchSocialLink(linkedIn.url),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 28,
                  vertical: isMobile ? 14 : 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Linked In",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_outward,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNarrativeColumn(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = ResponsiveHelper.isMobile(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi, I’m Gokul, a passionate mobile app developer and designer with a love for creating visually stunning experiences. With a strong background in design and front-end development, I specialize in crafting responsive mobile app that not only look great but also provide interactions across all devices.",
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 20 : 25,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
              height: 1.35,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            "Over the years, I’ve had the opportunity to work with a diverse range of clients, from startups to established brands, helping them bring their visions to life online.",
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 18 : 21,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            "Let’s create something amazing together!",
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 18 : 21,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineSocialIcon(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Icon(
        icon,
        size: 22,
        color: colorScheme.onSurface.withValues(alpha: 0.5),
      ),
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/portfolio_controller.dart';
import '../../../models/portfolio_models.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/shared/custom_widgets.dart';
import '../../../widgets/shared/footer_section.dart';

class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ResumeHeroSection(),
            _ResumeOverviewSection(),
            _ResumeExperienceSection(),
            _ResumeHighlightsSection(),
            _ResumeClosingSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}

class _ResumeHeroSection extends StatelessWidget {
  const _ResumeHeroSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final info = controller.personalInfo.value;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final hPad =
        isMobile
            ? 20.0
            : isTablet
            ? 48.0
            : 88.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? const [
                    Color(0xFF080808),
                    Color(0xFF101813),
                    Color(0xFF0A0A0A),
                  ]
                  : const [
                    Color(0xFFF8FBF7),
                    Color(0xFFEFF6EC),
                    Color(0xFFF9FAF8),
                  ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          hPad,
          isMobile ? 40 : 64,
          hPad,
          isMobile ? 40 : 64,
        ),
        child: Wrap(
          spacing: 36,
          runSpacing: 36,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 640,
              ),
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
                        'Portfolio / Resume',
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
                  Text(
                    'Resume',
                    style: GoogleFonts.inter(
                      fontSize:
                          isMobile
                              ? 60
                              : isTablet
                              ? 88
                              : 108,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      height: 0.92,
                      letterSpacing: isMobile ? -2.5 : -4.5,
                    ),
                  ),
                  SizedBox(height: isMobile ? 18 : 28),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Text(
                      'A clean snapshot of my work, experience, strengths, and the product thinking I bring into every Flutter build.',
                      style: GoogleFonts.manrope(
                        fontSize: isMobile ? 16 : 19,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurface.withValues(alpha: 0.58),
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 28 : 36),
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      _ResumeActionButton(
                        label: 'Download CV',
                        icon: Icons.download_rounded,
                        isPrimary: true,
                        onPressed: controller.launchResume,
                      ),
                      _ResumeActionButton(
                        label: 'Email Me',
                        icon: Icons.north_east_rounded,
                        onPressed: controller.launchEmail,
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 28 : 40),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _HeroPill(
                        icon: Icons.phone_android_rounded,
                        label: 'Flutter Specialist',
                      ),
                      _HeroPill(
                        icon: Icons.design_services_outlined,
                        label: 'UI-minded Builder',
                      ),
                      _HeroPill(
                        icon: Icons.location_on_outlined,
                        label: info.location,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _ResumeIdentityCard(info: info),
          ],
        ),
      ),
    );
  }
}

class _ResumeOverviewSection extends StatelessWidget {
  const _ResumeOverviewSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final info = controller.personalInfo.value;
    final experiences = controller.experiences;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hPad =
        isMobile
            ? 20.0
            : isTablet
            ? 48.0
            : 88.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 48 : 80, hPad, 0),
      child: _RevealSequence(
        startDelay: 120,
        stepDelay: 180,
        children: [
          _SectionHeading(
            eyebrow: '{01} - Professional Summary',
            title: 'A resume that reads like the way I work.',
            description:
                'Blending visual polish, product sense, and reliable delivery across cross-platform experiences.',
          ),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              _SummaryCard(
                title: 'Profile',
                accent: const Color(0xFF103B2B),
                background: const Color(0xFFE9F7EE),
                child: Text(
                  info.bio,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    height: 1.8,
                    color: const Color(0xFF17362C),
                  ),
                ),
              ),
              _SummaryCard(
                title: 'Quick Facts',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FactRow(label: 'Role', value: info.title),
                    _FactRow(
                      label: 'Experience',
                      value: '${experiences.length}+ professional roles',
                    ),
                    _FactRow(label: 'Location', value: info.location),
                    _FactRow(label: 'Email', value: info.email),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResumeExperienceSection extends StatelessWidget {
  const _ResumeExperienceSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final experiences = controller.experiences;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hPad =
        isMobile
            ? 20.0
            : isTablet
            ? 48.0
            : 88.0;

    final revealChildren = <Widget>[
      const _SectionHeading(
        eyebrow: '{02} - Experience Timeline',
        title: 'The resume content unfolds one step at a time.',
        description:
            'Each role highlights ownership, delivery focus, and the stack behind the outcome.',
      ),
      ...experiences.map(
        (experience) => _ResumeExperienceCard(experience: experience),
      ),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 48 : 80, hPad, 0),
      child: _RevealSequence(
        startDelay: 320,
        stepDelay: 200,
        children: revealChildren,
      ),
    );
  }
}

class _ResumeHighlightsSection extends StatelessWidget {
  const _ResumeHighlightsSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hPad =
        isMobile
            ? 20.0
            : isTablet
            ? 48.0
            : 88.0;

    final cards = [
      const _HighlightCard(
        title: 'Core Skills',
        items: [
          'Flutter and Dart development',
          'Responsive web and mobile UI',
          'Firebase integrations',
          'REST API implementation',
          'Clean architecture patterns',
          'Performance-focused delivery',
        ],
      ),
      const _HighlightCard(
        title: 'Working Style',
        items: [
          'Design-aware implementation',
          'Strong product ownership',
          'Fast iteration with feedback',
          'Readable, maintainable code',
          'Collaborative communication',
          'Reliable delivery mindset',
        ],
      ),
      const _HighlightCard(
        title: 'Value I Bring',
        items: [
          'Translate ideas into polished apps',
          'Balance speed with quality',
          'Build for scale and reuse',
          'Create consistent experiences',
          'Spot UX and technical gaps early',
          'Keep momentum across project phases',
        ],
      ),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 48 : 80, hPad, 0),
      child: _RevealSequence(
        startDelay: 760,
        stepDelay: 180,
        children: [
          const _SectionHeading(
            eyebrow: '{03} - Resume Snapshot',
            title: 'Skills, strengths, and delivery habits.',
            description:
                'A quick way to scan capabilities without losing the premium editorial feel of the page.',
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final useSingleColumn = constraints.maxWidth < 900;
              if (useSingleColumn) {
                return Column(
                  children: [
                    for (int i = 0; i < cards.length; i++) ...[
                      cards[i],
                      if (i != cards.length - 1) const SizedBox(height: 20),
                    ],
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < cards.length; i++) ...[
                    Expanded(child: cards[i]),
                    if (i != cards.length - 1) const SizedBox(width: 20),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ResumeClosingSection extends StatelessWidget {
  const _ResumeClosingSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hPad =
        isMobile
            ? 20.0
            : isTablet
            ? 48.0
            : 88.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        hPad,
        isMobile ? 48 : 80,
        hPad,
        isMobile ? 48 : 80,
      ),
      child: _RevealSequence(
        startDelay: 1120,
        stepDelay: 180,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 24 : 32),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1512),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Want the full resume file?',
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 28 : 38,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Download the CV or reach out directly if you want a version tailored for product, freelance, or full-time opportunities.',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          height: 1.7,
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    _ResumeActionButton(
                      label: 'Download CV',
                      icon: Icons.file_download_outlined,
                      isPrimary: true,
                      onPressed: controller.launchResume,
                    ),
                    _ResumeActionButton(
                      label: 'Contact Me',
                      icon: Icons.mail_outline_rounded,
                      onPressed: controller.launchEmail,
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

class _ResumeIdentityCard extends StatelessWidget {
  const _ResumeIdentityCard({required this.info});

  final PersonalInfo info;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: isMobile ? double.infinity : 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.grey[300],
            backgroundImage: const AssetImage(
              'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            info.name,
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            info.title,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.65),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),
          _IdentityRow(icon: Icons.email_outlined, label: info.email),
          const SizedBox(height: 14),
          _IdentityRow(icon: Icons.location_on_outlined, label: info.location),
          const SizedBox(height: 14),
          _IdentityRow(
            icon: Icons.verified_outlined,
            label: 'Open to impactful Flutter work',
          ),
        ],
      ),
    );
  }
}

class _ResumeExperienceCard extends StatelessWidget {
  const _ResumeExperienceCard({required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 14,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience.position,
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 24 : 30,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    experience.company,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  experience.duration,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            experience.description,
            style: GoogleFonts.manrope(
              fontSize: 15,
              height: 1.8,
              color: colorScheme.onSurface.withValues(alpha: 0.74),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: experience.technologies
                .map((tech) => _TechPill(label: tech))
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _RevealSequence extends StatelessWidget {
  const _RevealSequence({
    required this.children,
    this.startDelay = 0,
    this.stepDelay = 160,
  });

  final List<Widget> children;
  final int startDelay;
  final int stepDelay;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int index = 0; index < children.length; index++) ...[
          _DelayedReveal(
            delay: Duration(milliseconds: startDelay + (index * stepDelay)),
            child: children[index],
          ),
          if (index != children.length - 1) const SizedBox(height: 24),
        ],
      ],
    );
  }
}

class _DelayedReveal extends StatefulWidget {
  const _DelayedReveal({required this.child, required this.delay});

  final Widget child;
  final Duration delay;

  @override
  State<_DelayedReveal> createState() => _DelayedRevealState();
}

class _DelayedRevealState extends State<_DelayedReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _timer = Timer(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              eyebrow,
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
        const SizedBox(height: 14),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 30 : 42,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            height: 1.04,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            description,
            style: GoogleFonts.manrope(
              fontSize: 16,
              height: 1.7,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResumeActionButton extends StatelessWidget {
  const _ResumeActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final buttonStyle =
        isPrimary
            ? ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              elevation: 0,
            )
            : OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              side: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            );

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );

    return isPrimary
        ? ElevatedButton(onPressed: onPressed, style: buttonStyle, child: child)
        : OutlinedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryGreen),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.child,
    this.accent,
    this.background,
  });

  final String title;
  final Widget child;
  final Color? accent;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 560),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: background ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: accent ?? colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: colorScheme.onSurface.withValues(alpha: 0.42),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.78),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryGreen),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.72),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _TechPill extends StatelessWidget {
  const _TechPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF24552F),
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 18),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        height: 1.6,
                        color: colorScheme.onSurface.withValues(alpha: 0.72),
                      ),
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
}

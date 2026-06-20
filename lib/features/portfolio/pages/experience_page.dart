import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/app_colors.dart';
import '../models/portfolio_models.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../widgets/shared/custom_widgets.dart';
import '../widgets/shared/footer_section.dart';

class ExperiencePage extends ConsumerWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ExperienceHeroSection(),
            _ExperienceTimelineSection(experiences: state.experiences),
            const _ExperienceStrengthsSection(),
            const _ExperienceClosingSection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

class _ExperienceHeroSection extends ConsumerWidget {
  const _ExperienceHeroSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final info = state.personalInfo;
    final experiences = state.experiences;
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
                    Color(0xFF131813),
                    Color(0xFF0A0A0A),
                  ]
                  : const [
                    Color(0xFFF8FBF7),
                    Color(0xFFEEF6EF),
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
                        'Portfolio / Experience',
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
                    'Experience',
                    style: GoogleFonts.inter(
                      fontSize:
                          isMobile
                              ? 56
                              : isTablet
                              ? 84
                              : 104,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      height: 0.92,
                      letterSpacing: isMobile ? -2.2 : -4.2,
                    ),
                  ),
                  SizedBox(height: isMobile ? 18 : 28),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Text(
                      'A closer look at the roles, responsibilities, and delivery mindset behind the products I have helped bring to life.',
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
                      _HeroActionButton(
                        label: 'Contact Me',
                        icon: Icons.north_east_rounded,
                        isPrimary: true,
                        onPressed: () => ref.read(portfolioProvider.notifier).launchEmail(),
                      ),
                      _HeroActionButton(
                        label: 'Download CV',
                        icon: Icons.download_rounded,
                        onPressed: () => ref.read(portfolioProvider.notifier).launchResume(),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 28 : 40),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _HeroPill(
                        icon: Icons.work_outline_rounded,
                        label: '${experiences.length}+ Roles',
                      ),
                      const _HeroPill(
                        icon: Icons.phone_android_rounded,
                        label: 'Flutter Delivery',
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
            _ExperienceProfileCard(info: info, experiences: experiences),
          ],
        ),
      ),
    );
  }
}

class _ExperienceTimelineSection extends StatelessWidget {
  const _ExperienceTimelineSection({required this.experiences});

  final List<Experience> experiences;

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

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 48 : 80, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            eyebrow: '{01} - Professional Journey',
            title: 'A timeline of how the work has evolved.',
            description:
                'Each role adds more ownership, sharper execution, and stronger product delivery across Flutter-based experiences.',
          ),
          const SizedBox(height: 24),
          ...experiences.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.key == experiences.length - 1 ? 0 : 24,
              ),
              child: _TimelineExperienceCard(experience: entry.value),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceStrengthsSection extends StatelessWidget {
  const _ExperienceStrengthsSection();

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

    const cards = [
      _StrengthCard(
        title: 'Cross-Platform Thinking',
        description:
            'Build experiences that feel polished and consistent across mobile and web without losing product clarity.',
      ),
      _StrengthCard(
        title: 'Clean Execution',
        description:
            'Turn requirements into maintainable Flutter implementations with scalable structure and readable code.',
      ),
      _StrengthCard(
        title: 'Design Awareness',
        description:
            'Care about rhythm, spacing, motion, and UX details so delivery feels intentional rather than assembled.',
      ),
      _StrengthCard(
        title: 'Reliable Collaboration',
        description:
            'Keep projects moving with communication, feedback loops, and a practical balance between quality and speed.',
      ),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 48 : 80, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            eyebrow: '{02} - What I Bring',
            title: 'The strengths behind the experience.',
            description:
                'Beyond job titles, this is the working style and value I try to bring into every project.',
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 1000) {
                return Column(
                  children: [
                    for (int i = 0; i < cards.length; i++) ...[
                      cards[i],
                      if (i != cards.length - 1) const SizedBox(height: 20),
                    ],
                  ],
                );
              }

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: cards
                    .map(
                      (card) => SizedBox(
                        width: (constraints.maxWidth - 20) / 2,
                        child: card,
                      ),
                    )
                    .toList(growable: false),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExperienceClosingSection extends ConsumerWidget {
  const _ExperienceClosingSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      child: Container(
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
                    'Interested in the full background?',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 28 : 38,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Reach out for a conversation or download the CV if you want the complete role history and project context.',
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
                _HeroActionButton(
                  label: 'Download CV',
                  icon: Icons.file_download_outlined,
                  isPrimary: true,
                  onPressed: () => ref.read(portfolioProvider.notifier).launchResume(),
                ),
                _HeroActionButton(
                  label: 'Get In Touch',
                  icon: Icons.mail_outline_rounded,
                  onPressed: () => ref.read(portfolioProvider.notifier).launchEmail(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceProfileCard extends StatelessWidget {
  const _ExperienceProfileCard({required this.info, required this.experiences});

  final PersonalInfo info;
  final List<Experience> experiences;

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
          _ProfileMetric(
            value: '${experiences.length}+',
            label: 'Professional roles listed on this page',
          ),
          const SizedBox(height: 14),
          _ProfileMetric(
            value: experiences.isEmpty ? 'Now' : experiences.first.duration,
            label: 'Current focus and latest visible timeline entry',
          ),
          const SizedBox(height: 14),
          _ProfileMetric(
            value: info.location,
            label: 'Available for remote and collaborative work',
          ),
        ],
      ),
    );
  }
}

class _TimelineExperienceCard extends StatelessWidget {
  const _TimelineExperienceCard({required this.experience});

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
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isMobile ? 260 : 520),
                    child: Column(
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

class _StrengthCard extends StatelessWidget {
  const _StrengthCard({required this.title, required this.description});

  final String title;
  final String description;

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
          const SizedBox(height: 14),
          Text(
            description,
            style: GoogleFonts.manrope(
              fontSize: 15,
              height: 1.7,
              color: colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
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

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.darkGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../shared/custom_widgets.dart';

/// Topics typed out one after another in the hero subtitle.
const _kTopics = [
  'your next app.',
  'a Flutter build.',
  'a collaboration.',
  'product ideas.',
  'freelance work.',
];

/// Contact page hero, laid out like the About, Blog and My Work heroes: the
/// profile card on the left, and a "Contact me" heading with an animated
/// subtitle, intro, email / CV buttons and quick-info pills on the right.
class ContactHeroSection extends ConsumerStatefulWidget {
  const ContactHeroSection({super.key});

  @override
  ConsumerState<ContactHeroSection> createState() =>
      _ContactHeroSectionState();
}

class _ContactHeroSectionState extends ConsumerState<ContactHeroSection>
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
    final info = ref.watch(portfolioProvider).personalInfo;
    final crossAlign =
        centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;
    final wrapAlign = centered ? WrapAlignment.center : WrapAlignment.start;

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
                    'Portfolio / Contact',
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
                'Contact me',
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
                prefix: "Let's talk about ",
                words: _kTopics,
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
              'If you have a project, collaboration idea, or just want to '
              'talk product and Flutter, this is the best place to reach out.',
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
                    label: 'Send email',
                    icon: Icons.north_east_rounded,
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
              SizedBox(height: isMobile ? 28 : 36),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: wrapAlign,
                children: [
                  const ContactHeroPill(
                    icon: Icons.email_outlined,
                    label: 'Quick replies',
                  ),
                  const ContactHeroPill(
                    icon: Icons.groups_outlined,
                    label: 'Open to collaboration',
                  ),
                  if (info.location.isNotEmpty)
                    ContactHeroPill(
                      icon: Icons.location_on_outlined,
                      label: info.location,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ContactHeroPill extends StatelessWidget {
  const ContactHeroPill({super.key, required this.icon, required this.label});

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

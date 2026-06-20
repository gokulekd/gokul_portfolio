import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../models/portfolio_models.dart';
import '../../../../providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'contact_closing_section.dart' show ContactProfileCard;

class ContactHeroSection extends ConsumerWidget {
  const ContactHeroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final info = state.personalInfo;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = !isMobile && !isTablet;
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
                    Color(0xFF13161A),
                    Color(0xFF0A0A0A),
                  ]
                  : const [
                    Color(0xFFF8FBF7),
                    Color(0xFFF1F4FB),
                    Color(0xFFF9FAF8),
                  ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          hPad,
          isMobile ? 40 : 56,
          hPad,
          isMobile ? 40 : 56,
        ),
        child:
            isDesktop
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: ContactHeroContent(
                          info: info,
                          colorScheme: colorScheme,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ContactProfileCard(info: info),
                      ),
                    ),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContactHeroContent(info: info, colorScheme: colorScheme),
                    const SizedBox(height: 28),
                    ContactProfileCard(info: info),
                  ],
                ),
      ),
    );
  }
}

class ContactHeroContent extends ConsumerWidget {
  const ContactHeroContent({super.key, required this.info, required this.colorScheme});

  final PersonalInfo info;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
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
        SizedBox(height: isMobile ? 16 : 20),
        Text(
          'Contact Me',
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
        SizedBox(height: isMobile ? 18 : 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            'If you have a project, collaboration idea, or just want to talk product and Flutter, this is the best place to reach out.',
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 16 : 19,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withValues(alpha: 0.58),
              height: 1.6,
            ),
          ),
        ),
        SizedBox(height: isMobile ? 28 : 32),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            HeroActionButton(
              label: 'Send Email',
              icon: Icons.north_east_rounded,
              isPrimary: true,
              onPressed: () => ref.read(portfolioProvider.notifier).launchEmail(),
            ),
            HeroActionButton(
              label: 'Download CV',
              icon: Icons.download_rounded,
              onPressed: () => ref.read(portfolioProvider.notifier).launchResume(),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 28 : 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            const ContactHeroPill(icon: Icons.email_outlined, label: 'Quick Replies'),
            const ContactHeroPill(
              icon: Icons.groups_outlined,
              label: 'Open to Collaboration',
            ),
            ContactHeroPill(icon: Icons.location_on_outlined, label: info.location),
          ],
        ),
      ],
    );
  }
}

class HeroActionButton extends StatelessWidget {
  const HeroActionButton({
    super.key,
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

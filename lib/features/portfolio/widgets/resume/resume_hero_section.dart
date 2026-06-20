import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'resume_components.dart';

class ResumeHeroSection extends ConsumerWidget {
  const ResumeHeroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final info = state.personalInfo;
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
                      ResumeActionButton(
                        label: 'Download CV',
                        icon: Icons.download_rounded,
                        isPrimary: true,
                        onPressed: () => ref.read(portfolioProvider.notifier).launchResume(),
                      ),
                      ResumeActionButton(
                        label: 'Email Me',
                        icon: Icons.north_east_rounded,
                        onPressed: () => ref.read(portfolioProvider.notifier).launchEmail(),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 28 : 40),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ResumeHeroPill(
                        icon: Icons.phone_android_rounded,
                        label: 'Flutter Specialist',
                      ),
                      ResumeHeroPill(
                        icon: Icons.design_services_outlined,
                        label: 'UI-minded Builder',
                      ),
                      ResumeHeroPill(
                        icon: Icons.location_on_outlined,
                        label: info.location,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ResumeIdentityCard(info: info),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'resume_components.dart';

class ResumeClosingSection extends ConsumerWidget {
  const ResumeClosingSection({super.key});

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
      child: RevealSequence(
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
                    ResumeActionButton(
                      label: 'Download CV',
                      icon: Icons.file_download_outlined,
                      isPrimary: true,
                      onPressed: () => ref.read(portfolioProvider.notifier).launchResume(),
                    ),
                    ResumeActionButton(
                      label: 'Contact Me',
                      icon: Icons.mail_outline_rounded,
                      onPressed: () => ref.read(portfolioProvider.notifier).launchEmail(),
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

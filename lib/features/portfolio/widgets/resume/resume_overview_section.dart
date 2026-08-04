import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'resume_components.dart';

class ResumeOverviewSection extends ConsumerWidget {
  const ResumeOverviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final info = state.personalInfo;
    final experiences = state.visibleExperiences;
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
      child: RevealSequence(
        startDelay: 120,
        stepDelay: 180,
        children: [
          ResumeSectionHeading(
            eyebrow: '{01} - Professional Summary',
            title: 'A resume that reads like the way I work.',
            description:
                'Blending visual polish, product sense, and reliable delivery across cross-platform experiences.',
          ),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              SummaryCard(
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
              SummaryCard(
                title: 'Quick Facts',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FactRow(label: 'Role', value: info.title),
                    FactRow(
                      label: 'Experience',
                      value: '${experiences.length}+ professional roles',
                    ),
                    FactRow(label: 'Location', value: info.location),
                    FactRow(label: 'Email', value: info.email),
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

import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_helper.dart';
import 'resume_components.dart';

class ResumeHighlightsSection extends StatelessWidget {
  const ResumeHighlightsSection({super.key});

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
      const HighlightCard(
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
      const HighlightCard(
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
      const HighlightCard(
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
      child: RevealSequence(
        startDelay: 760,
        stepDelay: 180,
        children: [
          const ResumeSectionHeading(
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

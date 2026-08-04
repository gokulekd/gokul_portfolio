import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'resume_components.dart';

// `cards` used to be three hardcoded `HighlightCard`s; the section now reads
// `ResumeHighlightGroup` from Firestore via
// `portfolioProvider.visibleResumeHighlights`.

class ResumeHighlightsSection extends ConsumerWidget {
  const ResumeHighlightsSection({super.key});

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

    final groups = ref.watch(
      portfolioProvider.select((s) => s.visibleResumeHighlights),
    );
    final cards = [
      for (final group in groups)
        HighlightCard(title: group.title, items: group.items),
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

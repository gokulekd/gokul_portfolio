import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'experience_components.dart';

// `cards` used to be hardcoded `StrengthCard` data; the section now reads
// `ExperienceStrengthItem` from Firestore via
// `portfolioProvider.visibleExperienceStrengths`.

class ExperienceStrengthsSection extends ConsumerWidget {
  const ExperienceStrengthsSection({super.key});

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

    final strengths = ref.watch(
      portfolioProvider.select((s) => s.visibleExperienceStrengths),
    );
    final cards = [
      for (final strength in strengths)
        StrengthCard(title: strength.title, description: strength.description),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 48 : 80, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ExperienceSectionHeading(
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

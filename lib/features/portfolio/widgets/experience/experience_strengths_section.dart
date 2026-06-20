import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_helper.dart';
import 'experience_components.dart';

class ExperienceStrengthsSection extends StatelessWidget {
  const ExperienceStrengthsSection({super.key});

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
      StrengthCard(
        title: 'Cross-Platform Thinking',
        description:
            'Build experiences that feel polished and consistent across mobile and web without losing product clarity.',
      ),
      StrengthCard(
        title: 'Clean Execution',
        description:
            'Turn requirements into maintainable Flutter implementations with scalable structure and readable code.',
      ),
      StrengthCard(
        title: 'Design Awareness',
        description:
            'Care about rhythm, spacing, motion, and UX details so delivery feels intentional rather than assembled.',
      ),
      StrengthCard(
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

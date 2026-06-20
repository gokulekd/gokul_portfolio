import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_helper.dart';
import '../../models/portfolio_models.dart';
import 'experience_components.dart';

class ExperienceTimelineSection extends StatelessWidget {
  const ExperienceTimelineSection({super.key, required this.experiences});

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
          const ExperienceSectionHeading(
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
              child: TimelineExperienceCard(experience: entry.value),
            ),
          ),
        ],
      ),
    );
  }
}

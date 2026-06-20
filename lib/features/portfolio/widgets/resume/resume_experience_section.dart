import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'resume_components.dart';

class ResumeExperienceSection extends ConsumerWidget {
  const ResumeExperienceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final experiences = state.experiences;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hPad =
        isMobile
            ? 20.0
            : isTablet
            ? 48.0
            : 88.0;

    final revealChildren = <Widget>[
      const ResumeSectionHeading(
        eyebrow: '{02} - Experience Timeline',
        title: 'The resume content unfolds one step at a time.',
        description:
            'Each role highlights ownership, delivery focus, and the stack behind the outcome.',
      ),
      ...experiences.map(
        (experience) => ResumeExperienceCard(experience: experience),
      ),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 48 : 80, hPad, 0),
      child: RevealSequence(
        startDelay: 320,
        stepDelay: 200,
        children: revealChildren,
      ),
    );
  }
}

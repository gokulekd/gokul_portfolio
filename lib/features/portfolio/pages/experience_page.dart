import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/portfolio_provider.dart';
import '../widgets/shared/custom_widgets.dart';
import '../widgets/experience/widgets.dart';

class ExperiencePage extends ConsumerWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ExperienceHeroSection(),
            ExperienceTimelineSection(experiences: state.experiences),
            const ExperienceStrengthsSection(),
            const ExperienceClosingSection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

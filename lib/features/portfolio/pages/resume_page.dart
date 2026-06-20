import 'package:flutter/material.dart';

import '../widgets/resume/resume_widgets.dart';
import '../widgets/shared/custom_widgets.dart';
import '../widgets/shared/footer_section.dart';

class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResumeHeroSection(),
            ResumeOverviewSection(),
            ResumeExperienceSection(),
            ResumeHighlightsSection(),
            ResumeClosingSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}

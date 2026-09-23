import 'package:flutter/material.dart';

import '../widgets/about/widgets.dart';
import '../widgets/shared/custom_widgets.dart';
import '../widgets/home/skills_section.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AboutHeroSection(),
            const EducationExperienceSection(),
            const SizedBox(height: 32),
            const SkillsSection(eyebrow: '{03} - My Skills'),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

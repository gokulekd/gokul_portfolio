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
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 48, 24, 0),
              child: EducationExperienceSection(),
            ),
            const SizedBox(height: 32),
            const SkillsSection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

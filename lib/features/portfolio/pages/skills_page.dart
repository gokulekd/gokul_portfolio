import 'package:flutter/material.dart';

import '../widgets/shared/custom_widgets.dart';
import '../widgets/home/skills_section.dart';
import '../widgets/skills/skills_page_components.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [SkillsHeroSection(), SkillsSection(), FooterSection()],
        ),
      ),
    );
  }
}

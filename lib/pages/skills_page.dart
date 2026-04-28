import 'package:flutter/material.dart';

import '../widgets/custom_widgets.dart';
import '../widgets/skills_section.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(child: const SkillsSection()),
    );
  }
}

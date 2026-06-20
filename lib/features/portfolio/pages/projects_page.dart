import 'package:flutter/material.dart';

import '../widgets/shared/custom_widgets.dart';
import '../widgets/projects/projects_components.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProjectsHeroSection(),
            FeaturedProjectsSectionWrapper(),
            AllProjectsSection(),
            ProjectsCTASection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}

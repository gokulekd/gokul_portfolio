import 'package:flutter/material.dart';

import '../widgets/cta_section.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/featured_projects_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/hero_section_fixed.dart';
import '../widgets/process_section.dart';
import '../widgets/project_types_marquee.dart';
import '../widgets/skills_section.dart';
import '../widgets/stats_marquee.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Hero Section
            const HeroSection(),

            // Stats Marquee
            const StatsMarquee(),

            // CTA Section
            const CtaSection(),

            // Skills Section
            SkillsSection(scrollController: _scrollController),

            // Featured Projects
            const FeaturedProjectsSection(),

            // Project Types Marquee
            const ProjectTypesMarquee(),

            // Process Section
            const ProcessSection(),

            // Footer Section
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

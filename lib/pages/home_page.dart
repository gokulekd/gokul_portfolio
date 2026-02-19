import 'package:flutter/material.dart';

import '../widgets/contact_section.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/faq_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/freelance_process_section.dart';
import '../widgets/hero_section_fixed.dart';
import '../widgets/project_types_marquee.dart';
import '../widgets/proud_achievements_section.dart';
import '../widgets/selected_projects_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/stats_marquee.dart';
import '../widgets/testimonials_section_new.dart';

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

            // Skills Section
            SkillsSection(scrollController: _scrollController),

            // Selected Projects
            const SelectedProjectsSection(),

            // Project Types Marquee
            const ProjectTypesMarquee(),

            // Proud Achievements Section
            const ProudAchievementsSection(),

            // Process Section
            const FreelanceProcessSection(),

            // Testimonials Section
            const TestimonialsSectionNew(),

            // FAQ Section
            const FAQSection(),

            // Contact Section
            const ContactSection(),
            // Stats Marquee
            const StatsMarquee(
              backgroundColor: Color(0xFF0A0A0A),
              padding: EdgeInsets.zero,
            ),
            // Footer Section
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

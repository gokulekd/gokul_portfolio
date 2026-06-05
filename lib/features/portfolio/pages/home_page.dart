import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/portfolio_controller.dart';
import '../../../models/firebase_content_models.dart';
import '../../../widgets/home/contact_section.dart';
import '../../../widgets/shared/custom_widgets.dart';
import '../../../widgets/home/faq_section.dart';
import '../../../widgets/shared/footer_section.dart';
import '../../../widgets/home/freelance_process_section.dart';
import '../../../widgets/home/hero_section.dart';
import '../../../widgets/home/project_types_marquee.dart';
import '../../../widgets/home/proud_achievements_section.dart';
import '../../../widgets/shared/scroll_progress_bar.dart';
import '../../../widgets/home/selected_projects_section.dart';
import '../../../widgets/home/skills_section.dart';
import '../../../widgets/home/stats_marquee.dart';
import '../../../widgets/home/testimonials_section.dart';

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
    final controller = Get.find<PortfolioController>();

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Obx(
              () => Column(
                children: [
                  if (controller.isSectionVisible(SiteSectionKeys.hero))
                    const HeroSection(),
                  if (controller.isSectionVisible(SiteSectionKeys.statsTop))
                    const StatsMarquee(
                      backgroundColor: Color(0xFF0A0A0A),
                      padding: EdgeInsets.zero,
                    ),
                  if (controller.isSectionVisible(
                    SiteSectionKeys.skillsExperience,
                  ))
                    SkillsSection(scrollController: _scrollController),
                  if (controller.isSectionVisible(
                    SiteSectionKeys.featuredProjects,
                  ))
                    const SelectedProjectsSection(),
                  if (controller.isSectionVisible(
                    SiteSectionKeys.developmentAreas,
                  ))
                    const ProjectTypesMarquee(),
                  if (controller.isSectionVisible(SiteSectionKeys.achievements))
                    const ProudAchievementsSection(),
                  if (controller.isSectionVisible(
                    SiteSectionKeys.freelanceProcess,
                  ))
                    const FreelanceProcessSection(),
                  if (controller.isSectionVisible(SiteSectionKeys.testimonials))
                    const TestimonialsSectionNew(),
                  if (controller.isSectionVisible(SiteSectionKeys.faq))
                    const FAQSection(),
                  if (controller.isSectionVisible(SiteSectionKeys.contact))
                    const ContactSection(),
                  if (controller.isSectionVisible(SiteSectionKeys.statsBottom))
                    const StatsMarquee(
                      backgroundColor: Color(0xFF0A0A0A),
                      padding: EdgeInsets.zero,
                    ),
                  if (controller.isSectionVisible(SiteSectionKeys.footer))
                    const FooterSection(),
                ],
              ),
            ),
          ),
          // Scroll progress bar overlaid at the very top
          ScrollProgressBar(scrollController: _scrollController),
        ],
      ),
    );
  }
}

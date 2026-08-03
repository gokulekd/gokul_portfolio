import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/firebase_content_models.dart';
import '../../../core/providers/portfolio_provider.dart';
import '../widgets/home/contact_section.dart';
import '../widgets/shared/custom_widgets.dart';
import '../widgets/home/faq_section.dart';
import '../widgets/home/freelance_process_section.dart';
import '../widgets/home/hero_section.dart';
import '../widgets/home/project_types_marquee.dart';
import '../widgets/home/proud_achievements_section.dart';
import '../widgets/home/selected_projects_section.dart';
import '../widgets/home/skills_section.dart';
import '../widgets/home/stats_marquee.dart';
import '../widgets/home/testimonials_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
    final state = ref.watch(portfolioProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                if (state.isSectionVisible(SiteSectionKeys.hero))
                  const HeroSection(),
                if (state.isSectionVisible(SiteSectionKeys.statsTop))
                  const StatsMarquee(
                    backgroundColor: Color(0xFF0A0A0A),
                    padding: EdgeInsets.zero,
                    placement: StatItemPlacement.top,
                  ),
                if (state.isSectionVisible(SiteSectionKeys.skillsExperience))
                  SkillsSection(scrollController: _scrollController),
                if (state.isSectionVisible(SiteSectionKeys.featuredProjects))
                  const SelectedProjectsSection(),
                if (state.isSectionVisible(SiteSectionKeys.developmentAreas))
                  const ProjectTypesMarquee(),
                if (state.isSectionVisible(SiteSectionKeys.achievements))
                  const ProudAchievementsSection(),
                if (state.isSectionVisible(SiteSectionKeys.freelanceProcess))
                  const FreelanceProcessSection(),
                if (state.isSectionVisible(SiteSectionKeys.testimonials))
                  const TestimonialsSectionNew(),
                if (state.isSectionVisible(SiteSectionKeys.faq))
                  const FAQSection(),
                if (state.isSectionVisible(SiteSectionKeys.contact))
                  const ContactSection(),
                if (state.isSectionVisible(SiteSectionKeys.statsBottom))
                  const StatsMarquee(
                    backgroundColor: Color(0xFF0A0A0A),
                    padding: EdgeInsets.zero,
                    placement: StatItemPlacement.bottom,
                  ),
                if (state.isSectionVisible(SiteSectionKeys.footer))
                  const FooterSection(),
              ],
            ),
          ),
          ScrollProgressBar(scrollController: _scrollController),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../models/firebase_content_models.dart';
import '../../../models/portfolio_models.dart';
import '../../../services/firebase_portfolio_service.dart';
import '../models/admin_portal_models.dart';

class AdminPortalController extends GetxController {
  final FirebasePortfolioService _portfolioService =
      Get.find<FirebasePortfolioService>();

  final selectedModule = AdminModule.dashboard.obs;
  final liveSections = <SiteSectionConfig>[].obs;
  final liveSocialLinks = <ManagedSocialLink>[].obs;
  final liveProjects = <Project>[].obs;

  StreamSubscription<List<SiteSectionConfig>>? _sectionsSubscription;
  StreamSubscription<List<ManagedSocialLink>>? _socialLinksSubscription;
  StreamSubscription<List<Project>>? _projectsSubscription;

  final modules = const <AdminModuleItem>[
    AdminModuleItem(
      module: AdminModule.dashboard,
      title: 'Dashboard',
      subtitle: 'Command center',
      icon: Icons.space_dashboard_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.siteStructure,
      title: 'Site Structure',
      subtitle: 'Visibility and order',
      icon: Icons.view_sidebar_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.homeContent,
      title: 'Home Content',
      subtitle: 'Hero and headlines',
      icon: Icons.home_work_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.projects,
      title: 'Projects',
      subtitle: 'Featured portfolio',
      icon: Icons.workspaces_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.skillsExperience,
      title: 'Skills & Experience',
      subtitle: 'Skills and timeline',
      icon: Icons.stacked_line_chart_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.developmentAreas,
      title: 'Development Areas',
      subtitle: 'Scrolling specialities',
      icon: Icons.apps_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.achievements,
      title: 'Achievements',
      subtitle: 'Proof and metrics',
      icon: Icons.workspace_premium_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.guidingPrinciples,
      title: 'Guiding Principles',
      subtitle: 'Core operating values',
      icon: Icons.auto_awesome_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.freelanceProcess,
      title: 'Freelance Process',
      subtitle: 'Client journey',
      icon: Icons.route_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.testimonials,
      title: 'Testimonials',
      subtitle: 'Client trust',
      icon: Icons.record_voice_over_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.faq,
      title: 'FAQ',
      subtitle: 'Common questions',
      icon: Icons.quiz_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.socialContact,
      title: 'Social & Contact',
      subtitle: 'Channels and links',
      icon: Icons.alternate_email_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.blog,
      title: 'Blog',
      subtitle: 'Editorial content',
      icon: Icons.edit_note_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.submissions,
      title: 'Visitor Submissions',
      subtitle: 'Leads inbox',
      icon: Icons.inbox_rounded,
      badgeCount: 3,
    ),
    AdminModuleItem(
      module: AdminModule.mediaLibrary,
      title: 'Media Library',
      subtitle: 'Images and assets',
      icon: Icons.perm_media_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.settings,
      title: 'Settings',
      subtitle: 'Auth and config',
      icon: Icons.settings_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.createPost,
      title: 'Create Post',
      subtitle: 'Write & publish content',
      icon: Icons.add_circle_outline_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.managePages,
      title: 'Manage Pages',
      subtitle: 'All portfolio pages',
      icon: Icons.web_rounded,
    ),
    AdminModuleItem(
      module: AdminModule.resumeManagement,
      title: 'Resume',
      subtitle: 'Upload & manage CV',
      icon: Icons.description_rounded,
    ),
  ];

  final fallbackCollections = const <AdminCollectionItem>[
    AdminCollectionItem(
      title: 'Featured Projects',
      subtitle: 'Curate the most visible work on the homepage.',
      state: AdminItemState.live,
      lastEdited: 'Waiting for Firestore content',
      highlight: 'Collection',
    ),
    AdminCollectionItem(
      title: 'Testimonials',
      subtitle: 'Control trust signals, client quotes, and featured reviews.',
      state: AdminItemState.draft,
      lastEdited: 'Waiting for Firestore content',
      highlight: 'Collection',
    ),
    AdminCollectionItem(
      title: 'Blog Content',
      subtitle: 'Manage editorial posts, tags, publish states, and covers.',
      state: AdminItemState.live,
      lastEdited: 'Waiting for Firestore content',
      highlight: 'Collection',
    ),
  ];

  final recentLeads = const <AdminLeadItem>[
    AdminLeadItem(
      name: 'Aarav Studios',
      company: 'aarav.design',
      summary: 'Need a Flutter product site and admin dashboard in 3 weeks.',
      status: 'New',
      receivedAt: '6 min ago',
      unread: true,
    ),
    AdminLeadItem(
      name: 'Mira Health',
      company: 'mirahealth.io',
      summary: 'Asked for mobile app redesign, Firebase workflow, and support.',
      status: 'Reviewing',
      receivedAt: '48 min ago',
      unread: true,
    ),
    AdminLeadItem(
      name: 'Northbound Labs',
      company: 'northboundlabs.com',
      summary: 'Requested portfolio-style case study site with blog migration.',
      status: 'Replied',
      receivedAt: '2 hrs ago',
    ),
  ];

  bool get isFirebaseConnected => _portfolioService.isEnabled;

  @override
  void onInit() {
    super.onInit();
    _bindLiveContent();
  }

  void _bindLiveContent() {
    if (!_portfolioService.isEnabled) {
      return;
    }

    _sectionsSubscription = _portfolioService.streamSiteSections().listen((
      sections,
    ) {
      if (sections.isNotEmpty) {
        liveSections.assignAll(sections);
      }
    });

    _socialLinksSubscription = _portfolioService.streamSocialLinks().listen((
      links,
    ) {
      if (links.isNotEmpty) {
        liveSocialLinks.assignAll(links);
      }
    });

    _projectsSubscription = _portfolioService.streamProjects().listen((
      projects,
    ) {
      if (projects.isNotEmpty) {
        liveProjects.assignAll(projects);
      }
    });
  }

  void selectModule(AdminModule module) {
    selectedModule.value = module;
  }

  AdminModuleItem get activeModule =>
      modules.firstWhere((item) => item.module == selectedModule.value);

  List<AdminMetricItem> get dashboardMetrics {
    final visibleSectionsCount =
        sectionConfigs.where((section) => section.isVisible).length;
    final featuredProjectCount =
        projects.where((project) => project.isFeatured).length;

    return [
      AdminMetricItem(
        label: 'Live Sections',
        value: visibleSectionsCount.toString().padLeft(2, '0'),
        change:
            isFirebaseConnected
                ? 'Synced from Firestore'
                : 'Using local fallback content',
        icon: Icons.visibility_rounded,
        color: AppColors.primaryGreen,
      ),
      AdminMetricItem(
        label: 'Featured Projects',
        value: featuredProjectCount.toString().padLeft(2, '0'),
        change:
            isFirebaseConnected
                ? 'Live Firestore collection'
                : 'Using local fallback projects',
        icon: Icons.folder_special_rounded,
        color: const Color(0xFF5CD6FF),
      ),
      const AdminMetricItem(
        label: 'Published Posts',
        value: '14',
        change: 'Blog CMS wiring started',
        icon: Icons.library_books_rounded,
        color: Color(0xFFFFB44C),
      ),
      const AdminMetricItem(
        label: 'New Leads',
        value: '03',
        change: 'Inbox layout ready for Firestore',
        icon: Icons.campaign_rounded,
        color: Color(0xFFFF7C7C),
      ),
    ];
  }

  List<SiteSectionConfig> get sectionConfigs =>
      liveSections.isNotEmpty
          ? liveSections
          : SiteSectionConfig.defaultSections();

  List<ManagedSocialLink> get socialLinks =>
      liveSocialLinks.isNotEmpty
          ? liveSocialLinks.toList(growable: false)
          : ManagedSocialLink.defaultLinks();

  List<Project> get projects =>
      liveProjects.isNotEmpty
          ? liveProjects.toList(growable: false)
          : Project.defaultPortfolioProjects();

  String get pageTitle => switch (selectedModule.value) {
    AdminModule.dashboard => 'Portfolio Control Center',
    AdminModule.siteStructure => 'Site Structure',
    AdminModule.homeContent => 'Homepage Content',
    AdminModule.projects => 'Project Management',
    AdminModule.skillsExperience => 'Skills & Experience',
    AdminModule.developmentAreas => 'Development Areas',
    AdminModule.achievements => 'Achievements',
    AdminModule.guidingPrinciples => 'Guiding Principles',
    AdminModule.freelanceProcess => 'Freelance Process',
    AdminModule.testimonials => 'Testimonials',
    AdminModule.faq => 'FAQ',
    AdminModule.socialContact => 'Social & Contact',
    AdminModule.blog => 'Blog CMS',
    AdminModule.submissions => 'Visitor Submissions',
    AdminModule.mediaLibrary => 'Media Library',
    AdminModule.settings => 'Settings',
    AdminModule.createPost => 'Create a Post',
    AdminModule.managePages => 'Manage Pages',
    AdminModule.resumeManagement => 'Resume Management',
  };

  String get pageDescription => switch (selectedModule.value) {
    AdminModule.dashboard =>
      'A premium workspace to control what is live on your portfolio and what needs attention next.',
    AdminModule.siteStructure =>
      'Toggle visibility, control order, and audit the sections that shape your homepage.',
    AdminModule.homeContent =>
      'Refine hero messaging, CTA copy, and section intros without touching source code.',
    AdminModule.projects =>
      'Curate featured work, control ordering, and prepare project cards for the public site.',
    AdminModule.skillsExperience =>
      'Manage stack percentages, marquee content, and experience timeline entries.',
    AdminModule.developmentAreas =>
      'Keep the scrolling service and specialisation content aligned with current offerings.',
    AdminModule.achievements =>
      'Publish proof points, results, and milestone-driven credibility markers.',
    AdminModule.guidingPrinciples =>
      'Shape the values and creative principles that sit behind the work.',
    AdminModule.freelanceProcess =>
      'Define how prospects understand the collaboration flow from first message to delivery.',
    AdminModule.testimonials =>
      'Review client feedback, featuring rules, and publication readiness.',
    AdminModule.faq =>
      'Keep common questions accurate, short, and confidence-building.',
    AdminModule.socialContact =>
      'Control every public contact channel from one structured source of truth.',
    AdminModule.blog =>
      'Manage article states, metadata, and publishing readiness.',
    AdminModule.submissions =>
      'Treat inquiries as an inbox with status, notes, and response priority.',
    AdminModule.mediaLibrary =>
      'Prepare reusable imagery, covers, and section assets for later CMS wiring.',
    AdminModule.settings =>
      'Control admin access, notification readiness, and platform-level settings.',
    AdminModule.createPost =>
      'Write rich posts with images, hashtags, and visibility controls. Publish directly to your portfolio feed.',
    AdminModule.managePages =>
      'View and manage every page in your portfolio. Toggle visibility, preview live, and control routing.',
    AdminModule.resumeManagement =>
      'Upload your latest resume, manage versions, and control where it appears across the portfolio.',
  };

  List<AdminCollectionItem> get activeCollections {
    switch (selectedModule.value) {
      case AdminModule.socialContact:
        return socialLinks
            .map(
              (link) => AdminCollectionItem(
                title: link.platform,
                subtitle: link.value,
                state:
                    link.isVisible
                        ? AdminItemState.live
                        : AdminItemState.hidden,
                lastEdited:
                    isFirebaseConnected
                        ? 'Backed by Firestore'
                        : 'Fallback configuration',
                highlight: link.type.toUpperCase(),
              ),
            )
            .toList(growable: false);
      case AdminModule.siteStructure:
      case AdminModule.homeContent:
        return sectionConfigs
            .map(
              (section) => AdminCollectionItem(
                title: section.title,
                subtitle: section.description,
                state:
                    section.isVisible
                        ? AdminItemState.live
                        : AdminItemState.hidden,
                lastEdited: _updatedLabel(section),
                highlight: section.key,
              ),
            )
            .toList(growable: false);
      case AdminModule.projects:
        return projects
            .map(
              (project) => AdminCollectionItem(
                title: project.title,
                subtitle: project.description,
                state:
                    project.isPublished
                        ? AdminItemState.live
                        : AdminItemState.draft,
                lastEdited:
                    isFirebaseConnected
                        ? 'Project collection linked'
                        : 'Local fallback',
                highlight: project.isFeatured ? 'Featured' : project.category,
              ),
            )
            .toList(growable: false);
      default:
        return fallbackCollections;
    }
  }

  Future<void> saveProject(Project project) async {
    final index = liveProjects.indexWhere((item) => item.id == project.id);
    if (index != -1) {
      liveProjects[index] = project;
    } else {
      liveProjects.add(project);
    }
    liveProjects.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    liveProjects.refresh();

    await _portfolioService.saveProject(project);
  }

  Future<void> deleteProject(Project project) async {
    liveProjects.removeWhere((item) => item.id == project.id);
    await _portfolioService.deleteProject(project.id);
  }

  Future<void> toggleProjectFeatured(Project project, bool isFeatured) async {
    await saveProject(project.copyWith(isFeatured: isFeatured));
  }

  Future<void> toggleProjectPublished(Project project, bool isPublished) async {
    await saveProject(project.copyWith(isPublished: isPublished));
  }

  Future<void> updateSectionVisibility(
    SiteSectionConfig section,
    bool isVisible,
  ) async {
    final index = liveSections.indexWhere((item) => item.id == section.id);
    if (index != -1) {
      liveSections[index] = liveSections[index].copyWith(isVisible: isVisible);
      liveSections.refresh();
    }

    await _portfolioService.updateSectionVisibility(section, isVisible);
  }

  String _updatedLabel(SiteSectionConfig section) {
    if (section.updatedAt == null) {
      return isFirebaseConnected ? 'Synced document' : 'Local fallback';
    }

    final now = DateTime.now();
    final difference = now.difference(section.updatedAt!);

    if (difference.inMinutes < 1) {
      return 'Updated just now';
    }

    if (difference.inMinutes < 60) {
      return 'Updated ${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return 'Updated ${difference.inHours} hr ago';
    }

    return 'Updated ${difference.inDays} day ago';
  }

  @override
  void onClose() {
    _sectionsSubscription?.cancel();
    _socialLinksSubscription?.cancel();
    _projectsSubscription?.cancel();
    super.onClose();
  }
}

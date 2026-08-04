import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_colors.dart';
import '../../features/portfolio/models/firebase_content_models.dart';
import '../../features/portfolio/models/portfolio_models.dart';
import '../../features/admin/models/admin_portal_models.dart';
import '../../features/admin/modules/blog/models/admin_blog_post.dart';
import '../../features/admin/modules/projects/models/app_project.dart';
import 'admin_auth_provider.dart';
import 'portfolio_provider.dart';
import 'service_providers.dart';

// ─── State ─────────────────────────────────────────────────────────────────

class AdminPortalState {
  const AdminPortalState({
    this.selectedModule = AdminModule.dashboard,
    this.liveSections = const [],
    this.liveSocialLinks = const [],
    this.liveProjects = const [],
    this.liveSubmissions = const [],
    this.liveBasicDetails,
    this.livePages = const [],
    this.liveResumeConfig,
    this.liveMediaAssets = const [],
    this.selectedSubmission,
    this.firestoreErrorMessage,
    this.firestoreProjectsLoaded = false,
    this.liveAppProjects = const [],
  });

  final AdminModule selectedModule;
  final List<SiteSectionConfig> liveSections;
  final List<ManagedSocialLink> liveSocialLinks;
  final List<Project> liveProjects;
  final List<VisitorSubmission> liveSubmissions;
  final BasicDetails? liveBasicDetails;
  final List<SitePageConfig> livePages;
  final ResumeConfig? liveResumeConfig;
  final List<MediaAssetRecord> liveMediaAssets;
  final VisitorSubmission? selectedSubmission;
  final String? firestoreErrorMessage;
  final bool firestoreProjectsLoaded;
  final List<AppProject> liveAppProjects;

  AdminPortalState copyWith({
    AdminModule? selectedModule,
    List<SiteSectionConfig>? liveSections,
    List<ManagedSocialLink>? liveSocialLinks,
    List<Project>? liveProjects,
    List<VisitorSubmission>? liveSubmissions,
    BasicDetails? Function()? liveBasicDetails,
    List<SitePageConfig>? livePages,
    ResumeConfig? Function()? liveResumeConfig,
    List<MediaAssetRecord>? liveMediaAssets,
    VisitorSubmission? Function()? selectedSubmission,
    String? Function()? firestoreErrorMessage,
    bool? firestoreProjectsLoaded,
    List<AppProject>? liveAppProjects,
  }) {
    return AdminPortalState(
      selectedModule: selectedModule ?? this.selectedModule,
      liveSections: liveSections ?? this.liveSections,
      liveSocialLinks: liveSocialLinks ?? this.liveSocialLinks,
      liveProjects: liveProjects ?? this.liveProjects,
      liveSubmissions: liveSubmissions ?? this.liveSubmissions,
      liveBasicDetails: liveBasicDetails != null ? liveBasicDetails() : this.liveBasicDetails,
      livePages: livePages ?? this.livePages,
      liveResumeConfig: liveResumeConfig != null ? liveResumeConfig() : this.liveResumeConfig,
      liveMediaAssets: liveMediaAssets ?? this.liveMediaAssets,
      selectedSubmission: selectedSubmission != null ? selectedSubmission() : this.selectedSubmission,
      firestoreErrorMessage: firestoreErrorMessage != null ? firestoreErrorMessage() : this.firestoreErrorMessage,
      firestoreProjectsLoaded: firestoreProjectsLoaded ?? this.firestoreProjectsLoaded,
      liveAppProjects: liveAppProjects ?? this.liveAppProjects,
    );
  }
}

// ─── Notifier ───────────────────────────────────────────────────────────────

class AdminPortalNotifier extends Notifier<AdminPortalState> {
  static const modules = <AdminModuleItem>[
    AdminModuleItem(module: AdminModule.dashboard, group: AdminModuleGroup.control, title: 'Dashboard', subtitle: 'Command center', icon: Icons.space_dashboard_rounded),
    AdminModuleItem(module: AdminModule.basicDetails, group: AdminModuleGroup.control, title: 'Basic Details', subtitle: 'Identity & profile links', icon: Icons.person_rounded),
    AdminModuleItem(module: AdminModule.siteStructure, group: AdminModuleGroup.control, title: 'Site Structure', subtitle: 'Visibility and order', icon: Icons.view_sidebar_rounded),
    AdminModuleItem(module: AdminModule.projects, group: AdminModuleGroup.control, title: 'Project Management', subtitle: 'Featured portfolio', icon: Icons.workspaces_rounded),
    AdminModuleItem(module: AdminModule.blog, group: AdminModuleGroup.control, title: 'Blog Management', subtitle: 'Editorial content', icon: Icons.edit_note_rounded),
    AdminModuleItem(module: AdminModule.resumeManagement, group: AdminModuleGroup.control, title: 'Resume Management', subtitle: 'Upload & manage CV', icon: Icons.description_rounded),
    AdminModuleItem(module: AdminModule.settings, group: AdminModuleGroup.control, title: 'Settings', subtitle: 'Auth and config', icon: Icons.settings_rounded),
    AdminModuleItem(module: AdminModule.homeContent, group: AdminModuleGroup.content, title: 'Home Content', subtitle: 'Hero and headlines', icon: Icons.home_work_rounded),
    AdminModuleItem(module: AdminModule.homeStats, group: AdminModuleGroup.content, title: 'Stats Marquee', subtitle: 'Scrolling trust numbers', icon: Icons.bar_chart_rounded),
    AdminModuleItem(module: AdminModule.skillsExperience, group: AdminModuleGroup.content, title: 'Skills & Experience', subtitle: 'Skills and timeline', icon: Icons.stacked_line_chart_rounded),
    AdminModuleItem(module: AdminModule.education, group: AdminModuleGroup.content, title: 'Education', subtitle: 'Formal education timeline', icon: Icons.school_rounded),
    AdminModuleItem(module: AdminModule.experienceStrengths, group: AdminModuleGroup.content, title: 'Experience Strengths', subtitle: 'What I bring cards', icon: Icons.fitness_center_rounded),
    AdminModuleItem(module: AdminModule.developmentAreas, group: AdminModuleGroup.content, title: 'Development Areas', subtitle: 'Scrolling specialities', icon: Icons.apps_rounded),
    AdminModuleItem(module: AdminModule.achievements, group: AdminModuleGroup.content, title: 'Achievements', subtitle: 'Proof and metrics', icon: Icons.workspace_premium_rounded),
    AdminModuleItem(module: AdminModule.guidingPrinciples, group: AdminModuleGroup.content, title: 'Guiding Principles', subtitle: 'Core operating values', icon: Icons.auto_awesome_rounded),
    AdminModuleItem(module: AdminModule.freelanceProcess, group: AdminModuleGroup.content, title: 'Freelance Process', subtitle: 'Client journey', icon: Icons.route_rounded),
    AdminModuleItem(module: AdminModule.testimonials, group: AdminModuleGroup.content, title: 'Testimonials', subtitle: 'Client trust', icon: Icons.record_voice_over_rounded),
    AdminModuleItem(module: AdminModule.faq, group: AdminModuleGroup.content, title: 'FAQ', subtitle: 'Common questions', icon: Icons.quiz_rounded),
    AdminModuleItem(module: AdminModule.socialContact, group: AdminModuleGroup.content, title: 'Social & Contact', subtitle: 'Channels and links', icon: Icons.alternate_email_rounded),
    AdminModuleItem(module: AdminModule.createPost, group: AdminModuleGroup.publishing, title: 'Create Post', subtitle: 'Write & publish content', icon: Icons.add_circle_outline_rounded),
    AdminModuleItem(module: AdminModule.managePages, group: AdminModuleGroup.publishing, title: 'Manage Pages', subtitle: 'All portfolio pages', icon: Icons.web_rounded),
    AdminModuleItem(module: AdminModule.submissions, group: AdminModuleGroup.operations, title: 'Visitor Submissions', subtitle: 'Leads inbox', icon: Icons.inbox_rounded, badgeCount: 3),
    AdminModuleItem(module: AdminModule.mediaLibrary, group: AdminModuleGroup.operations, title: 'Media Library', subtitle: 'Images and assets', icon: Icons.perm_media_rounded),
  ];

  static const fallbackCollections = <AdminCollectionItem>[
    AdminCollectionItem(title: 'Featured Projects', subtitle: 'Curate the most visible work on the homepage.', state: AdminItemState.live, lastEdited: 'Waiting for Firestore content', highlight: 'Collection'),
    AdminCollectionItem(title: 'Testimonials', subtitle: 'Control trust signals, client quotes, and featured reviews.', state: AdminItemState.draft, lastEdited: 'Waiting for Firestore content', highlight: 'Collection'),
    AdminCollectionItem(title: 'Blog Content', subtitle: 'Manage editorial posts, tags, publish states, and covers.', state: AdminItemState.live, lastEdited: 'Waiting for Firestore content', highlight: 'Collection'),
  ];

  static const recentLeads = <AdminLeadItem>[
    AdminLeadItem(name: 'Aarav Studios', company: 'aarav.design', summary: 'Need a Flutter product site and admin dashboard in 3 weeks.', status: 'New', receivedAt: '6 min ago', unread: true),
    AdminLeadItem(name: 'Mira Health', company: 'mirahealth.io', summary: 'Asked for mobile app redesign, Firebase workflow, and support.', status: 'Reviewing', receivedAt: '48 min ago', unread: true),
    AdminLeadItem(name: 'Northbound Labs', company: 'northboundlabs.com', summary: 'Requested portfolio-style case study site with blog migration.', status: 'Replied', receivedAt: '2 hrs ago'),
  ];

  @override
  AdminPortalState build() {
    final portfolioService = ref.read(firebasePortfolioServiceProvider);
    final projectsService = ref.read(supabaseProjectsServiceProvider);

    if (portfolioService.isEnabled) {
      final s1 = portfolioService.streamSiteSections().listen((sections) {
        _clearError();
        if (sections.isNotEmpty) state = state.copyWith(liveSections: sections);
      }, onError: _handleError);

      final s2 = portfolioService.streamSocialLinks().listen((links) {
        _clearError();
        if (links.isNotEmpty) state = state.copyWith(liveSocialLinks: links);
      }, onError: _handleError);

      final s3 = portfolioService.streamProjects().listen((projects) {
        _clearError();
        state = state.copyWith(liveProjects: projects, firestoreProjectsLoaded: true);
      }, onError: _handleError);

      final s4 = portfolioService.streamSubmissions().listen((submissions) {
        _clearError();
        final sel = state.selectedSubmission;
        final updated = sel != null
            ? submissions.firstWhereOrNull((s) => s.id == sel.id)
            : null;
        state = state.copyWith(
          liveSubmissions: submissions,
          selectedSubmission: updated != null ? () => updated : null,
        );
      }, onError: _handleError);

      final s5 = portfolioService.streamBasicDetails().listen((details) {
        _clearError();
        state = state.copyWith(liveBasicDetails: () => details);
      }, onError: _handleError);

      final s6 = portfolioService.streamPageConfigs().listen((pages) {
        _clearError();
        if (pages.isNotEmpty) state = state.copyWith(livePages: pages);
      }, onError: _handleError);

      final s7 = portfolioService.streamResumeConfig().listen((config) {
        _clearError();
        state = state.copyWith(liveResumeConfig: () => config);
      }, onError: _handleError);

      final s8 = portfolioService.streamMediaAssets().listen((assets) {
        _clearError();
        state = state.copyWith(liveMediaAssets: assets);
      }, onError: _handleError);

      portfolioService.ensurePageConfigSeedData();

      ref.onDispose(() {
        s1.cancel(); s2.cancel(); s3.cancel(); s4.cancel();
        s5.cancel(); s6.cancel(); s7.cancel(); s8.cancel();
      });
    }

    _loadAppProjects(projectsService);

    return const AdminPortalState();
  }

  // ─── Computed ──────────────────────────────────────────────────────────────

  bool get isFirebaseConnected =>
      ref.read(firebasePortfolioServiceProvider).isEnabled;

  List<SitePageConfig> get pageConfigs =>
      state.livePages.isNotEmpty ? state.livePages : SitePageConfig.defaultPages();

  List<SiteSectionConfig> get sectionConfigs =>
      state.liveSections.isNotEmpty ? state.liveSections : SiteSectionConfig.defaultSections();

  List<ManagedSocialLink> get socialLinks =>
      state.liveSocialLinks.isNotEmpty
          ? List.unmodifiable(state.liveSocialLinks)
          : ManagedSocialLink.defaultLinks();

  List<Project> get projects =>
      state.firestoreProjectsLoaded
          ? List.unmodifiable(state.liveProjects)
          : Project.defaultPortfolioProjects();

  BasicDetails get basicDetails => state.liveBasicDetails ?? BasicDetails.defaults();

  AdminModuleItem get activeModule =>
      modules.firstWhere((item) => item.module == state.selectedModule);

  List<AdminModuleGroup> get navigationGroups => AdminModuleGroup.values;

  List<AdminModuleItem> modulesForGroup(AdminModuleGroup group) =>
      modules.where((item) => item.group == group).toList(growable: false);

  List<AdminMetricItem> get dashboardMetrics {
    final visiblePagesCount = sectionConfigs.where((s) => s.isVisible).length;
    final featuredProjectCount = projects.where((p) => p.isFeatured).length;
    final newLeadsCount = state.liveSubmissions.isNotEmpty
        ? state.liveSubmissions.where((s) => s.isUnread).length
        : recentLeads.where((l) => l.unread).length;
    return [
      AdminMetricItem(label: 'Live Pages', value: visiblePagesCount.toString().padLeft(2, '0'), change: isFirebaseConnected ? 'Synced from Firestore' : 'Using local fallback content', icon: Icons.visibility_rounded, color: AppColors.primaryGreen),
      AdminMetricItem(label: 'Featured Projects', value: featuredProjectCount.toString().padLeft(2, '0'), change: isFirebaseConnected ? 'Live Firestore collection' : 'Using local fallback projects', icon: Icons.folder_special_rounded, color: const Color(0xFF5CD6FF)),
      const AdminMetricItem(label: 'Published Posts', value: '14', change: 'Blog CMS wiring started', icon: Icons.library_books_rounded, color: Color(0xFFFFB44C)),
      AdminMetricItem(label: 'New Leads', value: newLeadsCount.toString().padLeft(2, '0'), change: state.liveSubmissions.isNotEmpty ? 'Unread submissions in inbox' : 'Using dashboard fallback inbox', icon: Icons.campaign_rounded, color: const Color(0xFFFF7C7C)),
    ];
  }

  List<AdminCollectionItem> get activeCollections {
    switch (state.selectedModule) {
      case AdminModule.socialContact:
        return socialLinks.map((link) => AdminCollectionItem(title: link.platform, subtitle: link.value, state: link.isVisible ? AdminItemState.live : AdminItemState.hidden, lastEdited: isFirebaseConnected ? 'Backed by Firestore' : 'Fallback configuration', highlight: link.type.toUpperCase())).toList(growable: false);
      case AdminModule.siteStructure:
      case AdminModule.homeContent:
        return sectionConfigs.map((section) => AdminCollectionItem(title: section.title, subtitle: section.description, state: section.isVisible ? AdminItemState.live : AdminItemState.hidden, lastEdited: _updatedLabel(section), highlight: section.key)).toList(growable: false);
      case AdminModule.projects:
        return projects.map((project) => AdminCollectionItem(title: project.title, subtitle: project.description, state: project.isPublished ? AdminItemState.live : AdminItemState.draft, lastEdited: isFirebaseConnected ? 'Project collection linked' : 'Local fallback', highlight: project.isFeatured ? 'Featured' : project.category)).toList(growable: false);
      default:
        return fallbackCollections;
    }
  }

  String get pageTitle => switch (state.selectedModule) {
        AdminModule.dashboard => 'Portfolio Control Center',
        AdminModule.basicDetails => 'Basic Details',
        AdminModule.siteStructure => 'Site Structure',
        AdminModule.homeContent => 'Homepage Content',
        AdminModule.homeStats => 'Stats Marquee',
        AdminModule.projects => 'Project Management',
        AdminModule.skillsExperience => 'Skills & Experience',
        AdminModule.education => 'Education',
        AdminModule.experienceStrengths => 'Experience Strengths',
        AdminModule.developmentAreas => 'Development Areas',
        AdminModule.achievements => 'Achievements',
        AdminModule.guidingPrinciples => 'Guiding Principles',
        AdminModule.freelanceProcess => 'Freelance Process',
        AdminModule.testimonials => 'Testimonials',
        AdminModule.faq => 'FAQ',
        AdminModule.socialContact => 'Social & Contact',
        AdminModule.blog => 'Blog Management',
        AdminModule.submissions => 'Visitor Submissions',
        AdminModule.mediaLibrary => 'Media Library',
        AdminModule.settings => 'Settings',
        AdminModule.createPost => 'Create a Post',
        AdminModule.managePages => 'Manage Pages',
        AdminModule.resumeManagement => 'Resume Management',
      };

  String get pageDescription => switch (state.selectedModule) {
        AdminModule.dashboard => 'A premium workspace to control what is live on your portfolio and what needs attention next.',
        AdminModule.basicDetails => 'Your name, designation, and social profile URLs. Update once and every page that uses this data updates automatically.',
        AdminModule.siteStructure => 'Toggle visibility, control order, and audit the sections that shape your homepage.',
        AdminModule.homeContent => 'Refine hero messaging, CTA copy, and section intros without touching source code.',
        AdminModule.homeStats => 'Edit the value/label pairs shown in the scrolling stats strips above and below the fold.',
        AdminModule.projects => 'Curate featured work, control ordering, and prepare project cards for the public site.',
        AdminModule.skillsExperience => 'Manage stack percentages, marquee content, and experience timeline entries.',
        AdminModule.education => 'Manage the formal education and self-learning entries shown on the About page.',
        AdminModule.experienceStrengths => 'Manage the "what I bring" strength cards shown on the Experience page.',
        AdminModule.developmentAreas => 'Keep the scrolling service and specialisation content aligned with current offerings.',
        AdminModule.achievements => 'Publish proof points, results, and milestone-driven credibility markers.',
        AdminModule.guidingPrinciples => 'Shape the values and creative principles that sit behind the work.',
        AdminModule.freelanceProcess => 'Define how prospects understand the collaboration flow from first message to delivery.',
        AdminModule.testimonials => 'Review client feedback, featuring rules, and publication readiness.',
        AdminModule.faq => 'Keep common questions accurate, short, and confidence-building.',
        AdminModule.socialContact => 'Control every public contact channel from one structured source of truth.',
        AdminModule.blog => 'Manage article states, metadata, and publishing readiness.',
        AdminModule.submissions => 'Treat inquiries as an inbox with status, notes, and response priority.',
        AdminModule.mediaLibrary => 'Prepare reusable imagery, covers, and section assets for later CMS wiring.',
        AdminModule.settings => 'Control admin access, notification readiness, and platform-level settings.',
        AdminModule.createPost => 'Write rich posts with images, hashtags, and visibility controls. Publish directly to your portfolio feed.',
        AdminModule.managePages => 'View and manage every page in your portfolio. Toggle visibility, preview live, and control routing.',
        AdminModule.resumeManagement => 'Upload your latest resume, manage versions, and control where it appears across the portfolio.',
      };

  // ─── Actions ────────────────────────────────────────────────────────────────

  void selectModule(AdminModule module) =>
      state = state.copyWith(selectedModule: module);

  void selectSubmission(VisitorSubmission submission) =>
      state = state.copyWith(selectedSubmission: () => submission);

  Future<void> markSubmissionInProgress() async {
    final sub = state.selectedSubmission;
    if (sub == null) return;
    try {
      await ref.read(firebasePortfolioServiceProvider).updateSubmissionStatus(sub.id, SubmissionStatus.inProgress);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> addSubmissionNote(String note) async {
    final sub = state.selectedSubmission;
    if (sub == null) return;
    try {
      await ref.read(firebasePortfolioServiceProvider).addSubmissionNote(sub.id, note);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> reseedFirestore() async {
    final authState = ref.read(adminAuthProvider);
    final email = authState.currentUser?.email ?? '';
    try {
      await ref.read(firebasePortfolioServiceProvider).ensureSeedData(ownerEmail: email);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveSocialLink(ManagedSocialLink link) async {
    final links = [...state.liveSocialLinks];
    final i = links.indexWhere((l) => l.id == link.id);
    if (i != -1) { links[i] = link; } else { links.add(link); }
    links.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    state = state.copyWith(liveSocialLinks: links);
    try {
      await ref.read(firebasePortfolioServiceProvider).saveSocialLink(link);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteSocialLink(ManagedSocialLink link) async {
    state = state.copyWith(liveSocialLinks: state.liveSocialLinks.where((l) => l.id != link.id).toList());
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteSocialLink(link.id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveProject(Project project) async {
    final projects = [...state.liveProjects];
    final i = projects.indexWhere((p) => p.id == project.id);
    if (i != -1) { projects[i] = project; } else { projects.add(project); }
    projects.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    state = state.copyWith(liveProjects: projects);
    try {
      await ref.read(firebasePortfolioServiceProvider).saveProject(project);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteProject(Project project) async {
    state = state.copyWith(liveProjects: state.liveProjects.where((p) => p.id != project.id).toList());
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteProject(project.id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> toggleProjectFeatured(Project project, bool value) =>
      saveProject(project.copyWith(isFeatured: value));

  Future<void> toggleProjectPublished(Project project, bool value) =>
      saveProject(project.copyWith(isPublished: value));

  Future<bool> saveBasicDetails(BasicDetails details) async {
    state = state.copyWith(liveBasicDetails: () => details);
    try {
      await ref.read(firebasePortfolioServiceProvider).saveBasicDetails(details);
      _clearError();
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<bool> saveResumeConfig(ResumeConfig config) async {
    state = state.copyWith(liveResumeConfig: () => config);
    try {
      await ref.read(firebasePortfolioServiceProvider).saveResumeConfig(config);
      _clearError();
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<void> saveMediaAsset(MediaAssetRecord asset) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveMediaAsset(asset);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteMediaAsset(MediaAssetRecord asset) async {
    state = state.copyWith(liveMediaAssets: state.liveMediaAssets.where((a) => a.id != asset.id).toList());
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteMediaAsset(asset.id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<bool> saveAppProject(AppProject project) async {
    try {
      final saved = await ref.read(supabaseProjectsServiceProvider).saveProject(project);
      if (saved == null) return false;
      final list = [...state.liveAppProjects];
      final i = list.indexWhere((p) => p.id == saved.id);
      if (i != -1) { list[i] = saved; } else { list.add(saved); }
      list.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      state = state.copyWith(liveAppProjects: list);
      // Admin's `liveAppProjects` and the public site's `portfolioProvider`
      // used to be two disconnected copies of the same Supabase table — the
      // public site only fetched once at app startup, so edits/toggles here
      // never reached the homepage featured section or the Projects page
      // within the same session (Day 8 spot-check finding). Refresh it too.
      await ref.read(portfolioProvider.notifier).refreshAppProjects();
      return true;
    } catch (_) { return false; }
  }

  Future<bool> deleteAppProject(AppProject project) async {
    try {
      final ok = await ref.read(supabaseProjectsServiceProvider).deleteProject(project.id);
      if (ok) {
        state = state.copyWith(liveAppProjects: state.liveAppProjects.where((p) => p.id != project.id).toList());
        await ref.read(portfolioProvider.notifier).refreshAppProjects();
      }
      return ok;
    } catch (_) { return false; }
  }

  Future<void> toggleAppProjectFeatured(AppProject project, bool value) =>
      saveAppProject(project.copyWith(isFeatured: value));

  Future<void> toggleAppProjectPublished(AppProject project, bool value) =>
      saveAppProject(project.copyWith(isPublished: value));

  Future<void> updateSectionVisibility(SiteSectionConfig section, bool isVisible) async {
    final sections = [...state.liveSections];
    final i = sections.indexWhere((s) => s.id == section.id);
    if (i != -1) sections[i] = sections[i].copyWith(isVisible: isVisible);
    state = state.copyWith(liveSections: sections);
    try {
      await ref.read(firebasePortfolioServiceProvider).updateSectionVisibility(section, isVisible);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> updatePageVisibility(SitePageConfig page, bool isVisible) async {
    final pages = [...state.livePages];
    final i = pages.indexWhere((p) => p.id == page.id);
    if (i != -1) pages[i] = pages[i].copyWith(isVisible: isVisible);
    state = state.copyWith(livePages: pages);
    try {
      await ref.read(firebasePortfolioServiceProvider).updatePageVisibility(page, isVisible);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> _loadAppProjects(dynamic projectsService) async {
    final list = await projectsService.fetchProjects();
    state = state.copyWith(liveAppProjects: list);
  }

  // ─── Generic content-list writes ─────────────────────────────────────────
  //
  // These collections are read by admin workspaces straight off
  // `portfolioProvider` (it already streams every one of them for the public
  // site), so there's no separate `liveX` mirror to keep in sync here — just
  // the write path, with the same error handling as everything else above.

  Future<void> saveHomeHero(HomeHeroContent content) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveHomeHero(content);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveSkill(SkillItem item) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveSkill(item);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteSkill(String id) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteSkill(id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveEducation(EducationItem item) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveEducation(item);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteEducation(String id) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteEducation(id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveExperience(Experience item) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveExperience(item);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteExperience(String id) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteExperience(id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveExperienceStrength(ExperienceStrengthItem item) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveExperienceStrength(item);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteExperienceStrength(String id) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteExperienceStrength(id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveAchievement(AchievementItem item) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveAchievement(item);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteAchievement(String id) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteAchievement(id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveProcessStep(ProcessStepItem item) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveProcessStep(item);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteProcessStep(String id) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteProcessStep(id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveTestimonial(TestimonialItem item) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveTestimonial(item);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteTestimonial(String id) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteTestimonial(id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveFaqItem(FaqItem item) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveFaqItem(item);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteFaqItem(String id) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteFaqItem(id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveDevArea(DevAreaItem item) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveDevArea(item);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteDevArea(String id) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteDevArea(id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveStat(StatItem item) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveStat(item);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteStat(String id) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteStat(id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> saveResumeHighlight(ResumeHighlightGroup item) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveResumeHighlight(item);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  Future<void> deleteResumeHighlight(String id) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).deleteResumeHighlight(id);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  // Blog posts are Supabase-backed (Day 9), not Firestore — same reasoning
  // and same shape as `saveAppProject`/`deleteAppProject` below: cover
  // images need real file storage, which Firestore/Spark doesn't have.
  Future<bool> saveBlogPost(AdminBlogPost post) async {
    try {
      final saved = await ref.read(supabaseBlogServiceProvider).savePost(post);
      if (saved == null) return false;
      await ref.read(portfolioProvider.notifier).refreshAdminBlogPosts();
      _clearError();
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<bool> deleteBlogPost(String id) async {
    try {
      final ok = await ref.read(supabaseBlogServiceProvider).deletePost(id);
      if (ok) {
        await ref.read(portfolioProvider.notifier).refreshAdminBlogPosts();
      }
      _clearError();
      return ok;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<void> saveBlogSettings(BlogSettings settings) async {
    try {
      await ref.read(firebasePortfolioServiceProvider).saveBlogSettings(settings);
      _clearError();
    } catch (e) { _handleError(e); }
  }

  void _clearError() {
    if (state.firestoreErrorMessage != null) {
      state = state.copyWith(firestoreErrorMessage: () => null);
    }
  }

  void _handleError(Object error) {
    if (error is FirebaseException && error.code == 'permission-denied') {
      state = state.copyWith(
        firestoreErrorMessage: () =>
            'Firestore access is currently blocked by security rules. '
            'The admin portal is running with fallback data until read/write access is granted.',
      );
      return;
    }
    state = state.copyWith(firestoreErrorMessage: () => 'Admin data sync failed: $error');
  }

  String _updatedLabel(SiteSectionConfig section) {
    if (section.updatedAt == null) return isFirebaseConnected ? 'Synced document' : 'Local fallback';
    final diff = DateTime.now().difference(section.updatedAt!);
    if (diff.inMinutes < 1) return 'Updated just now';
    if (diff.inMinutes < 60) return 'Updated ${diff.inMinutes} min ago';
    if (diff.inHours < 24) return 'Updated ${diff.inHours} hr ago';
    return 'Updated ${diff.inDays} day ago';
  }
}

final adminPortalProvider = NotifierProvider<AdminPortalNotifier, AdminPortalState>(
  AdminPortalNotifier.new,
);

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/admin/modules/projects/models/app_project.dart';
import '../features/portfolio/models/firebase_content_models.dart';
import '../features/portfolio/models/portfolio_models.dart';
import '../services/devto_service.dart';
import '../services/github_service.dart';
import 'service_providers.dart';

// ─── State ─────────────────────────────────────────────────────────────────

class PortfolioState {
  const PortfolioState({
    this.appProjects = const [],
    this.resumeConfig,
    this.isAvailableForWork = true,
    this.isLoadingProjects = false,
    this.isLoadingBlog = false,
    this.githubStats,
    this.sectionVisibility = const {},
    this.pageVisibility = const {},
    required this.personalInfo,
    required this.experiences,
    required this.projects,
    required this.blogPosts,
    this.currentPageIndex = 0,
  });

  final List<AppProject> appProjects;
  final ResumeConfig? resumeConfig;
  final bool isAvailableForWork;
  final bool isLoadingProjects;
  final bool isLoadingBlog;
  final GitHubStats? githubStats;
  final Map<String, bool> sectionVisibility;
  final Map<String, bool> pageVisibility;
  final PersonalInfo personalInfo;
  final List<Experience> experiences;
  final List<Project> projects;
  final List<BlogPost> blogPosts;
  final int currentPageIndex;

  // ─── Computed ──────────────────────────────────────────────────────────────

  List<AppProject> get publishedAppProjects =>
      appProjects.where((p) => p.isPublished).toList();

  List<AppProject> get featuredAppProjects =>
      publishedAppProjects.where((p) => p.isFeatured).toList();

  List<Project> get publishedProjects =>
      (projects.where((p) => p.isPublished).toList()
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)));

  List<Project> get featuredProjects =>
      (publishedProjects.where((p) => p.isFeatured).toList()
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)));

  bool isSectionVisible(String key, {bool fallback = true}) =>
      sectionVisibility[key] ?? fallback;

  bool isPageVisible(String key) => pageVisibility[key] ?? true;

  List<Project> getProjectsByCategory(String category) =>
      publishedProjects.where((p) => p.category == category).toList();

  List<BlogPost> getBlogPostsByTag(String tag) =>
      blogPosts.where((p) => p.tags.contains(tag)).toList();

  SocialLink? getSocialLink(String platform) => personalInfo.socialLinks
      .where((s) => s.platform.toLowerCase() == platform.toLowerCase())
      .firstOrNull;

  PortfolioState copyWith({
    List<AppProject>? appProjects,
    ResumeConfig? Function()? resumeConfig,
    bool? isAvailableForWork,
    bool? isLoadingProjects,
    bool? isLoadingBlog,
    GitHubStats? Function()? githubStats,
    Map<String, bool>? sectionVisibility,
    Map<String, bool>? pageVisibility,
    PersonalInfo? personalInfo,
    List<Experience>? experiences,
    List<Project>? projects,
    List<BlogPost>? blogPosts,
    int? currentPageIndex,
  }) {
    return PortfolioState(
      appProjects: appProjects ?? this.appProjects,
      resumeConfig: resumeConfig != null ? resumeConfig() : this.resumeConfig,
      isAvailableForWork: isAvailableForWork ?? this.isAvailableForWork,
      isLoadingProjects: isLoadingProjects ?? this.isLoadingProjects,
      isLoadingBlog: isLoadingBlog ?? this.isLoadingBlog,
      githubStats: githubStats != null ? githubStats() : this.githubStats,
      sectionVisibility: sectionVisibility ?? this.sectionVisibility,
      pageVisibility: pageVisibility ?? this.pageVisibility,
      personalInfo: personalInfo ?? this.personalInfo,
      experiences: experiences ?? this.experiences,
      projects: projects ?? this.projects,
      blogPosts: blogPosts ?? this.blogPosts,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }

  static PortfolioState initial() => PortfolioState(
        personalInfo: PersonalInfo(
          name: 'Gokul K S',
          title: 'Mobile App Designer & Flutter Developer',
          email: 'gokulofficialcommunication@gmail.com',
          location: 'India',
          bio:
              "I'm dedicated to crafting apps that bring your ideas to life, combining design and development to deliver fast, impactful results.",
          profileImageUrl: 'https://avatars.githubusercontent.com/u/gokulks',
          socialLinks: [
            SocialLink(platform: 'LinkedIn', url: 'https://linkedin.com/in/gokul-k-s', icon: 'linkedin'),
            SocialLink(platform: 'GitHub', url: 'https://github.com/${GitHubService.username}', icon: 'github'),
            SocialLink(platform: 'Medium', url: 'https://medium.com/@gokulks', icon: 'medium'),
            SocialLink(platform: 'Instagram', url: 'https://instagram.com/gokulks', icon: 'instagram'),
            SocialLink(platform: 'Facebook', url: 'https://facebook.com/gokulks', icon: 'facebook'),
          ],
        ),
        experiences: [
          Experience(
            company: 'Sowedane IT Solutions Pvt.',
            position: 'Flutter Developer',
            duration: 'Oct 2022 – Oct 2025',
            description:
                'Collaborated with cross-functional teams to deliver user-focused designs using Figma, increasing app engagement by 30%. Integrated Firebase services for real-time data syncing, push notifications, and analytics. Delivered multiple projects on time, maintaining high client satisfaction rates.',
            technologies: ['Flutter', 'Dart', 'Firebase', 'Figma', 'GetX', 'Bloc', 'REST APIs'],
          ),
          Experience(
            company: 'Brototype – Kochi',
            position: 'Flutter Developer Intern',
            duration: 'Oct 2021 – Oct 2022',
            description:
                'Transformed Figma prototypes into functional, visually appealing UIs. Spearheaded Google Maps integration for precise location tracking. Implemented GetX state management to streamline app navigation and reduce complexity.',
            technologies: ['Flutter', 'Dart', 'GetX', 'Google Maps', 'Figma', 'Firebase'],
          ),
        ],
        projects: Project.defaultPortfolioProjects(),
        blogPosts: _defaultBlogPosts,
      );

  static const List<BlogPost> _defaultBlogPosts = [];
}

// ─── Notifier ───────────────────────────────────────────────────────────────

class PortfolioNotifier extends Notifier<PortfolioState> {
  bool _hasFirestoreProjects = false;
  bool _hasBasicDetails = false;

  @override
  PortfolioState build() {
    final firebaseService = ref.read(firebasePortfolioServiceProvider);
    final projectsService = ref.read(supabaseProjectsServiceProvider);

    if (firebaseService.isEnabled) {
      final s1 = firebaseService.streamSiteSections().listen((sections) {
        if (sections.isEmpty) return;
        state = state.copyWith(
          sectionVisibility: {for (final s in sections) s.key: s.isVisible},
        );
      });

      final s2 = firebaseService.streamSocialLinks().listen((links) {
        if (links.isEmpty) return;
        _applyManagedSocialLinks(links);
      });

      final s3 = firebaseService.streamProjects().listen((liveProjects) {
        if (liveProjects.isEmpty) return;
        _hasFirestoreProjects = true;
        state = state.copyWith(
          projects: liveProjects
            ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
        );
      });

      final s4 = firebaseService.streamBasicDetails().listen((details) {
        if (details == null) return;
        _applyBasicDetails(details);
      });

      final s5 = firebaseService.streamPageConfigs().listen((pages) {
        if (pages.isEmpty) return;
        state = state.copyWith(
          pageVisibility: {for (final p in pages) p.key: p.isVisible},
        );
      });

      final s6 = firebaseService.streamResumeConfig().listen((config) {
        state = state.copyWith(resumeConfig: () => config);
      });

      ref.onDispose(() {
        s1.cancel();
        s2.cancel();
        s3.cancel();
        s4.cancel();
        s5.cancel();
        s6.cancel();
      });
    }

    _fetchGitHubData();
    _fetchBlogPosts();
    _loadAppProjects(projectsService);

    return PortfolioState.initial();
  }

  // ─── Firebase stream helpers ─────────────────────────────────────────────

  void _applyBasicDetails(BasicDetails details) {
    _hasBasicDetails = true;
    final current = state.personalInfo;
    final socialLinks = <SocialLink>[
      if (details.linkedinUrl.isNotEmpty) SocialLink(platform: 'LinkedIn', url: details.linkedinUrl, icon: 'linkedin'),
      if (details.twitterUrl.isNotEmpty) SocialLink(platform: 'Twitter', url: details.twitterUrl, icon: 'twitter'),
      if (details.githubUrl.isNotEmpty) SocialLink(platform: 'GitHub', url: details.githubUrl, icon: 'github'),
      if (details.mediumUrl.isNotEmpty) SocialLink(platform: 'Medium', url: details.mediumUrl, icon: 'medium'),
      if (details.instagramUrl.isNotEmpty) SocialLink(platform: 'Instagram', url: details.instagramUrl, icon: 'instagram'),
    ];
    state = state.copyWith(
      personalInfo: PersonalInfo(
        name: details.name.isNotEmpty ? details.name : current.name,
        title: details.designation.isNotEmpty ? details.designation : current.title,
        email: details.email.isNotEmpty ? details.email : current.email,
        location: current.location,
        bio: current.bio,
        profileImageUrl: current.profileImageUrl,
        socialLinks: socialLinks.isNotEmpty ? socialLinks : current.socialLinks,
      ),
    );
  }

  void _applyManagedSocialLinks(List<ManagedSocialLink> links) {
    if (_hasBasicDetails) return;
    final current = state.personalInfo;
    final visible = (links.where((l) => l.isVisible).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)));
    final emailLink = visible.firstWhereOrNull((l) => l.type == 'email');
    final socialLinks = visible
        .where((l) => l.type != 'email')
        .map((l) => SocialLink(platform: l.platform, url: l.value, icon: l.platform.toLowerCase()))
        .toList(growable: false);
    state = state.copyWith(
      personalInfo: PersonalInfo(
        name: current.name,
        title: current.title,
        email: emailLink?.value ?? current.email,
        location: current.location,
        bio: current.bio,
        profileImageUrl: current.profileImageUrl,
        socialLinks: socialLinks.isEmpty ? current.socialLinks : socialLinks,
      ),
    );
  }

  // ─── Async fetches ───────────────────────────────────────────────────────

  Future<void> _fetchGitHubData() async {
    state = state.copyWith(isLoadingProjects: true);
    try {
      final results = await Future.wait([
        GitHubService.fetchRepositories(),
        GitHubService.fetchUserStats(),
      ]);
      if (!_hasFirestoreProjects && (results[0] as List<Project>).isNotEmpty) {
        state = state.copyWith(projects: results[0] as List<Project>);
      }
      state = state.copyWith(githubStats: () => results[1] as GitHubStats?);
    } catch (_) {}
    state = state.copyWith(isLoadingProjects: false);
  }

  Future<void> _fetchBlogPosts() async {
    state = state.copyWith(isLoadingBlog: true);
    try {
      final posts = await DevToService.fetchArticles();
      if (posts.isNotEmpty) state = state.copyWith(blogPosts: posts);
    } catch (_) {}
    state = state.copyWith(isLoadingBlog: false);
  }

  Future<void> _loadAppProjects(dynamic projectsService) async {
    final list = await projectsService.fetchProjects();
    state = state.copyWith(appProjects: list);
  }

  // ─── Public actions ──────────────────────────────────────────────────────

  void changePage(int index) => state = state.copyWith(currentPageIndex: index);

  void toggleAvailability() =>
      state = state.copyWith(isAvailableForWork: !state.isAvailableForWork);

  Future<void> refreshProjects() => _fetchGitHubData();
  Future<void> refreshBlog() => _fetchBlogPosts();

  Future<void> launchEmail({String? subject, String? body}) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: state.personalInfo.email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );
    if (await canLaunchUrl(emailUri)) await launchUrl(emailUri);
  }

  Future<void> launchUrlFromString(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> launchSocialLink(String url) => launchUrlFromString(url);

  Future<void> launchResume() async {
    final url = state.resumeConfig?.activeUrl;
    if (url == null || url.isEmpty) return;
    await launchUrlFromString(url);
  }
}

final portfolioProvider = NotifierProvider<PortfolioNotifier, PortfolioState>(
  PortfolioNotifier.new,
);

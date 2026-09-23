import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/admin/modules/blog/models/admin_blog_post.dart';
import '../../features/admin/modules/projects/models/app_project.dart';
import '../../features/portfolio/models/firebase_content_models.dart';
import '../../features/portfolio/models/portfolio_models.dart';
import '../../features/portfolio/models/testimonial_entry.dart';
import '../services/github_service.dart';
import 'service_providers.dart';

// ─── State ─────────────────────────────────────────────────────────────────

class PortfolioState {
  const PortfolioState({
    this.appProjects = const [],
    this.resumeConfig,
    this.isAvailableForWork = true,
    this.githubStats,
    this.sectionVisibility = const {},
    this.pageVisibility = const {},
    required this.personalInfo,
    required this.experiences,
    this.currentPageIndex = 0,
    this.heroTagline = '',
    this.ctaPrimaryLabel = 'See what I can do',
    required this.skills,
    required this.education,
    required this.experienceStrengths,
    required this.achievements,
    required this.processSteps,
    this.testimonials = const [],
    required this.faqItems,
    required this.devAreas,
    required this.stats,
    required this.resumeHighlights,
    this.adminBlogPosts = const [],
  });

  final List<AppProject> appProjects;
  final ResumeConfig? resumeConfig;
  final bool isAvailableForWork;
  final GitHubStats? githubStats;
  final Map<String, bool> sectionVisibility;
  final Map<String, bool> pageVisibility;
  final PersonalInfo personalInfo;
  final List<Experience> experiences;
  final int currentPageIndex;
  final String heroTagline;
  final String ctaPrimaryLabel;
  final List<SkillItem> skills;
  final List<EducationItem> education;
  final List<ExperienceStrengthItem> experienceStrengths;
  final List<AchievementItem> achievements;
  final List<ProcessStepItem> processSteps;
  final List<TestimonialEntry> testimonials;
  final List<FaqItem> faqItems;
  final List<DevAreaItem> devAreas;
  final List<StatItem> stats;
  final List<ResumeHighlightGroup> resumeHighlights;
  final List<AdminBlogPost> adminBlogPosts;

  // ─── Computed ──────────────────────────────────────────────────────────────

  List<AppProject> get publishedAppProjects =>
      appProjects.where((p) => p.isPublished).toList();

  List<AppProject> get featuredAppProjects =>
      publishedAppProjects.where((p) => p.isFeatured).toList();

  bool isSectionVisible(String key, {bool fallback = true}) =>
      sectionVisibility[key] ?? fallback;

  bool isPageVisible(String key) => pageVisibility[key] ?? true;


  SocialLink? getSocialLink(String platform) => personalInfo.socialLinks
      .where((s) => s.platform.toLowerCase() == platform.toLowerCase())
      .firstOrNull;

  List<Experience> get visibleExperiences =>
      experiences.where((e) => e.isVisible).toList();

  List<SkillItem> get visibleSkills =>
      skills.where((s) => s.isVisible).toList();

  List<EducationItem> get visibleEducation =>
      education.where((e) => e.isVisible).toList();

  List<ExperienceStrengthItem> get visibleExperienceStrengths =>
      experienceStrengths.where((e) => e.isVisible).toList();

  List<AchievementItem> get visibleAchievements =>
      achievements.where((a) => a.isVisible).toList();

  List<ProcessStepItem> get visibleProcessSteps =>
      processSteps.where((p) => p.isVisible).toList();

  List<TestimonialEntry> get visibleTestimonials =>
      testimonials.where((t) => t.isVisible).toList();

  List<FaqItem> get visibleFaqItems => faqItems.where((f) => f.isVisible).toList();

  List<DevAreaItem> get visibleDevAreas =>
      devAreas.where((d) => d.isVisible).toList();

  List<StatItem> get visibleStats => stats.where((s) => s.isVisible).toList();

  List<ResumeHighlightGroup> get visibleResumeHighlights =>
      resumeHighlights.where((r) => r.isVisible).toList();

  List<AdminBlogPost> get publishedAdminBlogPosts =>
      adminBlogPosts.where((p) => p.isPublished).toList();

  /// Public blog feed: the published Supabase-authored posts, newest first.
  /// Converts `AdminBlogPost` into the `BlogPost` shape the blog page widgets
  /// (`BlogHeroSection`, `BlogFeaturedSection`, `BlogPostsSection`) render.
  List<BlogPost> get publicBlogPosts {
    return publishedAdminBlogPosts.map(
      (p) => BlogPost(
        id: p.id,
        title: p.title,
        excerpt: p.excerpt,
        content: p.content,
        imageUrl: p.coverImageUrl,
        publishDate: p.createdAt,
        author: p.authorName.isNotEmpty ? p.authorName : personalInfo.name,
        tags: p.tags,
        readingTimeMinutes: p.readingTimeMinutes,
        isFeatured: p.isFeatured,
      ),
    ).toList()
      ..sort((a, b) => b.publishDate.compareTo(a.publishDate));
  }

  PortfolioState copyWith({
    List<AppProject>? appProjects,
    ResumeConfig? Function()? resumeConfig,
    bool? isAvailableForWork,
    GitHubStats? Function()? githubStats,
    Map<String, bool>? sectionVisibility,
    Map<String, bool>? pageVisibility,
    PersonalInfo? personalInfo,
    List<Experience>? experiences,
    int? currentPageIndex,
    String? heroTagline,
    String? ctaPrimaryLabel,
    List<SkillItem>? skills,
    List<EducationItem>? education,
    List<ExperienceStrengthItem>? experienceStrengths,
    List<AchievementItem>? achievements,
    List<ProcessStepItem>? processSteps,
    List<TestimonialEntry>? testimonials,
    List<FaqItem>? faqItems,
    List<DevAreaItem>? devAreas,
    List<StatItem>? stats,
    List<ResumeHighlightGroup>? resumeHighlights,
    List<AdminBlogPost>? adminBlogPosts,
  }) {
    return PortfolioState(
      appProjects: appProjects ?? this.appProjects,
      resumeConfig: resumeConfig != null ? resumeConfig() : this.resumeConfig,
      isAvailableForWork: isAvailableForWork ?? this.isAvailableForWork,
      githubStats: githubStats != null ? githubStats() : this.githubStats,
      sectionVisibility: sectionVisibility ?? this.sectionVisibility,
      pageVisibility: pageVisibility ?? this.pageVisibility,
      personalInfo: personalInfo ?? this.personalInfo,
      experiences: experiences ?? this.experiences,
      heroTagline: heroTagline ?? this.heroTagline,
      ctaPrimaryLabel: ctaPrimaryLabel ?? this.ctaPrimaryLabel,
      skills: skills ?? this.skills,
      education: education ?? this.education,
      experienceStrengths: experienceStrengths ?? this.experienceStrengths,
      achievements: achievements ?? this.achievements,
      processSteps: processSteps ?? this.processSteps,
      testimonials: testimonials ?? this.testimonials,
      faqItems: faqItems ?? this.faqItems,
      devAreas: devAreas ?? this.devAreas,
      stats: stats ?? this.stats,
      resumeHighlights: resumeHighlights ?? this.resumeHighlights,
      adminBlogPosts: adminBlogPosts ?? this.adminBlogPosts,
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
          ],
        ),
        experiences: Experience.defaults(),
        heroTagline: HomeHeroContent.defaults().tagline,
        ctaPrimaryLabel: HomeHeroContent.defaults().ctaPrimaryLabel,
        skills: SkillItem.defaults(),
        education: EducationItem.defaults(),
        experienceStrengths: ExperienceStrengthItem.defaults(),
        achievements: AchievementItem.defaults(),
        processSteps: ProcessStepItem.defaults(),
        faqItems: FaqItem.defaults(),
        devAreas: DevAreaItem.defaults(),
        stats: StatItem.defaults(),
        resumeHighlights: ResumeHighlightGroup.defaults(),
      );

}

// ─── Notifier ───────────────────────────────────────────────────────────────

class PortfolioNotifier extends Notifier<PortfolioState> {
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

      final s7 = firebaseService.streamHomeHero().listen((hero) {
        if (hero == null) return;
        state = state.copyWith(
          heroTagline: hero.tagline,
          ctaPrimaryLabel: hero.ctaPrimaryLabel,
          isAvailableForWork: hero.isAvailableForWork,
        );
      });

      final s8 = firebaseService.streamExperience().listen((list) {
        if (list.isEmpty) return;
        state = state.copyWith(
          experiences: list..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
        );
      });

      final s9 = firebaseService.streamSkills().listen((list) {
        if (list.isEmpty) return;
        state = state.copyWith(
          skills: list..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
        );
      });

      final s10 = firebaseService.streamEducation().listen((list) {
        if (list.isEmpty) return;
        state = state.copyWith(
          education: list..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
        );
      });

      final s11 = firebaseService.streamExperienceStrengths().listen((list) {
        if (list.isEmpty) return;
        state = state.copyWith(
          experienceStrengths: list..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
        );
      });

      final s12 = firebaseService.streamAchievements().listen((list) {
        if (list.isEmpty) return;
        state = state.copyWith(
          achievements: list..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
        );
      });

      final s13 = firebaseService.streamProcessSteps().listen((list) {
        if (list.isEmpty) return;
        state = state.copyWith(
          processSteps: list..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
        );
      });

      final s15 = firebaseService.streamFaq().listen((list) {
        if (list.isEmpty) return;
        state = state.copyWith(
          faqItems: list..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
        );
      });

      final s16 = firebaseService.streamDevAreas().listen((list) {
        if (list.isEmpty) return;
        state = state.copyWith(
          devAreas: list..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
        );
      });

      final s17 = firebaseService.streamStats().listen((list) {
        if (list.isEmpty) return;
        state = state.copyWith(
          stats: list..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
        );
      });

      final s18 = firebaseService.streamResumeHighlights().listen((list) {
        if (list.isEmpty) return;
        state = state.copyWith(
          resumeHighlights: list..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
        );
      });

      ref.onDispose(() {
        for (final s in [s1, s2, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s15, s16, s17, s18]) {
          s.cancel();
        }
      });
    }

    Future.microtask(() {
      _fetchGitHubData();
      _loadAppProjects(projectsService);
      _loadAdminBlogPosts(ref.read(supabaseBlogServiceProvider));
      _loadTestimonials(ref.read(supabaseTestimonialsServiceProvider));
    });

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
    ];
    state = state.copyWith(
      personalInfo: PersonalInfo(
        name: details.name.isNotEmpty ? details.name : current.name,
        title: details.designation.isNotEmpty ? details.designation : current.title,
        email: details.email.isNotEmpty ? details.email : current.email,
        location: details.location.isNotEmpty ? details.location : current.location,
        bio: details.bio.isNotEmpty ? details.bio : current.bio,
        profileImageUrl: current.profileImageUrl,
        socialLinks: socialLinks.isNotEmpty ? socialLinks : current.socialLinks,
      ),
    );
  }

  // Platforms we no longer want surfaced anywhere on the portfolio, even if
  // a stale entry still exists in Firestore's managed social links.
  static const _hiddenPlatforms = {'facebook', 'instagram'};

  void _applyManagedSocialLinks(List<ManagedSocialLink> links) {
    if (_hasBasicDetails) return;
    final current = state.personalInfo;
    final visible = (links.where((l) => l.isVisible).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)));
    final emailLink = visible.firstWhereOrNull((l) => l.type == 'email');
    final socialLinks = visible
        .where((l) => l.type != 'email')
        .where((l) => !_hiddenPlatforms.contains(l.platform.toLowerCase()))
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
    try {
      final stats = await GitHubService.fetchUserStats();
      state = state.copyWith(githubStats: () => stats);
    } catch (_) {}
  }

  Future<void> _loadAppProjects(dynamic projectsService) async {
    final list = await projectsService.fetchProjects();
    state = state.copyWith(appProjects: list);
  }

  Future<void> _loadAdminBlogPosts(dynamic blogService) async {
    final list = await blogService.fetchPosts();
    state = state.copyWith(adminBlogPosts: list);
  }

  Future<void> _loadTestimonials(dynamic testimonialsService) async {
    final list = await testimonialsService.fetchAll();
    state = state.copyWith(testimonials: list);
  }

  // ─── Public actions ──────────────────────────────────────────────────────

  void changePage(int index) => state = state.copyWith(currentPageIndex: index);

  void toggleAvailability() =>
      state = state.copyWith(isAvailableForWork: !state.isAvailableForWork);

  Future<void> refreshProjects() => _fetchGitHubData();

  /// Re-fetches Supabase-backed `AppProject`s so the public site (home
  /// featured section + full Projects page) picks up admin edits without a
  /// full page reload. `_loadAppProjects` only ran once at app startup
  /// before this — admin saves/deletes/toggles had no way to reach the
  /// public-facing `portfolioProvider` state (Day 8 spot-check finding).
  Future<void> refreshAppProjects() =>
      _loadAppProjects(ref.read(supabaseProjectsServiceProvider));

  /// Same reasoning as `refreshAppProjects()` (Day 8 finding): admin blog
  /// saves/deletes need to push a fresh fetch into this public-facing state,
  /// or the Blog page stays stale until a hard reload.
  Future<void> refreshAdminBlogPosts() =>
      _loadAdminBlogPosts(ref.read(supabaseBlogServiceProvider));

  /// Re-fetches testimonials (all statuses) after a public submission or an
  /// admin approve/hide/edit/delete, so both the moderation list and the
  /// public `visibleTestimonials` feed stay current without a page reload.
  Future<void> refreshTestimonials() =>
      _loadTestimonials(ref.read(supabaseTestimonialsServiceProvider));

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

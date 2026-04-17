import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/firebase_content_models.dart';
import '../models/portfolio_models.dart';
import '../services/devto_service.dart';
import '../services/firebase_portfolio_service.dart';
import '../services/github_service.dart';

class PortfolioController extends GetxController {
  final FirebasePortfolioService _firebasePortfolioService =
      Get.find<FirebasePortfolioService>();

  StreamSubscription<List<SiteSectionConfig>>? _sectionsSubscription;
  StreamSubscription<List<ManagedSocialLink>>? _socialLinksSubscription;
  StreamSubscription<List<Project>>? _projectsSubscription;
  bool _hasFirestoreProjects = false;

  // ─── Availability toggle ────────────────────────────────────────────────────
  final isAvailableForWork = true.obs;

  // ─── Loading states ─────────────────────────────────────────────────────────
  final isLoadingProjects = false.obs;
  final isLoadingBlog = false.obs;
  final githubStats = Rxn<GitHubStats>();

  // ─── Firebase-backed public site state ─────────────────────────────────────
  final sectionVisibility = <String, bool>{}.obs;

  // ─── Personal Information ──────────────────────────────────────────────────
  final personalInfo =
      PersonalInfo(
        name: 'Gokul K S',
        title: 'Mobile App Designer & Flutter Developer',
        email: 'gokulofficialcommunication@gmail.com',
        location: 'India',
        bio:
            "I'm dedicated to crafting apps that bring your ideas to life, combining design and development to deliver fast, impactful results.",
        profileImageUrl: 'https://avatars.githubusercontent.com/u/gokulks',
        socialLinks: [
          SocialLink(
            platform: 'Twitter',
            url: 'https://twitter.com/gokulks',
            icon: 'twitter',
          ),
          SocialLink(
            platform: 'LinkedIn',
            url: 'https://linkedin.com/in/gokulks',
            icon: 'linkedin',
          ),
          SocialLink(
            platform: 'GitHub',
            url: 'https://github.com/${GitHubService.username}',
            icon: 'github',
          ),
          SocialLink(
            platform: 'Medium',
            url: 'https://medium.com/@gokulks',
            icon: 'medium',
          ),
          SocialLink(
            platform: 'Instagram',
            url: 'https://instagram.com/gokulks',
            icon: 'instagram',
          ),
          SocialLink(
            platform: 'Facebook',
            url: 'https://facebook.com/gokulks',
            icon: 'facebook',
          ),
        ],
      ).obs;

  // ─── Experience Data ────────────────────────────────────────────────────────
  final experiences =
      <Experience>[
        Experience(
          company: 'Tech Solutions Inc.',
          position: 'Senior Flutter Developer',
          duration: '2024 - Present',
          description:
              'Leading mobile app development projects using Flutter, implementing clean architecture patterns and mentoring junior developers.',
          technologies: ['Flutter', 'Dart', 'Firebase', 'REST APIs', 'Git'],
        ),
        Experience(
          company: 'Digital Innovations',
          position: 'Flutter Developer',
          duration: '2022 - 2024',
          description:
              'Developed cross-platform mobile applications for various clients, focusing on user experience and performance optimization.',
          technologies: [
            'Flutter',
            'Dart',
            'SQLite',
            'Provider',
            'Material Design',
          ],
        ),
        Experience(
          company: 'StartupXYZ',
          position: 'Junior Mobile Developer',
          duration: '2021 - 2022',
          description:
              'Started my journey in mobile development, learning Flutter and contributing to various app projects.',
          technologies: ['Flutter', 'Dart', 'Firebase', 'Android Studio'],
        ),
      ].obs;

  // ─── Projects (fallback if GitHub fetch fails) ─────────────────────────────
  final projects = Project.defaultPortfolioProjects().obs;

  // ─── Blog Posts (fallback if Dev.to fetch fails) ───────────────────────────
  final blogPosts =
      <BlogPost>[
        BlogPost(
          title: 'Getting Started with Flutter Development',
          excerpt:
              'Learn the basics of Flutter development and how to create your first mobile application.',
          content:
              "Flutter is Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase...",
          imageUrl:
              'https://via.placeholder.com/400x200/6366f1/ffffff?text=Flutter+Guide',
          publishDate: DateTime(2024, 1, 15),
          author: 'Gokul K S',
          tags: ['Flutter', 'Mobile Development', 'Tutorial'],
          readingTimeMinutes: 5,
        ),
        BlogPost(
          title: 'State Management in Flutter: GetX vs Provider',
          excerpt:
              'A comprehensive comparison between GetX and Provider for state management in Flutter applications.',
          content:
              "State management is crucial in Flutter development. Let's explore the differences between GetX and Provider...",
          imageUrl:
              'https://via.placeholder.com/400x200/10b981/ffffff?text=State+Management',
          publishDate: DateTime(2024, 1, 10),
          author: 'Gokul K S',
          tags: ['Flutter', 'State Management', 'GetX', 'Provider'],
          readingTimeMinutes: 7,
        ),
        BlogPost(
          title: 'Building Responsive Flutter Web Applications',
          excerpt:
              'Tips and tricks for creating responsive web applications using Flutter Web.',
          content:
              'Flutter Web has evolved significantly. Here are the best practices for building responsive web applications...',
          imageUrl:
              'https://via.placeholder.com/400x200/3b82f6/ffffff?text=Flutter+Web',
          publishDate: DateTime(2024, 1, 5),
          author: 'Gokul K S',
          tags: ['Flutter Web', 'Responsive Design', 'Web Development'],
          readingTimeMinutes: 6,
        ),
      ].obs;

  // ─── Navigation ────────────────────────────────────────────────────────────
  final currentPageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchGitHubData();
    _fetchBlogPosts();
    _bindFirebaseContent();
  }

  void _bindFirebaseContent() {
    if (!_firebasePortfolioService.isEnabled) {
      return;
    }

    _sectionsSubscription = _firebasePortfolioService
        .streamSiteSections()
        .listen((sections) {
          if (sections.isEmpty) {
            return;
          }

          sectionVisibility.assignAll({
            for (final section in sections) section.key: section.isVisible,
          });
        });

    _socialLinksSubscription = _firebasePortfolioService
        .streamSocialLinks()
        .listen((links) {
          if (links.isEmpty) {
            return;
          }

          _applyManagedSocialLinks(links);
        });

    _projectsSubscription = _firebasePortfolioService.streamProjects().listen((
      liveProjects,
    ) {
      if (liveProjects.isEmpty) {
        return;
      }

      _hasFirestoreProjects = true;
      projects.assignAll(
        liveProjects..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
      );
    });
  }

  void _applyManagedSocialLinks(List<ManagedSocialLink> links) {
    final current = personalInfo.value;
    final visibleLinks =
        links.where((link) => link.isVisible).toList()
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    final emailLink = visibleLinks.firstWhereOrNull(
      (link) => link.type == 'email',
    );

    final mappedSocialLinks = visibleLinks
        .where((link) => link.type != 'email')
        .map(
          (link) => SocialLink(
            platform: link.platform,
            url: link.value,
            icon: link.platform.toLowerCase(),
          ),
        )
        .toList(growable: false);

    personalInfo.value = PersonalInfo(
      name: current.name,
      title: current.title,
      email: emailLink?.value ?? current.email,
      location: current.location,
      bio: current.bio,
      profileImageUrl: current.profileImageUrl,
      socialLinks:
          mappedSocialLinks.isEmpty ? current.socialLinks : mappedSocialLinks,
    );
  }

  Future<void> _fetchGitHubData() async {
    isLoadingProjects.value = true;
    try {
      final [repos, stats] = await Future.wait([
        GitHubService.fetchRepositories(),
        GitHubService.fetchUserStats(),
      ]);

      if (!_hasFirestoreProjects && (repos as List<Project>).isNotEmpty) {
        projects.assignAll(repos);
      }
      githubStats.value = stats as GitHubStats?;
    } catch (_) {}
    isLoadingProjects.value = false;
  }

  Future<void> _fetchBlogPosts() async {
    isLoadingBlog.value = true;
    try {
      final posts = await DevToService.fetchArticles();
      if (posts.isNotEmpty) {
        blogPosts.assignAll(posts);
      }
    } catch (_) {}
    isLoadingBlog.value = false;
  }

  Future<void> refreshProjects() => _fetchGitHubData();
  Future<void> refreshBlog() => _fetchBlogPosts();

  void changePage(int index) => currentPageIndex.value = index;

  void toggleAvailability() => isAvailableForWork.toggle();

  bool isSectionVisible(String sectionKey, {bool fallback = true}) {
    return sectionVisibility[sectionKey] ?? fallback;
  }

  // ─── URL Launchers ─────────────────────────────────────────────────────────
  Future<void> launchEmail({String? subject, String? body}) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: personalInfo.value.email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not open email client.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> launchUrlFromString(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  Future<void> launchSocialLink(String url) => launchUrlFromString(url);

  Future<void> launchResume() async {
    const resumeUrl =
        'https://drive.google.com/file/d/YOUR_RESUME_FILE_ID/view';
    await launchUrlFromString(resumeUrl);
  }

  // ─── Filter helpers ────────────────────────────────────────────────────────
  List<Project> get publishedProjects =>
      projects.where((project) => project.isPublished).toList(growable: false)
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

  List<Project> get featuredProjects => publishedProjects
      .where((project) => project.isFeatured)
      .toList(growable: false)
    ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

  List<Project> getProjectsByCategory(String category) =>
      publishedProjects.where((p) => p.category == category).toList();

  List<BlogPost> getBlogPostsByTag(String tag) =>
      blogPosts.where((p) => p.tags.contains(tag)).toList();

  SocialLink? getSocialLink(String platform) =>
      personalInfo.value.socialLinks
          .where((s) => s.platform.toLowerCase() == platform.toLowerCase())
          .firstOrNull;

  @override
  void onClose() {
    _sectionsSubscription?.cancel();
    _socialLinksSubscription?.cancel();
    _projectsSubscription?.cancel();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_models.dart';

class PortfolioController extends GetxController {
  // Personal Information
  final personalInfo =
      PersonalInfo(
        name: "Gokul K S",
        title: "Mobile app-designer, Flutter Developer",
        email: "gokulofficialcommunication@gmail.com",
        location: "India",
        bio:
            "I'm dedicated to crafting websites that bring your ideas to life, combining design and development to deliver fast, impactful results.",
        profileImageUrl:
            "https://via.placeholder.com/200x200/6366f1/ffffff?text=GK",
        socialLinks: [
          SocialLink(
            platform: "Twitter",
            url: "https://twitter.com/gokulks",
            icon: "twitter",
          ),
          SocialLink(
            platform: "LinkedIn",
            url: "https://linkedin.com/in/gokulks",
            icon: "linkedin",
          ),
          SocialLink(
            platform: "GitHub",
            url: "https://github.com/gokulks",
            icon: "github",
          ),
        ],
      ).obs;

  // Experience Data
  final experiences =
      <Experience>[
        Experience(
          company: "Tech Solutions Inc.",
          position: "Senior Flutter Developer",
          duration: "2024 - Present",
          description:
              "Leading mobile app development projects using Flutter, implementing clean architecture patterns and mentoring junior developers.",
          technologies: ["Flutter", "Dart", "Firebase", "REST APIs", "Git"],
        ),
        Experience(
          company: "Digital Innovations",
          position: "Flutter Developer",
          duration: "2022 - 2024",
          description:
              "Developed cross-platform mobile applications for various clients, focusing on user experience and performance optimization.",
          technologies: [
            "Flutter",
            "Dart",
            "SQLite",
            "Provider",
            "Material Design",
          ],
        ),
        Experience(
          company: "StartupXYZ",
          position: "Junior Mobile Developer",
          duration: "2021 - 2022",
          description:
              "Started my journey in mobile development, learning Flutter and contributing to various app projects.",
          technologies: ["Flutter", "Dart", "Firebase", "Android Studio"],
        ),
      ].obs;

  // Projects Data
  final projects =
      <Project>[
        Project(
          title: "E-Commerce Mobile App",
          description:
              "A full-featured e-commerce application with user authentication, product catalog, shopping cart, and payment integration.",
          imageUrl:
              "https://via.placeholder.com/400x300/6366f1/ffffff?text=E-Commerce",
          technologies: ["Flutter", "Firebase", "Stripe", "Provider"],
          githubUrl: "https://github.com/gokulks/ecommerce-app",
          liveUrl:
              "https://play.google.com/store/apps/details?id=com.example.ecommerce",
          category: "Mobile App",
        ),
        Project(
          title: "Task Management App",
          description:
              "A productivity app for managing tasks, projects, and team collaboration with real-time updates.",
          imageUrl:
              "https://via.placeholder.com/400x300/10b981/ffffff?text=Task+Manager",
          technologies: ["Flutter", "Firebase", "GetX", "Material Design"],
          githubUrl: "https://github.com/gokulks/task-manager",
          category: "Mobile App",
        ),
        Project(
          title: "Weather Forecast App",
          description:
              "Beautiful weather app with location-based forecasts, detailed weather information, and customizable themes.",
          imageUrl:
              "https://via.placeholder.com/400x300/3b82f6/ffffff?text=Weather",
          technologies: [
            "Flutter",
            "OpenWeather API",
            "Geolocator",
            "Provider",
          ],
          githubUrl: "https://github.com/gokulks/weather-app",
          category: "Mobile App",
        ),
        Project(
          title: "Portfolio Website",
          description:
              "Responsive portfolio website built with Flutter Web showcasing my projects and skills.",
          imageUrl:
              "https://via.placeholder.com/400x300/8b5cf6/ffffff?text=Portfolio",
          technologies: ["Flutter Web", "GetX", "Responsive Design"],
          githubUrl: "https://github.com/gokulks/portfolio",
          liveUrl: "https://gokulks.dev",
          category: "Web App",
        ),
      ].obs;

  // Blog Posts Data
  final blogPosts =
      <BlogPost>[
        BlogPost(
          title: "Getting Started with Flutter Development",
          excerpt:
              "Learn the basics of Flutter development and how to create your first mobile application.",
          content:
              "Flutter is Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase...",
          imageUrl:
              "https://via.placeholder.com/400x200/6366f1/ffffff?text=Flutter+Guide",
          publishDate: DateTime(2024, 1, 15),
          author: "Gokul K S",
          tags: ["Flutter", "Mobile Development", "Tutorial"],
        ),
        BlogPost(
          title: "State Management in Flutter: GetX vs Provider",
          excerpt:
              "A comprehensive comparison between GetX and Provider for state management in Flutter applications.",
          content:
              "State management is crucial in Flutter development. Let's explore the differences between GetX and Provider...",
          imageUrl:
              "https://via.placeholder.com/400x200/10b981/ffffff?text=State+Management",
          publishDate: DateTime(2024, 1, 10),
          author: "Gokul K S",
          tags: ["Flutter", "State Management", "GetX", "Provider"],
        ),
        BlogPost(
          title: "Building Responsive Flutter Web Applications",
          excerpt:
              "Tips and tricks for creating responsive web applications using Flutter Web.",
          content:
              "Flutter Web has evolved significantly. Here are the best practices for building responsive web applications...",
          imageUrl:
              "https://via.placeholder.com/400x200/3b82f6/ffffff?text=Flutter+Web",
          publishDate: DateTime(2024, 1, 5),
          author: "Gokul K S",
          tags: ["Flutter Web", "Responsive Design", "Web Development"],
        ),
      ].obs;

  // Navigation
  final currentPageIndex = 0.obs;

  void changePage(int index) {
    currentPageIndex.value = index;
  }

  // URL Launcher methods
  Future<void> launchEmail() async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: personalInfo.value.email,
      );
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        Get.snackbar(
          'Error',
          'Could not open email client. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open email client: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> launchUrlFromString(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar(
          'Error',
          'Could not open URL: $url',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open URL: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> launchSocialLink(String url) async {
    await launchUrlFromString(url);
  }

  Future<void> launchResume() async {
    // TODO: Replace with actual resume URL
    const resumeUrl = 'https://example.com/resume.pdf';
    await launchUrlFromString(resumeUrl);
  }

  // Filter methods
  List<Project> getProjectsByCategory(String category) {
    return projects.where((project) => project.category == category).toList();
  }

  List<BlogPost> getBlogPostsByTag(String tag) {
    return blogPosts.where((post) => post.tags.contains(tag)).toList();
  }
}

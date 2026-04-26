import 'package:get/get.dart';

import '../features/admin/admin.dart';
import '../pages/about_page.dart';
import '../pages/blog_page.dart';
import '../pages/contact_page.dart';
import '../pages/experience_page.dart';
import '../pages/home_page.dart';
import '../pages/projects_page.dart';
import '../pages/skills_page.dart';
import '../pages/splash_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String about = '/about';
  static const String experience = '/experience';
  static const String projects = '/projects';
  static const String blog = '/blog';
  static const String contact = '/contact';
  static const String skills = '/skills';
  static const String admin = '/admin';

  static const Map<int, String> indexToRoute = {
    0: home,
    1: about,
    2: experience,
    3: projects,
    4: blog,
    5: contact,
    6: skills,
  };

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: about, page: () => const AboutPage()),
    GetPage(name: experience, page: () => const ExperiencePage()),
    GetPage(name: projects, page: () => const ProjectsPage()),
    GetPage(name: blog, page: () => const BlogPage()),
    GetPage(name: contact, page: () => const ContactPage()),
    GetPage(name: skills, page: () => const SkillsPage()),
    GetPage(name: admin, page: () => AdminAuthGatePage()),
  ];
}

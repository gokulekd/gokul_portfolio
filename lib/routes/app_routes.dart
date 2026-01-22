import 'package:get/get.dart';

import '../pages/about_page.dart';
import '../pages/blog_page.dart';
import '../pages/contact_page.dart';
import '../pages/experience_page.dart';
import '../pages/home_page.dart';
import '../pages/projects_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String about = '/about';
  static const String experience = '/experience';
  static const String projects = '/projects';
  static const String blog = '/blog';
  static const String contact = '/contact';

  static List<GetPage> routes = [
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: about, page: () => const AboutPage()),
    GetPage(name: experience, page: () => const ExperiencePage()),
    GetPage(name: projects, page: () => const ProjectsPage()),
    GetPage(name: blog, page: () => const BlogPage()),
    GetPage(name: contact, page: () => const ContactPage()),
  ];
}

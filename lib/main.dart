import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Responsive framework available but using manual MediaQuery approach for better control
// import 'package:responsive_framework/responsive_framework.dart';

import 'constants/colors.dart';
import 'controllers/portfolio_controller.dart';
import 'pages/about_page.dart';
import 'pages/blog_page.dart';
import 'pages/contact_page.dart';
import 'pages/experience_page.dart';
import 'pages/home_page.dart';
import 'pages/projects_page.dart';
import 'pages/skills_page.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the portfolio controller
    Get.put(PortfolioController());

    return GetMaterialApp(
      title: 'Gokul K S - Portfolio',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
      // Responsive framework is configured via MediaQuery and LayoutBuilder
      // All widgets use ResponsiveHelper for breakpoint detection
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        primaryColor: AppColors.primaryGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          primary: AppColors.primaryGreen,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.manropeTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          titleTextStyle: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor:
                Colors.black, // Dark text on bright green looks better/standard
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}

// MainWrapper is unused but kept for potential future use
class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      final index = controller.currentPageIndex.value;
      final page = switch (index) {
        0 => const HomePage(),
        1 => const AboutPage(),
        2 => const ExperiencePage(),
        3 => const ProjectsPage(),
        4 => const BlogPage(),
        5 => const ContactPage(),
        6 => const SkillsPage(),
        _ => const HomePage(),
      };
      return KeyedSubtree(key: ValueKey<int>(index), child: page);
    });
  }
}

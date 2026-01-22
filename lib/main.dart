import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
// Responsive framework available but using manual MediaQuery approach for better control
// import 'package:responsive_framework/responsive_framework.dart';

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
        primaryColor: const Color(0xFF82FF1F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF82FF1F),
          primary: const Color(0xFF82FF1F),
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
            backgroundColor: const Color(0xFF82FF1F),
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
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMain();
  }

  _navigateToMain() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (mounted) {
      Get.off(
        () => const MainWrapper(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation
            SizedBox(
              width: 400,
              height: 400,
              child: Lottie.asset(
                'assets/lottie/loading.json',
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
              ),
            ),
            const SizedBox(height: 30),
            // App Title
            Text(
              'Gokul K S',
              style: GoogleFonts.manrope(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Portfolio',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 50),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      switch (controller.currentPageIndex.value) {
        case 0:
          return const HomePage();
        case 1:
          return const AboutPage();
        case 2:
          return const ExperiencePage();
        case 3:
          return const ProjectsPage();
        case 4:
          return const BlogPage();
        case 5:
          return const ContactPage();
        case 6:
          return const SkillsPage();
        default:
          return const HomePage();
      }
    });
  }
}

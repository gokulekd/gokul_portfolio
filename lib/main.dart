import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/colors.dart';
import 'controllers/portfolio_controller.dart';
import 'controllers/theme_controller.dart';
import 'pages/about_page.dart';
import 'pages/admin_page.dart';
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
    final themeController = Get.put(ThemeController());
    Get.put(PortfolioController());

    final textTheme = GoogleFonts.manropeTextTheme();

    return Obx(
      () => GetMaterialApp(
        title: 'Gokul K S — Flutter Developer & Designer',
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 300),
        theme: buildLightTheme(textTheme),
        darkTheme: buildDarkTheme(textTheme),
        themeMode: themeController.themeMode,
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.routes,
      ),
    );
  }
}

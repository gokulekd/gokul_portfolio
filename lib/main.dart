import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controllers/portfolio_controller.dart';
import 'controllers/theme_controller.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'features/admin/services/admin_auth_service.dart';
import 'routes/app_routes.dart';
import 'services/firebase_portfolio_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    Get.put(FirebasePortfolioService(), permanent: true);
    Get.put(AdminAuthService(), permanent: true);
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

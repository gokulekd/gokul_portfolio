import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _key = 'isDarkMode';

  final isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(_key) ?? false;
    _applyTheme();
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDarkMode.value);
    _applyTheme();
  }

  void _applyTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
}

ThemeData buildLightTheme(TextTheme textTheme) => ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF6DD94C),
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6DD94C),
    brightness: Brightness.light,
  ),
  textTheme: textTheme,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black87,
    elevation: 1,
    surfaceTintColor: Colors.transparent,
  ),
  cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6DD94C),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);

ThemeData buildDarkTheme(TextTheme textTheme) => ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF6DD94C),
  scaffoldBackgroundColor: const Color(0xFF0A0A0A),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6DD94C),
    brightness: Brightness.dark,
    surface: const Color(0xFF121212),
    onSurface: Colors.white,
  ),
  textTheme: textTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0A0A0A),
    foregroundColor: Colors.white,
    elevation: 1,
    surfaceTintColor: Colors.transparent,
  ),
  cardTheme: const CardThemeData(
    color: Color(0xFF1E1E1E),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6DD94C),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);

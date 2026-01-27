import 'package:flutter/material.dart';

/// App color constants
/// Centralized color definitions for consistent theming across the app
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Green Colors
  /// Primary bright green used for CTAs, buttons, and highlights
  /// Hex: #82FF1F
  static const Color primaryGreen = Color(0xFF82FF1F);

  /// Alternative green used in skills section
  /// RGB: (103, 209, 16) | Hex: #67D110
  static const Color skillsGreen = Color.fromARGB(255, 103, 209, 16);

  /// Darker green used for text and accents
  /// Hex: #10B981
  static const Color darkGreen = Color(0xFF10B981);

  /// Teal/cyan green used in various sections
  /// Hex: #00D4AA
  static const Color tealGreen = Color(0xFF00D4AA);

  // Neutral Colors
  /// Light grey background
  static const Color lightGrey = Color(0xFFF8F8F8);

  /// Dark grey text
  static const Color darkGrey = Color(0xFF2F2F2F);

  /// Black
  static const Color black = Colors.black;

  /// White
  static const Color white = Colors.white;
}

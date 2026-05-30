import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/app_colors.dart';
import '../models/admin_portal_models.dart';

class AdminStateChip extends StatelessWidget {
  const AdminStateChip({super.key, required this.state, this.label});

  final AdminItemState state;
  final String? label;

  Color get _background => switch (state) {
    AdminItemState.live => AppColors.primaryGreen.withValues(alpha: 0.15),
    AdminItemState.draft => const Color(0xFFFFB44C).withValues(alpha: 0.15),
    AdminItemState.hidden => Colors.white.withValues(alpha: 0.08),
    AdminItemState.warning => const Color(0xFFFF7C7C).withValues(alpha: 0.15),
  };

  Color get _foreground => switch (state) {
    AdminItemState.live => AppColors.primaryGreen,
    AdminItemState.draft => const Color(0xFFFFC261),
    AdminItemState.hidden => Colors.white70,
    AdminItemState.warning => const Color(0xFFFF8C8C),
  };

  String get _stateLabel =>
      label ??
      switch (state) {
        AdminItemState.live => 'Live',
        AdminItemState.draft => 'Draft',
        AdminItemState.hidden => 'Hidden',
        AdminItemState.warning => 'Needs attention',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _stateLabel,
        style: GoogleFonts.manrope(
          color: _foreground,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}

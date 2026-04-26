import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../models/admin_portal_models.dart';

class AdminSurfaceCard extends StatelessWidget {
  const AdminSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF15171A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AdminSectionHeader extends StatelessWidget {
  const AdminSectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    this.action,
  });

  final String eyebrow;
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: GoogleFonts.manrope(
                  color: AppColors.primaryGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.manrope(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        if (action != null) ...[const SizedBox(width: 16), action!],
      ],
    );
  }
}

class AdminPrimaryButton extends StatelessWidget {
  const AdminPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      icon: Icon(icon ?? Icons.add_rounded, size: 18),
      label: Text(
        label,
        style: GoogleFonts.manrope(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class AdminGhostButton extends StatelessWidget {
  const AdminGhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      icon: Icon(icon ?? Icons.tune_rounded, size: 18),
      label: Text(
        label,
        style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
      ),
    );
  }
}

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

class AdminMetricCard extends StatelessWidget {
  const AdminMetricCard({super.key, required this.item});

  final AdminMetricItem item;

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: item.color),
          ),
          const SizedBox(height: 22),
          Text(
            item.value,
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.change,
            style: GoogleFonts.manrope(
              color: Colors.white54,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSearchField extends StatelessWidget {
  const AdminSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: GoogleFonts.manrope(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.04),
        prefixIcon: const Icon(Icons.search_rounded, color: Colors.white54),
        hintText: 'Search modules, items, or labels',
        hintStyle: GoogleFonts.manrope(color: Colors.white38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

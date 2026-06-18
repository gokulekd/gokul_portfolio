import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/app_colors.dart';
import '../../providers/portfolio_provider.dart';

class AvailableForWorkBadge extends ConsumerStatefulWidget {
  final double fontSize;

  const AvailableForWorkBadge({super.key, this.fontSize = 13});

  @override
  ConsumerState<AvailableForWorkBadge> createState() =>
      _AvailableForWorkBadgeState();
}

class _AvailableForWorkBadgeState extends ConsumerState<AvailableForWorkBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAvailable =
        ref.watch(portfolioProvider.select((s) => s.isAvailableForWork));

    return isAvailable
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryGreen.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, _) => Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGreen.withOpacity(
                        _pulseAnimation.value,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(0.6),
                          blurRadius: 6 * _pulseAnimation.value,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  'Available for work',
                  style: GoogleFonts.manrope(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w600,
                    color: AppColors.skillsGreen,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

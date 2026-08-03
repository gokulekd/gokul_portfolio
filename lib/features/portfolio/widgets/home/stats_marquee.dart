import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../models/firebase_content_models.dart';

class StatsMarquee extends ConsumerStatefulWidget {
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  /// Which marquee this is — [StatItemPlacement.top] or
  /// [StatItemPlacement.bottom]. Stats tagged 'both' (the default) show in
  /// either; stats tagged specifically for one show only there.
  final String placement;

  const StatsMarquee({
    super.key,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.only(top: 40),
    this.placement = StatItemPlacement.both,
  });

  @override
  ConsumerState<StatsMarquee> createState() => _StatsMarqueeState();
}

class _StatsMarqueeState extends ConsumerState<StatsMarquee>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  void _startScrolling() {
    if (!mounted) return;
    _animationController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(_scrollController.offset + 1);
        }
      }
    });
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref
        .watch(portfolioProvider.select((s) => s.visibleStats))
        .where((s) => s.placement == StatItemPlacement.both || s.placement == widget.placement)
        .toList();

    return Container(
      width: double.infinity,
      color: widget.backgroundColor,
      padding: widget.padding,
      child: Container(
        color: const Color(0xFF2F2F2F),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: List.generate(10, (index) {
              return Row(
                children: [
                  for (final stat in stats) ...[
                    _buildStatItem(stat.value, stat.label),
                    _buildSeparator(),
                  ],
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: const Icon(Icons.star, color: Colors.grey, size: 16),
    );
  }
}

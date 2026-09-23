import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';

/// Round monochrome social link: a black circle with a white icon in light
/// mode, a white circle with a black icon in dark mode. On hover it lifts
/// and the icon turns brand green.
class SocialIconButton extends ConsumerStatefulWidget {
  final String platform;
  final String url;
  final IconData icon;

  const SocialIconButton({
    super.key,
    required this.platform,
    required this.url,
    required this.icon,
  });

  @override
  ConsumerState<SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends ConsumerState<SocialIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background =
        isDark
            ? (_hovered ? const Color(0xFFE8E8E8) : Colors.white)
            : (_hovered ? const Color(0xFF2A2A2A) : const Color(0xFF111111));
    final restingIcon = isDark ? const Color(0xFF111111) : Colors.white;
    // The bright brand green washes out on white, so dark mode uses the
    // deeper green for the hover state.
    final hoverIcon = isDark ? AppColors.skillsGreen : AppColors.primaryGreen;

    return Tooltip(
      message: widget.platform,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap:
              () => ref
                  .read(portfolioProvider.notifier)
                  .launchSocialLink(widget.url),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: 40,
            height: 40,
            transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      _hovered
                          ? AppColors.primaryGreen.withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: isDark ? 0.4 : 0.18),
                  blurRadius: _hovered ? 14 : 8,
                  offset: Offset(0, _hovered ? 6 : 3),
                ),
              ],
            ),
            child: TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 180),
              tween: ColorTween(end: _hovered ? hoverIcon : restingIcon),
              builder:
                  (context, color, _) =>
                      Icon(widget.icon, size: 20, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

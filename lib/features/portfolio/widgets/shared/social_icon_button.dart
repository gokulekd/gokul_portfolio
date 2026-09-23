import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';

/// Round social link: brand green with a white icon, darkening and lifting
/// slightly on hover.
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
              color: _hovered ? AppColors.skillsGreen : AppColors.primaryGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(
                    alpha: _hovered ? 0.45 : 0.25,
                  ),
                  blurRadius: _hovered ? 14 : 8,
                  offset: Offset(0, _hovered ? 6 : 3),
                ),
              ],
            ),
            child: Icon(widget.icon, size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

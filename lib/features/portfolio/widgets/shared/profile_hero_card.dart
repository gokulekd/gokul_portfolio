import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'available_badge.dart';
import 'social_icon_button.dart';

/// Profile card (avatar, availability badge, name, title and social links)
/// used by hero sections across the site (Home, About, ...). Keeping this
/// in one place ensures every hero section presents the profile identically.
class ProfileHeroCard extends ConsumerStatefulWidget {
  const ProfileHeroCard({
    super.key,
    required this.imageRadius,
    required this.nameFontSize,
    required this.titleFontSize,
    required this.socialIconScale,
  });

  final double imageRadius;
  final double nameFontSize;
  final double titleFontSize;
  final double socialIconScale;

  @override
  ConsumerState<ProfileHeroCard> createState() => _ProfileHeroCardState();
}

class _ProfileHeroCardState extends ConsumerState<ProfileHeroCard>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _textController;
  late AnimationController _socialController;
  late AnimationController _pulseController;

  late Animation<double> _imageScale;
  late Animation<double> _imageOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _socialOpacity;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Image animation - smooth fade and scale
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _imageScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeOutCubic),
    );
    _imageOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _imageController, curve: Curves.easeOut));

    // Name / title animation - smooth fade
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Social icons animation - smooth fade
    _socialController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _socialOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _socialController, curve: Curves.easeOut),
    );

    // Pulse animation - very subtle
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    // Smooth sequential loading - image first
    _imageController.forward();

    // Then name and title
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _textController.forward();
    });

    // Then social icons
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _socialController.forward();
    });

    // Start subtle animation after everything is loaded
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    _socialController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  IconData _iconForPlatform(String platform) {
    switch (platform.toLowerCase()) {
      case 'twitter':
      case 'x':
      case 'twitter/x':
        return FontAwesomeIcons.xTwitter;
      case 'linkedin':
        return FontAwesomeIcons.linkedinIn;
      case 'github':
        return FontAwesomeIcons.github;
      case 'medium':
        return FontAwesomeIcons.medium;
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'facebook':
        return FontAwesomeIcons.facebook;
      default:
        return FontAwesomeIcons.globe;
    }
  }

  Widget _buildSocialLinks(BuildContext context) {
    final links = ref.watch(portfolioProvider).personalInfo.socialLinks;
    final gap = SizedBox(
      width: ResponsiveHelper.isMobile(context) ? 16.0 : 24.0,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < links.length; i++) ...[
          if (i > 0) gap,
          Transform.scale(
            scale: widget.socialIconScale,
            child: _buildAnimatedSocialIcon(
              SocialIconButton(
                platform: links[i].platform,
                url: links[i].url,
                icon: _iconForPlatform(links[i].platform),
              ),
              i,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAnimatedSocialIcon(Widget child, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2), // Scale from 0.8 to 1.0
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(portfolioProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile Image
        Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_imageController, _pulseController]),
            builder: (context, child) {
              return Transform.scale(
                scale: _imageScale.value * _pulseAnimation.value,
                child: Opacity(
                  opacity: _imageOpacity.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: widget.imageRadius,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: const AssetImage(
                        'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
                      ),
                      onBackgroundImageError: (exception, stackTrace) {},
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Available for work badge
        const AvailableForWorkBadge(),
        const SizedBox(height: 16),

        // Name and Title
        AnimatedBuilder(
          animation: _textController,
          builder: (context, child) {
            return Opacity(
              opacity: _textOpacity.value,
              child: Column(
                children: [
                  Text(
                    state.personalInfo.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: widget.nameFontSize,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.personalInfo.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: widget.titleFontSize,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        // Social Links
        AnimatedBuilder(
          animation: _socialController,
          builder: (context, child) {
            return Opacity(
              opacity: _socialOpacity.value,
              child: _buildSocialLinks(context),
            );
          },
        ),
      ],
    );
  }
}

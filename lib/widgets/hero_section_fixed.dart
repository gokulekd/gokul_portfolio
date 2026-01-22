import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/portfolio_controller.dart';
import 'custom_widgets.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _textController;
  late AnimationController _socialController;
  late AnimationController _taglineController;
  late AnimationController _contentController;
  late AnimationController _pulseController;

  late Animation<double> _imageScale;
  late Animation<double> _imageOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _socialOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<double> _contentOpacity;
  late Animation<double> _pulseAnimation;

  String _displayedName = '';
  String _displayedTitle = '';
  String _displayedTagline = '';
  String _fullName = '';
  String _fullTitle = '';
  String _fullTagline = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Image animations - smooth fade and scale
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

    // Text animations - smooth fade
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Social icons animations - smooth fade
    _socialController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _socialOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _socialController, curve: Curves.easeOut));

    // Tagline animations - smooth fade
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    // Content fade animations - smooth fade
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _contentOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
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
    final controller = Get.find<PortfolioController>();
    _fullName = controller.personalInfo.value.name;
    _fullTitle = controller.personalInfo.value.title;
    _fullTagline = "turning your ideas into pixel-perfect realities";

    // Set initial displayed text immediately
    _displayedName = _fullName;
    _displayedTitle = _fullTitle;
    _displayedTagline = _fullTagline;

    // Smooth sequential loading - image first
    _imageController.forward();

    // Then name and title
    Future.delayed(const Duration(milliseconds: 300), () {
      _textController.forward();
    });

    // Then content section
    Future.delayed(const Duration(milliseconds: 500), () {
      _contentController.forward();
    });

    // Then tagline
    Future.delayed(const Duration(milliseconds: 700), () {
      _taglineController.forward();
    });

    // Then social icons
    Future.delayed(const Duration(milliseconds: 900), () {
      _socialController.forward();
    });

    // Start subtle animations after everything is loaded
    Future.delayed(const Duration(milliseconds: 1500), () {
      _pulseController.repeat(reverse: true);
    });
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

  Widget _buildLargePill(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: backgroundColor == Colors.white
              ? Colors.grey[300]!
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildLargeButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF82FF1F),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF82FF1F),
                width: 2,
              ),
            ),
            child: const Icon(
              FontAwesomeIcons.arrowRight,
              size: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    _socialController.dispose();
    _taglineController.dispose();
    _contentController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final availableHeight = screenHeight - appBarHeight;

    return Container(
      width: double.infinity,
      height: availableHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[50]!, Colors.grey[100]!, Colors.grey[50]!],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 60.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Profile Section
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Profile Image
                  Center(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _imageController,
                        _pulseController,
                      ]),
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
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.1),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 120,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: const AssetImage(
                                  'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
                                ),
                                onBackgroundImageError: (
                                  exception,
                                  stackTrace,
                                ) {
                                  // Fallback to icon if image fails to load
                                },
                                child: null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Animated Name and Title
                  Center(
                    child: AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacity.value,
                          child: Column(
                            children: [
                              // Name
                              Text(
                                _displayedName,
                                style: GoogleFonts.inter(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Title
                              Text(
                                _displayedTitle,
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Animated Social Links
                  Center(
                    child: AnimatedBuilder(
                      animation: _socialController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _socialOpacity.value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale: 1.5,
                                child: _buildAnimatedSocialIcon(
                                  SocialIconButton(
                                    platform: "Twitter",
                                    url:
                                        controller
                                            .personalInfo
                                            .value
                                            .socialLinks[0]
                                            .url,
                                    icon: FontAwesomeIcons.twitter,
                                  ),
                                  0,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Transform.scale(
                                scale: 1.5,
                                child: _buildAnimatedSocialIcon(
                                  SocialIconButton(
                                    platform: "LinkedIn",
                                    url:
                                        controller
                                            .personalInfo
                                            .value
                                            .socialLinks[1]
                                            .url,
                                    icon: FontAwesomeIcons.linkedin,
                                  ),
                                  1,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Transform.scale(
                                scale: 1.5,
                                child: _buildAnimatedSocialIcon(
                                  SocialIconButton(
                                    platform: "GitHub",
                                    url:
                                        controller
                                            .personalInfo
                                            .value
                                            .socialLinks[2]
                                            .url,
                                    icon: FontAwesomeIcons.github,
                                  ),
                                  2,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Timeline - appears with social icons
                  AnimatedBuilder(
                    animation: _socialController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _socialOpacity.value,
                        child: child!,
                      );
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          "(2024 - PRESENT)",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 80),

            // Right Hero Section with Fade Animation
            Expanded(
              flex: 3,
              child: AnimatedBuilder(
                animation: _contentController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _contentOpacity.value,
                    child: child,
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Greeting - appears with content
                    AnimatedBuilder(
                      animation: _contentController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _contentOpacity.value,
                          child: child!,
                        );
                      },
                      child: Text(
                        "Hi! I'm",
                        style: GoogleFonts.inter(
                          fontSize: 72,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name and Role Pills - appears with content
                    AnimatedBuilder(
                      animation: _contentController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _contentOpacity.value,
                          child: child!,
                        );
                      },
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _buildLargePill(
                            controller.personalInfo.value.name,
                            Colors.white,
                            Colors.black87,
                          ),
                          _buildLargePill(
                            "a Flutter developer",
                            Colors.black87,
                            Colors.white,
                          ),
                          _buildLargePill(
                            "from India",
                            Colors.white,
                            Colors.black87,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Animated Main Tagline
                    AnimatedBuilder(
                      animation: _taglineController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _taglineOpacity.value,
                          child: Text(
                            _displayedTagline,
                            style: GoogleFonts.inter(
                              fontSize: 64,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Description - appears with tagline
                    AnimatedBuilder(
                      animation: _taglineController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _taglineOpacity.value,
                          child: child!,
                        );
                      },
                      child: Text(
                        controller.personalInfo.value.bio,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          color: Colors.grey[600],
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // CTA Button
                    AnimatedBuilder(
                      animation: _taglineController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _taglineOpacity.value, // Appear with tagline
                          child: _buildLargeButton(
                            "See what i can do",
                            () {
                              // Smooth scroll to skills section
                              // This will be handled by the parent widget
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  late AnimationController _buttonController;
  late AnimationController _pulseController;
  late AnimationController _buttonSlideController;

  late Animation<double> _imageScale;
  late Animation<double> _imageOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _socialOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _contentSlide;
  late Animation<double> _buttonFloat;
  late Animation<double> _pulseAnimation;
  late Animation<double> _buttonSlide;

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
    // Image animations
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _imageScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.elasticOut),
    );
    _imageOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _imageController, curve: Curves.easeIn));

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // Social icons animations
    _socialController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _socialOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _socialController, curve: Curves.easeIn));

    // Tagline animations
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );

    // Content slide animations
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );

    // Button floating animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _buttonFloat = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Pulse animation for profile image
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Button slide animation
    _buttonSlideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _buttonSlide = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonSlideController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    final controller = Get.find<PortfolioController>();
    _fullName = controller.personalInfo.value.name;
    _fullTitle = controller.personalInfo.value.title;
    _fullTagline = "turning your ideas into pixel-perfect realities";

    // Start image animation immediately
    _imageController.forward();

    // Start text typing after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _textController.forward();
      _typeName();
    });

    // Start social icons after name typing
    Future.delayed(const Duration(milliseconds: 2500), () {
      _socialController.forward();
    });

    // Start content slide
    Future.delayed(const Duration(milliseconds: 800), () {
      _contentController.forward();
    });

    // Start tagline typing
    Future.delayed(const Duration(milliseconds: 3500), () {
      _taglineController.forward();
      _typeTagline();
    });

    // Start pulse animation after image appears
    Future.delayed(const Duration(milliseconds: 2000), () {
      _pulseController.repeat(reverse: true);
    });
  }

  void _onButtonPressed() {
    _buttonSlideController.forward();
  }

  void _typeName() {
    _typeText(
      _fullName,
      (value) {
        setState(() {
          _displayedName = value;
        });
      },
      () {
        Future.delayed(const Duration(milliseconds: 500), () {
          _typeTitle();
        });
      },
    );
  }

  void _typeTitle() {
    _typeText(_fullTitle, (value) {
      setState(() {
        _displayedTitle = value;
      });
    }, () {});
  }

  void _typeTagline() {
    _typeText(_fullTagline, (value) {
      setState(() {
        _displayedTagline = value;
      });
    }, () {});
  }

  void _typeText(
    String text,
    Function(String) onUpdate,
    VoidCallback onComplete,
  ) {
    int index = 0;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (index < text.length) {
        onUpdate(text.substring(0, index + 1));
        index++;
      } else {
        timer.cancel();
        onComplete();
      }
    });
  }

  Widget _buildAnimatedSocialIcon(Widget child, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    _socialController.dispose();
    _taglineController.dispose();
    _contentController.dispose();
    _buttonController.dispose();
    _pulseController.dispose();
    _buttonSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[50]!, Colors.grey[100]!, Colors.grey[50]!],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 900;

            final leftSection = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                              radius: 80,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: const AssetImage(
                                'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
                              ),
                              onBackgroundImageError: (exception, stackTrace) {
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
                const SizedBox(height: 24),

                // Animated Name and Title with Typewriter Effect
                Center(
                  child: AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textOpacity.value,
                        child: Column(
                          children: [
                            // Name with cursor effect
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _displayedName,
                                    style: GoogleFonts.manrope(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  if (_displayedName.length < _fullName.length)
                                    TextSpan(
                                      text: '|',
                                      style: GoogleFonts.manrope(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Title with cursor effect
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _displayedTitle,
                                    style: GoogleFonts.manrope(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  if (_displayedTitle.length <
                                      _fullTitle.length)
                                    TextSpan(
                                      text: '|',
                                      style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Animated Social Links
                Center(
                  child: AnimatedBuilder(
                    animation: _socialController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _socialOpacity.value,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildAnimatedSocialIcon(
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
                            _buildAnimatedSocialIcon(
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
                            _buildAnimatedSocialIcon(
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
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Timeline
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "(2024 - PRESENT)",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            );

            final rightSection = SlideTransition(
              position: _contentSlide,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Text(
                    "Hi! I'm",
                    style: GoogleFonts.manrope(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name and Role Pills
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      InfoPill(
                        text: controller.personalInfo.value.name,
                        backgroundColor: const Color(0xFFF8F8F8),
                        textColor: Colors.black87,
                      ),
                      InfoPill(
                        text: "a Flutter developer",
                        backgroundColor: const Color(0xFF2F2F2F),
                        textColor: Colors.white,
                      ),
                      InfoPill(
                        text: "from India",
                        backgroundColor: const Color(0xFFF8F8F8),
                        textColor: Colors.black87,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Animated Main Tagline with Typewriter Effect
                  AnimatedBuilder(
                    animation: _taglineController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _taglineOpacity.value,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _displayedTagline,
                                style: GoogleFonts.manrope(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                  height: 1.2,
                                ),
                              ),
                              if (_displayedTagline.length <
                                  _fullTagline.length)
                                TextSpan(
                                  text: '|',
                                  style: GoogleFonts.manrope(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                    height: 1.2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    controller.personalInfo.value.bio,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Animated CTA Button with Arrow Slide Effect
                  ElevatedButton(
                    onPressed: _onButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF82FF1F),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            "See what i can do",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Animated arrow that rotates to point right
                        AnimatedBuilder(
                          animation: _buttonSlide,
                          builder: (context, child) {
                            // Arrow rotates from 45 degrees (diagonal) to 0 degrees (right)
                            // When _buttonSlide.value is 0, angle is 45° (0.785398 radians)
                            // When _buttonSlide.value is 1, angle is 0° (pointing right)
                            final startAngle =
                                5.785398; // 45 degrees in radians (π/4)
                            final endAngle = 0.0; // 0 degrees (pointing right)
                            final currentAngle =
                                startAngle - (_buttonSlide.value * startAngle);

                            return Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Transform.rotate(
                                angle: currentAngle,
                                child: const Icon(
                                  FontAwesomeIcons.arrowRight,
                                  size: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );

            if (isNarrow) {
              return Column(
                children: [
                  leftSection,
                  const SizedBox(height: 40),
                  rightSection,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: leftSection),
                const SizedBox(width: 48),
                Expanded(flex: 3, child: rightSection),
              ],
            );
          },
        ),
      ),
    );
  }
}

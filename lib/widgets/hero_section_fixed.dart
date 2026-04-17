import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../controllers/portfolio_controller.dart';
import '../utils/responsive_helper.dart';
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

  Widget _buildLargePill(String text, Color backgroundColor, Color textColor, BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : isTablet ? 20 : 24,
        vertical: isMobile ? 8 : 12,
      ),
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
          fontSize: isMobile ? 14 : isTablet ? 16 : 18,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildLargeButton(String text, VoidCallback onPressed, BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : isTablet ? 28 : 32,
          vertical: isMobile ? 14 : 18,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.manrope(
                fontSize: isMobile ? 14 : isTablet ? 16 : 18,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: isMobile ? 8 : 12),
          Container(
            width: isMobile ? 28 : 32,
            height: isMobile ? 28 : 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF82FF1F),
                width: 2,
              ),
            ),
            child: Icon(
              FontAwesomeIcons.arrowRight,
              size: isMobile ? 14 : 16,
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
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    
    // Responsive values
    final horizontalPadding = isMobile ? 16.0 : isTablet ? 40.0 : 80.0;
    final verticalPadding = isMobile ? 24.0 : isTablet ? 40.0 : 60.0;
    final imageRadius = isMobile ? 80.0 : isTablet ? 100.0 : 120.0;
    final nameFontSize = isMobile ? 28.0 : isTablet ? 36.0 : 42.0;
    final titleFontSize = isMobile ? 16.0 : isTablet ? 18.0 : 20.0;
    final greetingFontSize = isMobile ? 36.0 : isTablet ? 48.0 : 72.0;
    final taglineFontSize = isMobile ? 28.0 : isTablet ? 40.0 : 64.0;
    final bioFontSize = isMobile ? 16.0 : isTablet ? 18.0 : 20.0;
    final socialIconScale = isMobile ? 1.2 : isTablet ? 1.35 : 1.5;
    final spacingBetweenSections = isMobile ? 24.0 : isTablet ? 40.0 : 80.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[50]!, Colors.grey[100]!, Colors.grey[50]!],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: isMobile
                  ? _buildMobileLayout(
                      context,
                      controller,
                      imageRadius,
                      nameFontSize,
                      titleFontSize,
                      greetingFontSize,
                      taglineFontSize,
                      bioFontSize,
                      socialIconScale,
                    )
                  : _buildDesktopLayout(
                      context,
                      controller,
                      imageRadius,
                      nameFontSize,
                      titleFontSize,
                      greetingFontSize,
                      taglineFontSize,
                      bioFontSize,
                      socialIconScale,
                      spacingBetweenSections,
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    PortfolioController controller,
    double imageRadius,
    double nameFontSize,
    double titleFontSize,
    double greetingFontSize,
    double taglineFontSize,
    double bioFontSize,
    double socialIconScale,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile Image
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
                      ],
                    ),
                    child: CircleAvatar(
                      radius: imageRadius,
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
        const SizedBox(height: 24),

        // Name and Title
        AnimatedBuilder(
          animation: _textController,
          builder: (context, child) {
            return Opacity(
              opacity: _textOpacity.value,
              child: Column(
                children: [
                  Text(
                    _displayedName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _displayedTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: titleFontSize,
                      color: Colors.grey[600],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: socialIconScale,
                    child: _buildAnimatedSocialIcon(
                      SocialIconButton(
                        platform: "Twitter",
                        url: controller.personalInfo.value.socialLinks[0].url,
                        icon: FontAwesomeIcons.twitter,
                      ),
                      0,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.isMobile(context) ? 16 : 24),
                  Transform.scale(
                    scale: socialIconScale,
                    child: _buildAnimatedSocialIcon(
                      SocialIconButton(
                        platform: "LinkedIn",
                        url: controller.personalInfo.value.socialLinks[1].url,
                        icon: FontAwesomeIcons.linkedin,
                      ),
                      1,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.isMobile(context) ? 16 : 24),
                  Transform.scale(
                    scale: socialIconScale,
                    child: _buildAnimatedSocialIcon(
                      SocialIconButton(
                        platform: "GitHub",
                        url: controller.personalInfo.value.socialLinks[2].url,
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
        const SizedBox(height: 24),

        // Timeline
        AnimatedBuilder(
          animation: _socialController,
          builder: (context, child) {
            return Opacity(
              opacity: _socialOpacity.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  "(2024 - PRESENT)",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),

        // Greeting
        AnimatedBuilder(
          animation: _contentController,
          builder: (context, child) {
            return Opacity(
              opacity: _contentOpacity.value,
              child: Text(
                "Hi! I'm",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: greetingFontSize,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[400],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),

        // Pills
        AnimatedBuilder(
          animation: _contentController,
          builder: (context, child) {
            return Opacity(
              opacity: _contentOpacity.value,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildLargePill(
                    controller.personalInfo.value.name,
                    Colors.white,
                    Colors.black87,
                    context,
                  ),
                  _buildLargePill(
                    "a Flutter developer",
                    Colors.black87,
                    Colors.white,
                    context,
                  ),
                  _buildLargePill(
                    "from India",
                    Colors.white,
                    Colors.black87,
                    context,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        // Tagline
        AnimatedBuilder(
          animation: _taglineController,
          builder: (context, child) {
            return Opacity(
              opacity: _taglineOpacity.value,
              child: Text(
                _displayedTagline,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: taglineFontSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),

        // Description
        AnimatedBuilder(
          animation: _taglineController,
          builder: (context, child) {
            return Opacity(
              opacity: _taglineOpacity.value,
              child: Text(
                controller.personalInfo.value.bio,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: bioFontSize,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        // CTA Button
        AnimatedBuilder(
          animation: _taglineController,
          builder: (context, child) {
            return Opacity(
              opacity: _taglineOpacity.value,
              child: _buildLargeButton(
                "See what i can do",
                () {},
                context,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    PortfolioController controller,
    double imageRadius,
    double nameFontSize,
    double titleFontSize,
    double greetingFontSize,
    double taglineFontSize,
    double bioFontSize,
    double socialIconScale,
    double spacingBetweenSections,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Profile Section
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Image
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
                            ],
                          ),
                          child: CircleAvatar(
                            radius: imageRadius,
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
              const SizedBox(height: 32),

              // Name and Title
              Center(
                child: AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textOpacity.value,
                      child: Column(
                        children: [
                          Text(
                            _displayedName,
                            style: GoogleFonts.inter(
                              fontSize: nameFontSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _displayedTitle,
                            style: GoogleFonts.inter(
                              fontSize: titleFontSize,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Social Links
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
                            scale: socialIconScale,
                            child: _buildAnimatedSocialIcon(
                              SocialIconButton(
                                platform: "Twitter",
                                url: controller.personalInfo.value.socialLinks[0].url,
                                icon: FontAwesomeIcons.twitter,
                              ),
                              0,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Transform.scale(
                            scale: socialIconScale,
                            child: _buildAnimatedSocialIcon(
                              SocialIconButton(
                                platform: "LinkedIn",
                                url: controller.personalInfo.value.socialLinks[1].url,
                                icon: FontAwesomeIcons.linkedin,
                              ),
                              1,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Transform.scale(
                            scale: socialIconScale,
                            child: _buildAnimatedSocialIcon(
                              SocialIconButton(
                                platform: "GitHub",
                                url: controller.personalInfo.value.socialLinks[2].url,
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
              const SizedBox(height: 32),

              // Timeline
              AnimatedBuilder(
                animation: _socialController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _socialOpacity.value,
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
                  );
                },
              ),
            ],
          ),
        ),

        SizedBox(width: spacingBetweenSections),

        // Right Hero Section
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Greeting
                AnimatedBuilder(
                  animation: _contentController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _contentOpacity.value,
                      child: Text(
                        "Hi! I'm",
                        style: GoogleFonts.inter(
                          fontSize: greetingFontSize,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[400],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Pills
                AnimatedBuilder(
                  animation: _contentController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _contentOpacity.value,
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _buildLargePill(
                            controller.personalInfo.value.name,
                            Colors.white,
                            Colors.black87,
                            context,
                          ),
                          _buildLargePill(
                            "a Flutter developer",
                            Colors.black87,
                            Colors.white,
                            context,
                          ),
                          _buildLargePill(
                            "from India",
                            Colors.white,
                            Colors.black87,
                            context,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                // Tagline
                AnimatedBuilder(
                  animation: _taglineController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _taglineOpacity.value,
                      child: Text(
                        _displayedTagline,
                        style: GoogleFonts.inter(
                          fontSize: taglineFontSize,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Description
                AnimatedBuilder(
                  animation: _taglineController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _taglineOpacity.value,
                      child: Text(
                        controller.personalInfo.value.bio,
                        style: GoogleFonts.inter(
                          fontSize: bioFontSize,
                          color: Colors.grey[600],
                          height: 1.6,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                // CTA Button
                AnimatedBuilder(
                  animation: _taglineController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _taglineOpacity.value,
                      child: _buildLargeButton(
                        "See what i can do",
                        () {},
                        context,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

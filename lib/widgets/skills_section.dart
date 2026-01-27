import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class SkillsSection extends StatefulWidget {
  final ScrollController? scrollController;

  const SkillsSection({super.key, this.scrollController});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with TickerProviderStateMixin {
  late AnimationController _skillsController;
  final List<AnimationController> _cardControllers = [];
  final List<Animation<double>> _cardAnimations = [];

  late Animation<double> _skillsOpacity;
  late Animation<Offset> _skillsSlide;

  final GlobalKey _skillsSectionKey = GlobalKey();
  Timer? _visibilityCheckTimer;
  bool _isSectionVisible = false;
  final Set<int> _visibleCards = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Start the animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _skillsController.forward();
      }
    });

    // Set up scroll listener if scrollController is provided
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(_onScroll);
    }

    // Start checking visibility periodically
    _startVisibilityCheck();
  }

  void _startVisibilityCheck() {
    _visibilityCheckTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _checkVisibilityAndAnimate();
    });
  }

  void _onScroll() {
    _checkVisibilityAndAnimate();
  }

  void _checkVisibilityAndAnimate() {
    if (widget.scrollController == null ||
        !widget.scrollController!.hasClients) {
      return;
    }

    final RenderBox? renderBox =
        _skillsSectionKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Get the position of the section relative to the screen
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenHeight = MediaQuery.of(context).size.height;

    // Account for app bar height (approximately 80px)
    final appBarHeight = 80.0;
    final viewportTop = appBarHeight;
    final viewportBottom = screenHeight;

    // Calculate visible portion of the section
    final sectionTop = position.dy;
    final sectionBottom = sectionTop + size.height;

    // Calculate how much of the section is visible
    final visibleTop = sectionTop < viewportTop ? viewportTop : sectionTop;
    final visibleBottom =
        sectionBottom > viewportBottom ? viewportBottom : sectionBottom;
    final visibleHeight = (visibleBottom - visibleTop).clamp(0.0, size.height);
    final visiblePercentage =
        size.height > 0 ? (visibleHeight / size.height) : 0.0;

    // Section is considered visible if:
    // 1. It overlaps with viewport
    // 2. At least 30% of it is visible
    // 3. The top is not too far above the viewport (within 200px)
    final isOverlapping =
        sectionBottom > viewportTop && sectionTop < viewportBottom;
    final isSignificantlyVisible = visiblePercentage >= 0.3;
    final isNotTooFarUp = sectionTop > (viewportTop - 200);

    final isVisible = isOverlapping && isSignificantlyVisible && isNotTooFarUp;

    if (isVisible != _isSectionVisible) {
      setState(() {
        _isSectionVisible = isVisible;
      });

      if (_isSectionVisible) {
        // Animate cards one by one
        _animateCardsSequentially();
      }
    }
  }

  void _animateCardsSequentially() {
    for (int i = 0; i < _skills.length; i++) {
      if (!_visibleCards.contains(i)) {
        Future.delayed(Duration(milliseconds: 200 * i), () {
          if (mounted && _isSectionVisible) {
            setState(() {
              _visibleCards.add(i);
            });
            _cardControllers[i].forward();
          }
        });
      }
    }
  }

  void _initializeAnimations() {
    // Skills section animations
    _skillsController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _skillsOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _skillsController, curve: Curves.easeIn));
    _skillsSlide = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _skillsController, curve: Curves.easeOutCubic),
    );

    // Initialize card animations
    for (int i = 0; i < _skills.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
      final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );
      _cardControllers.add(controller);
      _cardAnimations.add(animation);
    }
  }

  @override
  void dispose() {
    _visibilityCheckTimer?.cancel();
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(_onScroll);
    }
    _skillsController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _skillsController,
      builder: (context, child) {
        return SlideTransition(
          position: _skillsSlide,
          child: Opacity(
            opacity: _skillsOpacity.value,
            child: Container(
              key: _skillsSectionKey,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              decoration: BoxDecoration(color: Colors.grey[50]),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 900;
                  final maxContentWidth =
                      isNarrow ? constraints.maxWidth : 1200.0;
                  final horizontalPadding = isNarrow ? 24.0 : 80.0;

                  return Container(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Heading that fills top area
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "My Skills and Creative Toolbox",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: isNarrow ? 40 : 64,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                  letterSpacing: -1.5,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Subtitle
                              Text(
                                "Technologies and tools I use to bring ideas to life",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: isNarrow ? 16 : 20,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Cards in 3x2 grid (3 left, 3 right)
                        if (isNarrow)
                          // Mobile: Single column
                          Column(
                            children: [
                              ...List.generate(_skills.length, (index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index < _skills.length - 1 ? 20 : 0,
                                  ),
                                  child: _buildSkillCard(index),
                                );
                              }),
                            ],
                          )
                        else
                          // Desktop: 3 left, 3 right
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Left column - first 3 cards
                              Expanded(
                                child: Column(
                                  children: [
                                    ...List.generate(3, (index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: index < 2 ? 20 : 0,
                                        ),
                                        child: _buildSkillCard(index),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              // Right column - last 3 cards
                              Expanded(
                                child: Column(
                                  children: [
                                    ...List.generate(3, (index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: index < 2 ? 20 : 0,
                                        ),
                                        child: _buildSkillCard(index + 3),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> get _skills => [
    {
      'name': 'Firebase',
      'percentage': 80,
      'color': AppColors.skillsGreen,
      'icon': Icons.local_fire_department,
      'description': 'Leading collaborative design tool',
    },
    {
      'name': 'JavaScript',
      'percentage': 50,
      'color': AppColors.skillsGreen,
      'icon': Icons.javascript,
      'description': 'Leading collaborative design tool',
    },
    {
      'name': 'HTML',
      'percentage': 70,
      'color': AppColors.skillsGreen,
      'icon': Icons.language,
      'description': 'Leading collaborative design tool',
    },
    {
      'name': 'CSS',
      'percentage': 70,
      'color': AppColors.skillsGreen,
      'icon': Icons.palette,
      'description': 'Leading collaborative design tool',
    },
    {
      'name': 'Flutter',
      'percentage': 85,
      'color': AppColors.skillsGreen,
      'icon': Icons.phone_android,
      'description': 'Leading collaborative design tool',
    },
    {
      'name': 'Dart',
      'percentage': 90,
      'color': AppColors.skillsGreen,
      'icon': Icons.code,
      'description': 'Leading collaborative design tool',
    },
  ];

  Widget _buildSkillCard(int index) {
    if (index < 0 || index >= _skills.length) {
      return const SizedBox.shrink();
    }

    final skill = _skills[index];
    final animation = _cardAnimations[index];
    final isVisible = _visibleCards.contains(index);
    final percentage = skill['percentage'] as int;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: isVisible ? animation.value : 0.0,
          child: Transform.translate(
            offset: Offset(0, isVisible ? (1 - animation.value) * 20 : 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Icon Container (larger, more prominent)
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          skill['icon'] as IconData,
                          color: skill['color'] as Color,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Skill name and description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              skill['name'] as String,
                              style: GoogleFonts.manrope(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              skill['description'] as String,
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Progress bar with percentage pill
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = constraints.maxWidth;
                      final fillWidth = cardWidth * (percentage / 100);

                      return Stack(
                        children: [
                          // Background track
                          Container(
                            width: double.infinity,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          // Animated fill with percentage pill
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.easeOutQuart,
                            width: isVisible ? fillWidth : 0,
                            height: 8,
                            decoration: BoxDecoration(
                              color: skill['color'] as Color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.only(right: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: skill['color'] as Color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$percentage%',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

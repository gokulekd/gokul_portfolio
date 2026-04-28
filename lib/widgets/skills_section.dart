import 'dart:async';
import 'dart:math' as math;

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
      // Start checking visibility periodically only when scroll-driven
      _startVisibilityCheck();
    } else {
      // No scroll controller — show cards immediately after mount
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => _isSectionVisible = true);
          _animateCardsSequentially();
        }
      });
    }
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
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _BackgroundPainter()),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 80,
                      horizontal: 24,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 900;
                        final maxContentWidth =
                            isNarrow ? constraints.maxWidth : 1200.0;
                        final horizontalPadding = isNarrow ? 24.0 : 80.0;

                        return Center(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: maxContentWidth,
                            ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "{01} - My Skills",
                                            style: GoogleFonts.manrope(
                                              fontSize: 18,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primaryGreen,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "My Skills and Creative Toolbox",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.manrope(
                                          fontSize: isNarrow ? 40 : 64,
                                          fontWeight: FontWeight.w800,
                                          color: Theme.of(context).colorScheme.onSurface,
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
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
                                            bottom:
                                                index < _skills.length - 1
                                                    ? 20
                                                    : 0,
                                          ),
                                          child: _buildSkillCard(index),
                                        );
                                      }),
                                    ],
                                  )
                                else
                                  // Desktop: 3 left, 3 right
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                child: _buildSkillCard(
                                                  index + 3,
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
                color: Theme.of(context).colorScheme.surface,
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
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              skill['description'] as String,
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
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

class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final strokePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    // 1. Cluster (Top Right)
    // Replaced Triangle with Code Syntax Shape < /> and Hollow Hexagon

    // Code Syntax < />
    final codeSlashPaint =
        Paint()
          ..color = AppColors.primaryGreen.withOpacity(0.78)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final codeSlashPath = Path();
    // <
    codeSlashPath.moveTo(size.width * 0.88, size.height * 0.18);
    codeSlashPath.lineTo(size.width * 0.87, size.height * 0.20);
    codeSlashPath.lineTo(size.width * 0.88, size.height * 0.22);
    // /
    codeSlashPath.moveTo(size.width * 0.89, size.height * 0.22);
    codeSlashPath.lineTo(size.width * 0.91, size.height * 0.18);
    // >
    codeSlashPath.moveTo(size.width * 0.92, size.height * 0.18);
    codeSlashPath.lineTo(size.width * 0.93, size.height * 0.20);
    codeSlashPath.lineTo(size.width * 0.92, size.height * 0.22);

    canvas.drawPath(codeSlashPath, codeSlashPaint);

    // Small Hollow Pentagon
    _drawPolygon(
      canvas,
      Offset(size.width * 0.94, size.height * 0.15),
      12,
      5, // Pentagon
      AppColors.primaryGreen.withOpacity(0.67),
      false,
    );

    // Added Shape: Small Circle near triangle
    paint.shader = null;
    paint.color = AppColors.primaryGreen.withOpacity(0.49);
    canvas.drawCircle(Offset(size.width * 0.92, size.height * 0.12), 4, paint);

    // Added Shape: Cross near triangle
    _drawCross(
      canvas,
      Offset(size.width * 0.8, size.height * 0.18),
      8,
      AppColors.primaryGreen.withOpacity(0.40),
    );

    // 2. Hollow Hexagon (Bottom Left)
    final center2 = Offset(size.width * 0.1, size.height * 0.92);

    // Simplifed Polygon (Hexagon-ish)
    final hexPath = Path();
    hexPath.moveTo(center2.dx + 40, center2.dy);
    hexPath.lineTo(center2.dx + 20, center2.dy + 35);
    hexPath.lineTo(center2.dx - 20, center2.dy + 35);
    hexPath.lineTo(center2.dx - 40, center2.dy);
    hexPath.lineTo(center2.dx - 20, center2.dy - 35);
    hexPath.lineTo(center2.dx + 20, center2.dy - 35);
    hexPath.close();

    strokePaint.color = AppColors.primaryGreen.withOpacity(0.5);
    canvas.drawPath(hexPath, strokePaint);

    // 3. Scattered Shapes (Significantly Increased Count & Distribution)

    // --- LEFT SIDE ---
    _drawCross(
      canvas,
      Offset(size.width * 0.05, size.height * 0.2),
      12,
      AppColors.primaryGreen.withOpacity(0.3),
    );
    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.25),
      4,
      paint..color = AppColors.primaryGreen.withOpacity(0.4),
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.12, size.height * 0.4),
      8,
      AppColors.primaryGreen.withOpacity(0.25),
      false,
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.04, size.height * 0.6),
      10,
      AppColors.primaryGreen.withOpacity(0.35),
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.8),
      6,
      paint..color = AppColors.primaryGreen.withOpacity(0.2),
    );

    // --- RIGHT SIDE ---
    _drawCross(
      canvas,
      Offset(size.width * 0.95, size.height * 0.3),
      14,
      AppColors.primaryGreen.withOpacity(0.3),
    );
    canvas.drawCircle(
      Offset(size.width * 0.92, size.height * 0.45),
      8,
      paint..color = AppColors.primaryGreen.withOpacity(0.25),
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.96, size.height * 0.65),
      10,
      AppColors.primaryGreen.withOpacity(0.3),
      true,
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.9, size.height * 0.85),
      12,
      AppColors.primaryGreen.withOpacity(0.4),
    );

    // --- TOP AREA ---
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.05),
      5,
      paint..color = AppColors.primaryGreen.withOpacity(0.3),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.5, size.height * 0.08),
      10,
      AppColors.primaryGreen.withOpacity(0.25),
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.7, size.height * 0.06),
      6,
      AppColors.primaryGreen.withOpacity(0.35),
      false,
    );

    // --- BOTTOM AREA ---
    _drawCross(
      canvas,
      Offset(size.width * 0.2, size.height * 0.95),
      10,
      AppColors.primaryGreen.withOpacity(0.3),
    );
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.92),
      7,
      paint..color = AppColors.primaryGreen.withOpacity(0.2),
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.6, size.height * 0.96),
      9,
      AppColors.primaryGreen.withOpacity(0.28),
      true,
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.8, size.height * 0.93),
      12,
      AppColors.primaryGreen.withOpacity(0.32),
    );

    // --- CENTER/RANDOM SCATTER (Existing logic, slightly adjusted) ---
    _drawCross(
      canvas,
      Offset(size.width * 0.15, size.height * 0.2),
      15,
      AppColors.primaryGreen.withOpacity(0.25),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.5, size.height * 0.85),
      12,
      AppColors.primaryGreen.withOpacity(0.6),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.35, size.height * 0.45),
      8,
      AppColors.primaryGreen.withOpacity(0.50),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.75, size.height * 0.15),
      14,
      AppColors.primaryGreen.withOpacity(0.70),
    );

    // Filled Circles
    paint.shader = null;
    paint.color = AppColors.primaryGreen.withOpacity(0.4);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.15), 6, paint);

    paint.color = AppColors.primaryGreen.withOpacity(0.58);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 18, paint);

    paint.color = AppColors.primaryGreen.withOpacity(0.40);
    canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.65), 4, paint);

    // Hollow Circles
    strokePaint.color = AppColors.primaryGreen.withOpacity(0.69);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.8),
      25,
      strokePaint,
    );

    strokePaint.color = AppColors.primaryGreen.withOpacity(0.78);
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.3),
      15,
      strokePaint,
    );

    // Diamond - Moved to Right of Bottom Center
    _drawDiamond(
      canvas,
      Offset(size.width * 0.7, size.height * 0.92), // Moved from 0.5 to 0.7
      15,
      AppColors.primaryGreen.withOpacity(0.45),
      true,
    );

    // 5. Connecting Lines
    final linePaint =
        Paint()
          ..color = AppColors.primaryGreen.withOpacity(0.3) // Reduced opacity
          ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.2),
      Offset(size.width * 0.25, size.height * 0.3),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.8),
      Offset(size.width * 0.9, size.height * 0.6),
      linePaint,
    );
    // New Lines
    canvas.drawLine(
      Offset(size.width * 0.05, size.height * 0.5),
      Offset(size.width * 0.12, size.height * 0.4),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.92, size.height * 0.45),
      Offset(size.width * 0.96, size.height * 0.65),
      linePaint,
    );
  }

  void _drawCross(Canvas canvas, Offset center, double size, Color color) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx - size / 2, center.dy),
      Offset(center.dx + size / 2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - size / 2),
      Offset(center.dx, center.dy + size / 2),
      paint,
    );
  }

  void _drawDiamond(
    Canvas canvas,
    Offset center,
    double size,
    Color color,
    bool filled,
  ) {
    final paint =
        Paint()
          ..color = color
          ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = filled ? 0 : 1.5;

    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx + size, center.dy);
    path.lineTo(center.dx, center.dy + size);
    path.lineTo(center.dx - size, center.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawPolygon(
    Canvas canvas,
    Offset center,
    double radius,
    int sides,
    Color color,
    bool filled,
  ) {
    if (sides < 3) return;

    final paint =
        Paint()
          ..color = color
          ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = filled ? 0 : 1.5;

    final path = Path();
    final angle = (math.pi * 2) / sides;

    // Start from top (-90 degrees) or right (0 degrees)
    // Using top (-90) for standard orientation
    final startAngle = -math.pi / 2;

    for (int i = 0; i < sides; i++) {
      double currentAngle = startAngle + (angle * i);
      double x = center.dx + radius * math.cos(currentAngle);
      double y = center.dy + radius * math.sin(currentAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

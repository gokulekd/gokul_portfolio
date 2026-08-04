import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/skill_icons.dart';
import '../../models/firebase_content_models.dart';
import 'skills_components.dart';

class SkillsSection extends ConsumerStatefulWidget {
  final ScrollController? scrollController;

  const SkillsSection({super.key, this.scrollController});

  @override
  ConsumerState<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends ConsumerState<SkillsSection>
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
  int _cardCount = 0;

  @override
  void initState() {
    super.initState();
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

  /// Card controllers are sized to the skills list, which can change once
  /// the admin edits it. Rebuild the pool whenever the count changes instead
  /// of assuming a fixed length like the old hardcoded 6-item list did.
  void _ensureCardControllers(int count) {
    if (count == _cardCount) return;
    for (final controller in _cardControllers) {
      controller.dispose();
    }
    _cardControllers.clear();
    _cardAnimations.clear();
    _visibleCards.clear();
    for (int i = 0; i < count; i++) {
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
    _cardCount = count;
    if (_isSectionVisible) _animateCardsSequentially();
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
    for (int i = 0; i < _cardCount; i++) {
      if (!_visibleCards.contains(i)) {
        Future.delayed(Duration(milliseconds: 100 * i), () {
          if (mounted && i < _cardControllers.length) {
            setState(() {
              _visibleCards.add(i);
            });
            _cardControllers[i].forward();
          }
        });
      }
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
    final skills = ref.watch(portfolioProvider.select((s) => s.visibleSkills));
    _ensureCardControllers(skills.length);

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
                    child: CustomPaint(painter: SkillsBackgroundPainter()),
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
                                // Cards: single column on mobile, split into
                                // two balanced columns on desktop.
                                if (skills.isEmpty)
                                  const SizedBox.shrink()
                                else if (isNarrow)
                                  Column(
                                    children: [
                                      for (int index = 0; index < skills.length; index++)
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom: index < skills.length - 1 ? 20 : 0,
                                          ),
                                          child: _buildSkillCard(index, skills[index]),
                                        ),
                                    ],
                                  )
                                else
                                  Builder(
                                    builder: (context) {
                                      final leftCount = (skills.length / 2).ceil();
                                      final leftSkills = skills.take(leftCount).toList();
                                      final rightSkills = skills.skip(leftCount).toList();
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                for (int i = 0; i < leftSkills.length; i++)
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: i < leftSkills.length - 1 ? 20 : 0,
                                                    ),
                                                    child: _buildSkillCard(i, leftSkills[i]),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          if (rightSkills.isNotEmpty) ...[
                                            const SizedBox(width: 24),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  for (int i = 0; i < rightSkills.length; i++)
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom: i < rightSkills.length - 1 ? 20 : 0,
                                                      ),
                                                      child: _buildSkillCard(
                                                        leftCount + i,
                                                        rightSkills[i],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      );
                                    },
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

  Widget _buildSkillCard(int index, SkillItem skill) {
    if (index < 0 || index >= _cardAnimations.length) {
      return const SizedBox.shrink();
    }

    final animation = _cardAnimations[index];
    final isVisible = _visibleCards.contains(index);
    final percentage = skill.percent;
    final color = AppColors.skillsGreen;
    final icon = iconForSkillKey(skill.iconKey);

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
                    color: Colors.black.withValues(alpha: 0.05),
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
                          icon,
                          color: color,
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
                              skill.name,
                              style: GoogleFonts.manrope(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              skill.description,
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
                  // Progress bar with percentage circle at the end
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = constraints.maxWidth;
                      const circleSize = 32.0;

                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: isVisible ? percentage / 100.0 : 0,
                        ),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOutQuart,
                        builder: (context, value, _) {
                          final fillWidth = cardWidth * value;
                          final circleLeft = (fillWidth - circleSize / 2).clamp(0.0, cardWidth - circleSize);

                          return SizedBox(
                            height: circleSize,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Background track
                                Positioned(
                                  top: (circleSize - 8) / 2,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                // Green fill
                                Positioned(
                                  top: (circleSize - 8) / 2,
                                  left: 0,
                                  child: Container(
                                    width: fillWidth,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                // Circle at the end of the green fill
                                if (fillWidth > 0)
                                  Positioned(
                                    left: circleLeft,
                                    top: 0,
                                    child: Container(
                                      width: circleSize,
                                      height: circleSize,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$percentage%',
                                        style: GoogleFonts.manrope(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
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

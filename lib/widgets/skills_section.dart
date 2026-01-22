import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with TickerProviderStateMixin {
  late AnimationController _skillsController;
  late AnimationController _cardAnimationController;

  late Animation<double> _skillsOpacity;
  late Animation<Offset> _skillsSlide;

  int _currentCardIndex = 0;
  final GlobalKey _skillsSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Start the animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _skillsController.forward();
        _cardAnimationController.forward();
      }
    });
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

    // Card animation controller
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _skillsController.dispose();
    _cardAnimationController.dispose();
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.grey[50]!],
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 900;

                  final leftColumn = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      Text(
                        "My Skills & Creative Toolbox",
                        style: GoogleFonts.manrope(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Technologies I work with to bring ideas to life",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Skill indicators
                      ...List.generate(6, (index) {
                        return _buildSkillIndicator(index);
                      }),
                    ],
                  );

                  final rightColumn = SizedBox(
                    height: 400,
                    child: Center(
                      child: _buildActiveSkillCard(_currentCardIndex),
                    ),
                  );

                  if (isNarrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        leftColumn,
                        const SizedBox(height: 40),
                        rightColumn,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 1, child: leftColumn),
                      const SizedBox(width: 60),
                      Expanded(flex: 1, child: rightColumn),
                    ],
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
      'name': 'Dart',
      'percentage': 90,
      'color': const Color(0xFF0175C2),
      'icon': Icons.code,
    },
    {
      'name': 'Flutter',
      'percentage': 85,
      'color': const Color(0xFF02569B),
      'icon': Icons.phone_android,
    },
    {
      'name': 'Figma',
      'percentage': 80,
      'color': const Color(0xFFF24E1E),
      'icon': Icons.design_services,
    },
    {
      'name': 'HTML',
      'percentage': 75,
      'color': const Color(0xFFE34F26),
      'icon': Icons.language,
    },
    {
      'name': 'CSS',
      'percentage': 70,
      'color': const Color(0xFF1572B6),
      'icon': Icons.palette,
    },
    {
      'name': 'JavaScript',
      'percentage': 65,
      'color': const Color(0xFFF7DF1E),
      'icon': Icons.javascript,
    },
  ];

  Widget _buildSkillIndicator(int index) {
    if (index < 0 || index >= _skills.length) {
      return const SizedBox.shrink();
    }

    final skill = _skills[index];
    final isActive = index == _currentCardIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentCardIndex = index;
        });
        _cardAnimationController.reset();
        _cardAnimationController.forward();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? skill['color'] as Color : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? skill['color'] as Color : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              skill['icon'] as IconData,
              color: isActive ? Colors.white : skill['color'] as Color,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                skill['name'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${skill['percentage']}%',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : skill['color'] as Color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSkillCard(int index) {
    if (index < 0 || index >= _skills.length) {
      return const SizedBox.shrink();
    }

    final skill = _skills[index];

    return Container(
      width: 320,
      height: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: (skill['color'] as Color).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (skill['color'] as Color).withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Skill Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: (skill['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                skill['icon'] as IconData,
                size: 40,
                color: skill['color'] as Color,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              skill['name'] as String,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${skill['percentage']}%',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: skill['color'] as Color,
              ),
            ),
            const SizedBox(height: 24),
            // Progress Bar
            Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeOutQuart,
                width: (320 * (skill['percentage'] as int) / 100) - 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (skill['color'] as Color).withOpacity(0.8),
                      skill['color'] as Color,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: (skill['color'] as Color).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
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

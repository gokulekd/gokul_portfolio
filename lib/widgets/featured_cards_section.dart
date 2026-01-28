import 'package:flutter/material.dart';
import 'package:gokul_portfolio/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class FeaturedCard {
  final String number;
  final String description;
  final Color backgroundColor;
  final Color textColor;
  final Color numberColor;
  final Widget icon;

  const FeaturedCard({
    required this.number,
    required this.description,
    required this.backgroundColor,
    required this.textColor,
    required this.numberColor,
    required this.icon,
  });
}

class FeaturedCardsSection extends StatelessWidget {
  const FeaturedCardsSection({super.key});

  static final List<FeaturedCard> _cards = [
    FeaturedCard(
      number: "95+",
      description: "Percent customer satisfaction",
      backgroundColor: AppColors.darkGreen,
      textColor: Color(0xFF374151), // Dark grey
      numberColor: Colors.white,
      icon: _SatisfactionIcon(),
    ),
    FeaturedCard(
      number: "2+",
      description: "Years of experience",
      backgroundColor: Color(0xFF1F2937), // Dark grey/charcoal
      textColor: Colors.white,
      numberColor: Colors.white,
      icon: _ExperienceIcon(),
    ),
    FeaturedCard(
      number: "3+",
      description: "Projects completed",
      backgroundColor: Colors.white,
      textColor: Colors.black,
      numberColor: Colors.black,
      icon: _ProjectsIcon(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 0,
      ),
      color: Colors.black,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48),
            child:
                isMobile
                    ? Column(
                      children:
                          _cards
                              .map(
                                (card) => Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: _buildCard(card, context),
                                ),
                              )
                              .toList(),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          _cards
                              .map(
                                (card) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: _buildCard(card, context),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(FeaturedCard card, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: card.backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.number,
            style: GoogleFonts.manrope(
              fontSize: 56,
              fontWeight: FontWeight.w800,
              color: card.numberColor,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(height: 80, width: double.infinity, child: card.icon),
          const SizedBox(height: 24),
          Text(
            card.description,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: card.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Icon for Customer Satisfaction - semi-circular arc
class _SatisfactionIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ArcPainter(
        color: const Color(0xFF65A30D), // Slightly lighter green
      ),
      size: const Size(double.infinity, 80),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final Color color;

  _ArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.3,
      size.width,
      size.height,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Icon for Years of Experience - abstract peak/mountain shape
class _ExperienceIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PeakPainter(
        color: const Color(0xFF374151), // Dark grey
      ),
      size: const Size(double.infinity, 80),
    );
  }
}

class _PeakPainter extends CustomPainter {
  final Color color;

  _PeakPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height);
    path.lineTo(size.width * 0.3, size.height * 0.4);
    path.lineTo(size.width * 0.5, size.height * 0.6);
    path.lineTo(size.width * 0.7, size.height * 0.3);
    path.lineTo(size.width * 0.9, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Icon for Projects Completed - arrow pointing right
class _ProjectsIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ArrowPainter(
        color: const Color(0xFFD1D5DB), // Light grey
      ),
      size: const Size(double.infinity, 80),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;

  _ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Draw arrow pointing right with multiple segments
    final path = Path();
    final segmentWidth = size.width / 4;
    final arrowHeight = size.height * 0.5;
    final baseY = size.height * 0.75;

    // Arrow body segments
    for (int i = 0; i < 3; i++) {
      final x = i * segmentWidth;
      final height = arrowHeight * (0.6 + (i * 0.2));
      path.addRect(
        Rect.fromLTWH(x, baseY - height, segmentWidth * 0.8, height),
      );
    }

    // Arrow head
    path.moveTo(size.width * 0.6, baseY);
    path.lineTo(size.width * 0.9, baseY - arrowHeight * 0.5);
    path.lineTo(size.width * 0.9, baseY);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

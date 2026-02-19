import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gokul_portfolio/constants/colors.dart';
import 'package:gokul_portfolio/controllers/portfolio_controller.dart';
import 'package:gokul_portfolio/routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementCard {
  final String number;
  final String description;
  final Color backgroundColor;
  final Color textColor;
  final Color numberColor;
  final Widget icon;

  const AchievementCard({
    required this.number,
    required this.description,
    required this.backgroundColor,
    required this.textColor,
    required this.numberColor,
    required this.icon,
  });
}

class ProudAchievementsSection extends StatelessWidget {
  const ProudAchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final List<AchievementCard> cards = [
      AchievementCard(
        number: "95+",
        description: "Percent customer satisfaction",
        backgroundColor: AppColors.primaryGreen,
        textColor: const Color(0xFF374151), // Dark grey
        numberColor: Colors.black,
        icon: _SatisfactionIcon(color: Colors.black),
      ),
      AchievementCard(
        number: "2+",
        description: "Years of experience",
        backgroundColor: const Color(0xFF1F2937), // Dark grey/charcoal
        textColor: Colors.white,
        numberColor: Colors.white,
        icon: _ExperienceIcon(color: AppColors.primaryGreen),
      ),
      AchievementCard(
        number: "3+",
        description: "Projects completed",
        backgroundColor: Colors.white,
        textColor: Colors.black,
        numberColor: Colors.black,
        icon: _ProjectsIcon(color: Colors.black),
      ),
    ];

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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "{03} - Proud Achievements",
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.skillsGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                if (isMobile)
                  Column(
                    children:
                        cards
                            .map(
                              (card) => Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: _buildCard(card, context),
                              ),
                            )
                            .toList(),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        cards
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
                const SizedBox(height: 100),
                _buildPrinciples(isMobile),
                const SizedBox(height: 100),
                _buildCta(isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrinciples(bool isMobile) {
    final principles = [
      _PrincipleItem(
        title: "User-Centric",
        description:
            "I prioritize the end-user's experience, ensuring intuitive and engaging interfaces.",
        icon: Icons.people_outline,
      ),
      _PrincipleItem(
        title: "Clean Code",
        description:
            "Building scalable and maintainable codebases that grow with your business.",
        icon: Icons.code,
      ),
      _PrincipleItem(
        title: "Fast Delivery",
        description:
            "Efficient workflows and rapid prototyping to get your product to market sooner.",
        icon: Icons.speed,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "My Guiding Principles",
          style: GoogleFonts.manrope(
            fontSize: isMobile ? 32 : 48,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "I believe that great software is built on a foundation of clear communication and technical excellence.",
          style: GoogleFonts.manrope(
            fontSize: 18,
            color: Colors.grey[400],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 48),
        if (isMobile)
          Column(
            children:
                principles
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: _buildPrincipleCard(item),
                      ),
                    )
                    .toList(),
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                principles
                    .map(
                      (item) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _buildPrincipleCard(item),
                        ),
                      ),
                    )
                    .toList(),
          ),
      ],
    );
  }

  Widget _buildPrincipleCard(_PrincipleItem item) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: AppColors.primaryGreen, size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            item.title,
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.description,
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: Colors.grey[400],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(AchievementCard card, BuildContext context) {
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

  Widget _buildCta(bool isMobile) {
    return Column(
      children: [
        Text(
          'I blend creativity with technical expertise',
          style: GoogleFonts.manrope(
            fontSize: isMobile ? 36 : 40,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () {
            final controller = Get.find<PortfolioController>();
            controller.changePage(5);
            Get.offNamed(AppRoutes.contact);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 40 : 64,
              vertical: isMobile ? 20 : 28,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Text(
            'Become a client',
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// Icon for Customer Satisfaction - Stylized Heart/Smile with particles
class _SatisfactionIcon extends StatelessWidget {
  final Color color;

  const _SatisfactionIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SatisfactionPainter(color: color),
      size: const Size(double.infinity, 80),
    );
  }
}

class _SatisfactionPainter extends CustomPainter {
  final Color color;

  _SatisfactionPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

    final fillPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Use the shortest side (height in this case as width is usually larger)
    // to maintain aspect ratio
    final sizeRef = size.height;
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Main Face Outline (Abstract Blob or Circle)
    final facePath = Path();
    facePath.addOval(
      Rect.fromCenter(
        center: center,
        width: sizeRef * 0.9,
        height: sizeRef * 0.9,
      ),
    );

    // Draw subtle gradient fill for the face background
    final bgPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.0)],
          ).createShader(
            Rect.fromCircle(center: center, radius: sizeRef * 0.45),
          )
          ..style = PaintingStyle.fill;

    canvas.drawPath(facePath, bgPaint);
    canvas.drawPath(facePath, strokePaint);

    // 2. Left Eye (Solid Circle)
    // Position relative to center
    canvas.drawCircle(
      Offset(center.dx - sizeRef * 0.15, size.height * 0.4),
      6,
      fillPaint,
    );

    // 3. Right Eye (Winking Star/Diamond)
    final starPath = Path();
    final starCenter = Offset(center.dx + sizeRef * 0.15, size.height * 0.4);
    final radius = 10.0;

    starPath.moveTo(starCenter.dx, starCenter.dy - radius); // Top
    starPath.quadraticBezierTo(
      starCenter.dx + 2,
      starCenter.dy - 2,
      starCenter.dx + radius,
      starCenter.dy,
    ); // Right
    starPath.quadraticBezierTo(
      starCenter.dx + 2,
      starCenter.dy + 2,
      starCenter.dx,
      starCenter.dy + radius,
    ); // Bottom
    starPath.quadraticBezierTo(
      starCenter.dx - 2,
      starCenter.dy + 2,
      starCenter.dx - radius,
      starCenter.dy,
    ); // Left
    starPath.quadraticBezierTo(
      starCenter.dx - 2,
      starCenter.dy - 2,
      starCenter.dx,
      starCenter.dy - radius,
    ); // Back to Top

    canvas.drawPath(starPath, fillPaint);

    // 4. Smile (Confident Curve)
    final smilePath = Path();
    smilePath.moveTo(center.dx - sizeRef * 0.2, size.height * 0.65);
    smilePath.quadraticBezierTo(
      center.dx,
      size.height * 0.85,
      center.dx + sizeRef * 0.2,
      size.height * 0.65,
    );
    canvas.drawPath(smilePath, strokePaint..strokeWidth = 4);

    // 5. Orbiting Decoration (Satellite)
    canvas.drawCircle(
      Offset(center.dx + sizeRef * 0.35, size.height * 0.15),
      4,
      fillPaint..color = color.withOpacity(0.6),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Icon for Years of Experience - Rising Curve / Growth
class _ExperienceIcon extends StatelessWidget {
  final Color color;

  const _ExperienceIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GrowthPainter(color: color),
      size: const Size(double.infinity, 80),
    );
  }
}

class _GrowthPainter extends CustomPainter {
  final Color color;

  _GrowthPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [color.withOpacity(0.4), color.withOpacity(0.0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;

    // Smooth rising curve
    final path = Path();
    path.moveTo(0, size.height * 0.9);
    path.cubicTo(
      size.width * 0.3,
      size.height * 0.9,
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.cubicTo(
      size.width * 0.7,
      size.height * 0.5,
      size.width * 0.7,
      size.height * 0.1,
      size.width,
      size.height * 0.1,
    );

    // Draw the line
    canvas.drawPath(path, strokePaint);

    // Draw fill below the line
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Add nodes/milestones
    final nodePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      5,
      nodePaint,
    );
    canvas.drawCircle(Offset(size.width, size.height * 0.1), 6, nodePaint);

    // Abstract halo around top node
    final haloPaint =
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    canvas.drawCircle(Offset(size.width, size.height * 0.1), 12, haloPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Icon for Projects Completed - Geometric Construction
class _ProjectsIcon extends StatelessWidget {
  final Color color;

  const _ProjectsIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CheckPainter(color: color),
      size: const Size(double.infinity, 80),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final Color color;

  _CheckPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    // Constrain dimensions to maintain aspect ratio
    final ref = size.height;
    final cx = size.width / 2;

    // Draw stacked floating layers (Interfaces)
    // Using simple scalars on 'ref' to keep shapes proportional

    // Layer 3 (Bottom)
    _drawLayer(
      canvas,
      Offset(cx, size.height * 0.75),
      ref * 1.0,
      ref * 0.6,
      fillPaint..color = color.withOpacity(0.1),
      null,
    );

    // Layer 2 (Middle)
    _drawLayer(
      canvas,
      Offset(cx, size.height * 0.6),
      ref * 1.2,
      ref * 0.6,
      fillPaint..color = color.withOpacity(0.2),
      strokePaint..color = color.withOpacity(0.3),
    );

    // Layer 1 (Top - Focus)
    final topLayerCenter = Offset(cx, size.height * 0.45);
    _drawLayer(
      canvas,
      topLayerCenter,
      ref * 1.4,
      ref * 0.7,
      fillPaint..color = color.withOpacity(0.05), // Glassy hook
      strokePaint
        ..color = color
        ..strokeWidth = 3,
    );

    // Content on Top Layer (Project "Hero" Section + Button)
    // Actually, let's draw a symbol ON the top layer
    final symbolPath = Path();
    symbolPath.moveTo(topLayerCenter.dx - 15, topLayerCenter.dy - 10);
    symbolPath.lineTo(topLayerCenter.dx - 5, topLayerCenter.dy + 5);
    symbolPath.lineTo(topLayerCenter.dx + 15, topLayerCenter.dy - 15);

    canvas.drawPath(symbolPath, strokePaint..strokeWidth = 4);

    // A small "circle" dot to the left
    canvas.drawCircle(
      Offset(topLayerCenter.dx - 30, topLayerCenter.dy - 30),
      3,
      fillPaint..color = color,
    );
    canvas.drawCircle(
      Offset(topLayerCenter.dx - 20, topLayerCenter.dy - 30),
      3,
      fillPaint..color = color,
    );
  }

  void _drawLayer(
    Canvas canvas,
    Offset center,
    double width,
    double height,
    Paint fill,
    Paint? stroke,
  ) {
    // Drawing an isometric-like plane
    final path = Path();
    final halfW = width / 2;
    final halfH = height / 2;

    // Slight perspective skew
    path.moveTo(center.dx - halfW, center.dy); // Left
    path.lineTo(center.dx, center.dy - halfH * 0.6); // Top
    path.lineTo(center.dx + halfW, center.dy); // Right
    path.lineTo(center.dx, center.dy + halfH * 0.6); // Bottom
    path.close();

    canvas.drawPath(path, fill);
    if (stroke != null) {
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PrincipleItem {
  final String title;
  final String description;
  final IconData icon;

  const _PrincipleItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

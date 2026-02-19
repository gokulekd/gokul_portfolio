import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../controllers/portfolio_controller.dart';
import '../routes/app_routes.dart';
import '../utils/responsive_helper.dart';

class SelectedProjectsSection extends StatelessWidget {
  const SelectedProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          // Background Painting - Now guaranteed to cover full width
          Positioned.fill(child: CustomPaint(painter: _BackgroundPainter())),

          // Main Content Wrapper
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "{02} - Selected Work",
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            color: Colors.black,
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

                    // Title
                    Text(
                      "Featured Projects",
                      style: GoogleFonts.manrope(
                        fontSize: isMobile ? 40 : 60,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),

                    // Projects List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2, // Show only top 2
                      separatorBuilder:
                          (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey[200],
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: AppColors.primaryGreen,
                                        width: 2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey[200],
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      itemBuilder: (context, index) {
                        if (index >= controller.projects.length) {
                          return const SizedBox.shrink();
                        }
                        final project = controller.projects[index];
                        return _FeaturedProjectCard(
                          title: project.title,
                          description: project.description,
                          imageUrl: project.imageUrl,
                          technologies: project.technologies,
                          githubUrl: project.githubUrl,
                          liveUrl: project.liveUrl,
                          isReversed: index % 2 != 0, // Alternate layout
                        );
                      },
                    ),

                    const SizedBox(height: 60),

                    // View All Button
                    ElevatedButton(
                      onPressed: () {
                        controller.changePage(3);
                        Get.offNamed(AppRoutes.projects);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 40 : 64,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "View All Projects",
                            style: GoogleFonts.manrope(
                              fontSize: isMobile ? 18 : 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String? githubUrl;
  final String? liveUrl;
  final bool isReversed;

  const _FeaturedProjectCard({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    this.githubUrl,
    this.liveUrl,
    this.isReversed = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final bool useVerticalLayout = isMobile || isTablet;

    // Content Widget
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.w800,
            color: Colors.black, // Black text
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Text(
            description,
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              technologies
                  .map(
                    (tech) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        tech,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            if (githubUrl != null)
              _ActionButton(
                icon: FontAwesomeIcons.github,
                label: "Code",
                onTap: () => controller.launchUrlFromString(githubUrl!),
              ),
            if (githubUrl != null && liveUrl != null) const SizedBox(width: 16),
          ],
        ),
      ],
    );

    // Image Widget
    final image = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.15),
            offset: const Offset(0, 20),
            blurRadius: 40,
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  color: const Color(0xFF1F2937),
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.grey, size: 50),
                  ),
                ),
          ),
        ),
      ),
    );

    if (useVerticalLayout) {
      return Column(children: [image, const SizedBox(height: 32), content]);
    }

    // Desktop Layout (Alternating)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isReversed) ...[
          Expanded(flex: 6, child: content),
          const SizedBox(width: 48),
          Expanded(flex: 7, child: image),
        ] else ...[
          Expanded(flex: 7, child: image),
          const SizedBox(width: 48),
          Expanded(flex: 6, child: content),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border:
              isPrimary
                  ? null
                  : Border.all(color: Colors.black.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.black, // Always black
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black, // Always black
              ),
            ),
          ],
        ),
      ),
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

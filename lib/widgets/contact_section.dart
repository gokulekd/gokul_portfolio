import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import '../controllers/portfolio_controller.dart';

class SocialPlatform {
  final String name;
  final String url;
  final Widget icon;

  const SocialPlatform({
    required this.name,
    required this.url,
    required this.icon,
  });
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  List<SocialPlatform> _buildPlatforms(PortfolioController controller) {
    String urlFor(String platform) =>
        controller.getSocialLink(platform)?.url ?? '';

    return [
      SocialPlatform(
        name: "Twitter/X",
        url: urlFor('Twitter'),
        icon: const FaIcon(
          FontAwesomeIcons.xTwitter,
          color: Colors.black,
          size: 22,
        ),
      ),
      SocialPlatform(
        name: "GitHub",
        url: urlFor('GitHub'),
        icon: const FaIcon(
          FontAwesomeIcons.github,
          color: Colors.black,
          size: 22,
        ),
      ),
      SocialPlatform(
        name: "LinkedIn",
        url: urlFor('LinkedIn'),
        icon: const FaIcon(
          FontAwesomeIcons.linkedinIn,
          color: Colors.black,
          size: 22,
        ),
      ),
      SocialPlatform(
        name: "Medium",
        url: urlFor('Medium'),
        icon: const FaIcon(
          FontAwesomeIcons.medium,
          color: Colors.black,
          size: 22,
        ),
      ),
      SocialPlatform(
        name: "Instagram",
        url: urlFor('Instagram'),
        icon: const FaIcon(
          FontAwesomeIcons.instagram,
          color: Colors.black,
          size: 22,
        ),
      ),
    ];
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Obx(() {
      final platforms = _buildPlatforms(controller);

      return Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Dark almost black background
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned.fill(child: CustomPaint(painter: _BackgroundPainter())),
            // Main content
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 80,
                horizontal: isMobile ? 24 : 0,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 48,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Section identifier
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "{07} – Contact me",
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Main title
                        Text(
                          "I'm all over the internet",
                          style: GoogleFonts.manrope(
                            fontSize: isMobile ? 40 : 60,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Social cards grid
                        isMobile
                            ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[0],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[1],
                                        context,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[2],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[3],
                                        context,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[4],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildGetInTouchCard(context),
                                    ),
                                  ],
                                ),
                              ],
                            )
                            : Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[0],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[1],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[2],
                                        context,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[3],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[4],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 2,
                                      child: _buildGetInTouchCard(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSocialCard(SocialPlatform platform, BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(platform.url),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF171717),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Platform name
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                platform.name,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            // Icon in bottom-right
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Center(child: platform.icon),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGetInTouchCard(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    return InkWell(
      onTap:
          () => controller.launchEmail(
            subject: 'Let\'s work together!',
            body:
                'Hi Gokul,\n\nI came across your portfolio and would love to discuss a project with you.\n\n',
          ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: const Color(0xFF171717),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.skillsGreen.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Creative Background Painting
              Positioned.fill(
                child: CustomPaint(painter: _CreativeCardPainter()),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Stack(
                  children: [
                    // Text
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Get in touch",
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Arrow icon in bottom-right
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for background decorative elements - From Footer
// Custom painter for background decorative elements - From Footer
class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final strokePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    // 1. Cluster (Top Right)
    // Smaller Triangle
    final path1 =
        Path()
          ..moveTo(size.width * 0.88, size.height * 0.15)
          ..lineTo(size.width * 0.94, size.height * 0.22)
          ..lineTo(size.width * 0.82, size.height * 0.25)
          ..close();

    paint.shader = LinearGradient(
      colors: [
        AppColors.primaryGreen.withValues(alpha: 0.1), // Reduced from 0.25
        AppColors.primaryGreen.withValues(alpha: 0.35), // Reduced from 0.8
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path1, paint);

    // Added Shape: Small Circle near triangle
    paint.shader = null;
    paint.color = AppColors.primaryGreen.withValues(
      alpha: 0.12,
    ); // Reduced from 0.3
    canvas.drawCircle(Offset(size.width * 0.92, size.height * 0.12), 4, paint);

    // Added Shape: Cross near triangle
    _drawCross(
      canvas,
      Offset(size.width * 0.8, size.height * 0.18),
      8,
      AppColors.primaryGreen.withValues(alpha: 0.15), // Reduced from 0.4
    );

    // 2. Hollow Hexagon (Bottom Left)
    final center2 = Offset(size.width * 0.15, size.height * 0.75);

    // Simplifed Polygon (Hexagon-ish)
    final hexPath = Path();
    hexPath.moveTo(center2.dx + 40, center2.dy);
    hexPath.lineTo(center2.dx + 20, center2.dy + 35);
    hexPath.lineTo(center2.dx - 20, center2.dy + 35);
    hexPath.lineTo(center2.dx - 40, center2.dy);
    hexPath.lineTo(center2.dx - 20, center2.dy - 35);
    hexPath.lineTo(center2.dx + 20, center2.dy - 35);
    hexPath.close();

    strokePaint.color = AppColors.primaryGreen.withValues(
      alpha: 0.15,
    ); // Reduced from 0.35
    canvas.drawPath(hexPath, strokePaint);

    // 3. Scattered Shapes (Increased Count)

    // Crosses
    _drawCross(
      canvas,
      Offset(size.width * 0.15, size.height * 0.2),
      15,
      AppColors.primaryGreen.withValues(alpha: 0.25), // Reduced
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.9, size.height * 0.6),
      10,
      AppColors.primaryGreen.withValues(alpha: 0.2), // Reduced
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.5, size.height * 0.85),
      12,
      AppColors.primaryGreen.withValues(alpha: 0.2), // Reduced
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.35, size.height * 0.45),
      8,
      AppColors.primaryGreen.withValues(alpha: 0.22), // Reduced
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.75, size.height * 0.15),
      14,
      AppColors.primaryGreen.withValues(alpha: 0.18), // Reduced
    );

    // Filled Circles
    paint.shader = null;
    paint.color = AppColors.primaryGreen.withValues(alpha: 0.15); // Reduced
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.15), 6, paint);

    paint.color = AppColors.primaryGreen.withValues(alpha: 0.12); // Reduced
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 18, paint);

    paint.color = AppColors.primaryGreen.withValues(alpha: 0.18); // Reduced
    canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.65), 4, paint);

    // Hollow Circles
    strokePaint.color = AppColors.primaryGreen.withValues(
      alpha: 0.18,
    ); // Reduced
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.8),
      25,
      strokePaint,
    );

    strokePaint.color = AppColors.primaryGreen.withValues(
      alpha: 0.15,
    ); // Reduced
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.3),
      15,
      strokePaint,
    );

    // Diamond - Moved to Bottom
    _drawDiamond(
      canvas,
      Offset(size.width * 0.5, size.height * 0.9),
      15,
      AppColors.primaryGreen.withValues(alpha: 0.2), // Reduced
      true,
    );

    // 5. Connecting Lines
    final linePaint =
        Paint()
          ..color = AppColors.primaryGreen.withValues(alpha: 0.12) // Reduced
          ..strokeWidth = 1.5;

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
    // 6. Additional Scattered Shapes (High Density)

    // More Triangles
    _drawTriangle(
      canvas,
      Offset(size.width * 0.1, size.height * 0.4),
      15,
      AppColors.primaryGreen.withValues(alpha: 0.16),
    );
    _drawTriangle(
      canvas,
      Offset(size.width * 0.7, size.height * 0.9),
      10,
      AppColors.primaryGreen.withValues(alpha: 0.18),
    );
    _drawTriangle(
      canvas,
      Offset(size.width * 0.3, size.height * 0.1),
      8,
      AppColors.primaryGreen.withValues(alpha: 0.16),
    );

    // More Crosses
    _drawCross(
      canvas,
      Offset(size.width * 0.65, size.height * 0.4),
      10,
      AppColors.primaryGreen.withValues(alpha: 0.2),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.25, size.height * 0.85),
      12,
      AppColors.primaryGreen.withValues(alpha: 0.15),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.05, size.height * 0.25),
      8,
      AppColors.primaryGreen.withValues(alpha: 0.2),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.95, size.height * 0.5),
      14,
      AppColors.primaryGreen.withValues(alpha: 0.18),
    );

    // More Dots
    paint.color = AppColors.primaryGreen.withValues(alpha: 0.15);
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.35), 5, paint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.65), 7, paint);
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.95), 4, paint);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.05), 6, paint);

    // More Diamonds
    _drawDiamond(
      canvas,
      Offset(size.width * 0.9, size.height * 0.15),
      12,
      AppColors.primaryGreen.withValues(alpha: 0.18),
      true,
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.2, size.height * 0.55),
      10,
      AppColors.primaryGreen.withValues(alpha: 0.16),
      false,
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.6, size.height * 0.8),
      15,
      AppColors.primaryGreen.withValues(alpha: 0.17),
      true,
    );

    // More connecting lines
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.4),
      Offset(size.width * 0.05, size.height * 0.25),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.9),
      Offset(size.width * 0.6, size.height * 0.8),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.9, size.height * 0.15),
      Offset(size.width * 0.95, size.height * 0.5),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.55, size.height * 0.35),
      Offset(size.width * 0.65, size.height * 0.4),
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

  void _drawTriangle(Canvas canvas, Offset center, double size, Color color) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx + size, center.dy + size);
    path.lineTo(center.dx - size, center.dy + size);
    path.close();

    canvas.drawPath(path, paint);
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Creative background painter for "Get in touch" card
class _CreativeCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Abstract shapes with gradients

    // Shape 1: Top Right Liquid Blob
    final path1 = Path();
    path1.moveTo(size.width * 0.6, 0);
    path1.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.3,
      size.width,
      size.height * 0.4,
    );
    path1.lineTo(size.width, 0);
    path1.close();

    paint.shader = LinearGradient(
      colors: [
        AppColors.primaryGreen.withValues(alpha: 0.4),
        AppColors.tealGreen.withValues(alpha: 0.1),
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path1, paint);

    // Shape 2: Bottom Left Curve
    final path2 = Path();
    path2.moveTo(0, size.height * 0.6);
    path2.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.5,
      size.width * 0.5,
      size.height,
    );
    path2.lineTo(0, size.height);
    path2.close();

    paint.shader = LinearGradient(
      colors: [
        AppColors.primaryGreen.withValues(alpha: 0.2),
        Colors.blue.withValues(alpha: 0.1),
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path2, paint);

    // Shape 3: Center dynamic stroke
    final strokePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..shader = LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      40,
      strokePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      20,
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

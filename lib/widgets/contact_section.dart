import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';

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

  static final List<SocialPlatform> _platforms = [
    SocialPlatform(
      name: "Twitter/X",
      url: "https://twitter.com",
      icon: const _TwitterIcon(),
    ),
    SocialPlatform(
      name: "Git Hub",
      url: "https://github.com",
      icon: const _GitHubIcon(),
    ),
    SocialPlatform(
      name: "Linked in",
      url: "https://linkedin.com",
      icon: const _LinkedInIcon(),
    ),
    SocialPlatform(
      name: "Medium",
      url: "https://medium.com",
      icon: const _MediumIcon(),
    ),
  ];

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Stack(
        children: [
          // Background geometric patterns
          Positioned(
            top: 0,
            left: 0,
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                size: Size(
                  isMobile ? 200 : 300,
                  isMobile ? 200 : 300,
                ),
                painter: _GeometricPatternPainter(),
              ),
            ),
          ),
          // Main content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section identifier
                    Row(
                      children: [
                        Text(
                          "{06} – Contact me",
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.darkGreen,
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
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Social cards grid
                    isMobile
                        ? Column(
                            children: [
                              // Top row - 2 cards
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSocialCard(
                                      _platforms[0],
                                      context,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildSocialCard(
                                      _platforms[1],
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
                                      _platforms[2],
                                      context,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildSocialCard(
                                      _platforms[3],
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildGetInTouchCard(context),
                            ],
                          )
                        : Column(
                            children: [
                              // Top row - 3 cards
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSocialCard(
                                      _platforms[0],
                                      context,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildSocialCard(
                                      _platforms[1],
                                      context,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildSocialCard(
                                      _platforms[2],
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Bottom row - 2 cards
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSocialCard(
                                      _platforms[3],
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
        ],
      ),
    );
  }

  Widget _buildSocialCard(SocialPlatform platform, BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(platform.url),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 140,
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
                  color: Colors.grey[900],
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
                  color: AppColors.darkGreen,
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
    return InkWell(
      onTap: () {
        // Navigate to contact form or email
        // You can customize this action
        final email = Uri(
          scheme: 'mailto',
          path: 'your-email@example.com',
        );
        launchUrl(email);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.darkGreen,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGreen.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
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
              child: CustomPaint(
                size: const Size(48, 48),
                painter: _ArrowIconPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for geometric background pattern
class _GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.fill;

    // Draw overlapping triangles/polygons
    final path1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width * 0.4, 0)
      ..lineTo(size.width * 0.6, size.height * 0.5)
      ..lineTo(size.width * 0.2, size.height)
      ..close();
    canvas.drawPath(path1, paint);

    final path2 = Path()
      ..moveTo(size.width * 0.3, size.height * 0.2)
      ..lineTo(size.width * 0.7, size.height * 0.1)
      ..lineTo(size.width, size.height * 0.4)
      ..lineTo(size.width * 0.5, size.height * 0.8)
      ..close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Twitter/X Icon
class _TwitterIcon extends StatelessWidget {
  const _TwitterIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _TwitterIconPainter(),
    );
  }
}

class _TwitterIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Draw X shape
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.8),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.8),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// GitHub Icon
class _GitHubIcon extends StatelessWidget {
  const _GitHubIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _GitHubIconPainter(),
    );
  }
}

class _GitHubIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.35;

    // Draw GitHub octocat shape (simplified)
    // Circle
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Cat ears (simplified)
    canvas.drawCircle(
      Offset(centerX - radius * 0.5, centerY - radius * 0.8),
      radius * 0.3,
      paint,
    );
    canvas.drawCircle(
      Offset(centerX + radius * 0.5, centerY - radius * 0.8),
      radius * 0.3,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// LinkedIn Icon
class _LinkedInIcon extends StatelessWidget {
  const _LinkedInIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _LinkedInIconPainter(),
    );
  }
}

class _LinkedInIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw "in" text (simplified as rectangles)
    // Letter "i"
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.3, size.height * 0.2, size.width * 0.15,
            size.height * 0.6),
        const Radius.circular(2),
      ),
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.375, size.height * 0.15),
      size.width * 0.05,
      paint,
    );

    // Letter "n"
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.2, size.width * 0.15,
            size.height * 0.6),
        const Radius.circular(2),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.2, size.width * 0.3,
            size.height * 0.15),
        const Radius.circular(2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Medium Icon
class _MediumIcon extends StatelessWidget {
  const _MediumIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _MediumIconPainter(),
    );
  }
}

class _MediumIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw two overlapping circles (Medium logo)
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height / 2),
      size.width * 0.25,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height / 2),
      size.width * 0.25,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Arrow Icon for "Get in touch"
class _ArrowIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw curved arrow pointing bottom-right
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.7,
      size.width * 0.8,
      size.height * 0.8,
    );

    canvas.drawPath(path, paint);

    // Arrow head
    final arrowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final arrowPath = Path();
    arrowPath.moveTo(size.width * 0.8, size.height * 0.8);
    arrowPath.lineTo(size.width * 0.75, size.height * 0.75);
    arrowPath.lineTo(size.width * 0.85, size.height * 0.8);
    arrowPath.lineTo(size.width * 0.75, size.height * 0.85);
    arrowPath.close();

    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/routes/app_routes.dart';

class FooterSection extends ConsumerWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final isNarrow = MediaQuery.of(context).size.width < 800;

    return Container(
      color: const Color(0xFF0A0A0A), // Dark almost black background
      child: Column(
        children: [
          Stack(
            children: [
              // Background decorative elements
              Positioned.fill(child: CustomPaint(painter: _BackgroundPainter())),
              // Main content
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isNarrow ? 100 : 140,
                  horizontal: isNarrow ? 32 : 120,
                ),
                child:
                    isNarrow
                        ? _buildMobileLayout(context, state, ref)
                        : _buildDesktopLayout(context, state, ref),
              ),
            ],
          ),
          // Copyright bar with hidden admin navigation
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isNarrow ? 20 : 16,
              horizontal: isNarrow ? 32 : 120,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
              ),
            ),
            child: isNarrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.admin),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '© ${DateTime.now().year} ${state.personalInfo.name}. All rights reserved.',
                            style: GoogleFonts.manrope(
                              color: Colors.white.withValues(alpha: 0.35),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Made with Flutter',
                        style: GoogleFonts.manrope(
                          color: Colors.white.withValues(alpha: 0.25),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.admin),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '© ${DateTime.now().year} ${state.personalInfo.name}. All rights reserved.',
                            style: GoogleFonts.manrope(
                              color: Colors.white.withValues(alpha: 0.35),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Made with Flutter',
                        style: GoogleFonts.manrope(
                          color: Colors.white.withValues(alpha: 0.25),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    PortfolioState state,
    WidgetRef ref,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Section
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section identifier
              Row(
                children: [
                  Text(
                    "{08} – Footer",
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      color: Colors.white.withValues(alpha: 0.6),
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
              // Main Heading
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Let's create\nsomething\nextraordinary\ntogether",
                      style: GoogleFonts.manrope(
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: ".",
                      style: GoogleFonts.manrope(
                        fontSize: 96,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryGreen,
                        height: 1.1,
                        letterSpacing: -2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Sub-heading
              Text(
                "Let's make an impact",
                style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 120),
        // Right Section
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Card
              _buildProfileCard(state),
              const SizedBox(height: 60),
              // Contact Information
              _buildContactInfo(state),
              const SizedBox(height: 32),
              // Description
              _buildDescription(),
              const SizedBox(height: 48),
              // Social Links
              _buildSocialLinks(state, ref),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    PortfolioState state,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section identifier
        Row(
          children: [
            Text(
              "{08} – Footer",
              style: GoogleFonts.manrope(
                fontSize: 18,
                color: Colors.white.withValues(alpha: 0.6),
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
        // Main Heading
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Let's create\nsomething\nextraordinary\ntogether",
                style: GoogleFonts.manrope(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: -1.5,
                ),
              ),
              TextSpan(
                text: ".",
                style: GoogleFonts.manrope(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryGreen,
                  height: 1.1,
                  letterSpacing: -1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Sub-heading
        Text(
          "Let's make an impact",
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 64),
        // Profile Card
        _buildProfileCard(state),
        const SizedBox(height: 48),
        // Contact Information
        _buildContactInfo(state),
        const SizedBox(height: 32),
        // Description
        _buildDescription(),
        const SizedBox(height: 48),
        // Social Links
        _buildSocialLinks(state, ref),
      ],
    );
  }

  Widget _buildProfileCard(PortfolioState state) {
    return Row(
      children: [
        // Profile Image
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[800],
          backgroundImage: const AssetImage(
            'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
          ),
          onBackgroundImageError: (exception, stackTrace) {},
        ),
        const SizedBox(width: 24),
        // Name and Role
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.personalInfo.name,
                style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Mobile app-Designer, developer",
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(PortfolioState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact me",
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          state.personalInfo.email,
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          height: 1.6,
        ),
        children: [
          const TextSpan(text: "Hit me up if you're looking for a "),
          TextSpan(
            text: "fast, reliable web-designer",
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const TextSpan(text: " who can bring your vision to life"),
        ],
      ),
    );
  }

  IconData _iconForPlatform(String platform) {
    switch (platform.toLowerCase()) {
      case 'twitter': return FontAwesomeIcons.xTwitter;
      case 'linkedin': return FontAwesomeIcons.linkedin;
      case 'github': return FontAwesomeIcons.github;
      case 'medium': return FontAwesomeIcons.medium;
      case 'instagram': return FontAwesomeIcons.instagram;
      default: return FontAwesomeIcons.link;
    }
  }

  Widget _buildSocialLinks(PortfolioState state, WidgetRef ref) {
    final links = state.personalInfo.socialLinks;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        for (final link in links)
          GestureDetector(
            onTap: () => ref.read(portfolioProvider.notifier).launchSocialLink(link.url),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_iconForPlatform(link.platform), size: 18, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    link.platform,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// Custom painter for background decorative elements - Enhanced Creative Style
class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Ambient Glow (Subtle gradient behind text area)
    final glowPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              AppColors.primaryGreen.withValues(alpha: 0.12),
              Colors.transparent,
            ],
            center: const Alignment(-0.8, -0.6), // Top-left bias
            radius: 1.2,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint);

    final paint = Paint()..style = PaintingStyle.fill;

    // 2. Top-Right Complex Fluid Shape
    // Layer A: Larger, fainter backing
    final path1a =
        Path()
          ..moveTo(size.width * 0.5, 0)
          ..quadraticBezierTo(
            size.width * 0.7,
            size.height * 0.4,
            size.width,
            size.height * 0.5,
          )
          ..lineTo(size.width, 0)
          ..close();

    paint.shader = LinearGradient(
      colors: [AppColors.tealGreen.withValues(alpha: 0.08), Colors.transparent],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path1a, paint);

    // Layer B: Sharper, brighter foreground blob
    final path1b =
        Path()
          ..moveTo(size.width * 0.65, 0)
          ..cubicTo(
            size.width * 0.75,
            size.height * 0.15,
            size.width * 0.85,
            size.height * 0.35,
            size.width,
            size.height * 0.3,
          )
          ..lineTo(size.width, 0)
          ..close();

    paint.shader = LinearGradient(
      colors: [
        AppColors.primaryGreen.withValues(alpha: 0.25),
        AppColors.skillsGreen.withValues(alpha: 0.05),
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path1b, paint);

    // 3. Bottom-Left Organic Wave
    final path2 =
        Path()
          ..moveTo(0, size.height * 0.45)
          ..cubicTo(
            size.width * 0.15,
            size.height * 0.5,
            size.width * 0.3,
            size.height * 0.75,
            size.width * 0.5,
            size.height,
          )
          ..lineTo(0, size.height)
          ..close();

    paint.shader = LinearGradient(
      colors: [
        AppColors.primaryGreen.withValues(alpha: 0.15),
        Colors.blue.withValues(alpha: 0.08),
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path2, paint);

    // 4. Creative Accents (Strokes & Circles)
    final strokePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..shader = LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Large decorative circle outline (Top Right)
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.2),
      80,
      strokePaint,
    );

    // Floating Curve Line (Bottom)
    final linePath =
        Path()
          ..moveTo(size.width * 0.1, size.height * 0.85)
          ..quadraticBezierTo(
            size.width * 0.3,
            size.height * 0.8,
            size.width * 0.4,
            size.height * 0.95,
          );
    canvas.drawPath(linePath, strokePaint);

    // 5. Particles (floating dots for detail)
    final particlePaint = Paint()..style = PaintingStyle.fill;

    // Large faint particle
    particlePaint.color = AppColors.primaryGreen.withValues(alpha: 0.1);
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.6),
      8,
      particlePaint,
    );

    // Small bright particles
    particlePaint.color = AppColors.primaryGreen.withValues(alpha: 0.3);
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.1),
      3,
      particlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.92, size.height * 0.45),
      2.5,
      particlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.85),
      2,
      particlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.05, size.height * 0.3),
      2,
      particlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

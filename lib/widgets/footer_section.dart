import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../controllers/portfolio_controller.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isNarrow = MediaQuery.of(context).size.width < 800;

    return Container(
      color: const Color(0xFF0A0A0A), // Dark almost black background
      padding: EdgeInsets.symmetric(
        vertical: isNarrow ? 100 : 140,
        horizontal: isNarrow ? 32 : 120,
      ),
      child: Stack(
        children: [
          // Background decorative elements
          Positioned.fill(child: CustomPaint(painter: _BackgroundPainter())),
          // Main content
          isNarrow
              ? _buildMobileLayout(context, controller)
              : _buildDesktopLayout(context, controller),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    PortfolioController controller,
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
                  color: Colors.white.withOpacity(0.8),
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
              _buildProfileCard(controller),
              const SizedBox(height: 60),
              // Contact Information
              _buildContactInfo(controller),
              const SizedBox(height: 32),
              // Description
              _buildDescription(),
              const SizedBox(height: 48),
              // LinkedIn Button
              _buildLinkedInButton(controller),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    PortfolioController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 64),
        // Profile Card
        _buildProfileCard(controller),
        const SizedBox(height: 48),
        // Contact Information
        _buildContactInfo(controller),
        const SizedBox(height: 32),
        // Description
        _buildDescription(),
        const SizedBox(height: 48),
        // LinkedIn Button
        _buildLinkedInButton(controller),
      ],
    );
  }

  Widget _buildProfileCard(PortfolioController controller) {
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
                controller.personalInfo.value.name,
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
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              // Social Icons
              Row(
                children: [
                  _buildSocialIcon(FontAwesomeIcons.github, () {
                    try {
                      final githubLink = controller
                          .personalInfo
                          .value
                          .socialLinks
                          .firstWhere((link) => link.platform == "GitHub");
                      controller.launchSocialLink(githubLink.url);
                    } catch (e) {
                      // Link not found
                    }
                  }),
                  const SizedBox(width: 24),
                  _buildSocialIcon(FontAwesomeIcons.dribbble, () {
                    try {
                      final dribbbleLink = controller
                          .personalInfo
                          .value
                          .socialLinks
                          .firstWhere((link) => link.platform == "Dribbble");
                      controller.launchSocialLink(dribbbleLink.url);
                    } catch (e) {
                      // Link not found
                    }
                  }),
                  const SizedBox(width: 24),
                  _buildSocialIcon(FontAwesomeIcons.linkedin, () {
                    try {
                      final linkedInLink = controller
                          .personalInfo
                          .value
                          .socialLinks
                          .firstWhere((link) => link.platform == "LinkedIn");
                      controller.launchSocialLink(linkedInLink.url);
                    } catch (e) {
                      // Link not found
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 28, color: Colors.white.withOpacity(0.8)),
    );
  }

  Widget _buildContactInfo(PortfolioController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact me",
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          controller.personalInfo.value.email,
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

  Widget _buildLinkedInButton(PortfolioController controller) {
    return ElevatedButton(
      onPressed: () {
        try {
          final linkedInLink = controller.personalInfo.value.socialLinks
              .firstWhere((link) => link.platform == "LinkedIn");
          controller.launchSocialLink(linkedInLink.url);
        } catch (e) {
          // Link not found
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Linked In",
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_upward, size: 22, color: Colors.black),
        ],
      ),
    );
  }
}

// Custom painter for background decorative elements
class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey[900]!.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    // Draw subtle curved lines
    final path1 = Path();
    path1.moveTo(size.width * 0.1, size.height * 0.2);
    path1.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.2,
    );
    path1.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.3,
      size.width * 0.9,
      size.height * 0.2,
    );
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(size.width * 0.2, size.height * 0.6);
    path2.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.5,
      size.width * 0.6,
      size.height * 0.6,
    );
    path2.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.7,
      size.width * 0.95,
      size.height * 0.6,
    );
    canvas.drawPath(path2, paint);

    // Draw some subtle shapes
    final shapePaint =
        Paint()
          ..color = Colors.grey[800]!.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.3),
      30,
      shapePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.7),
      40,
      shapePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

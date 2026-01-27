import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../controllers/portfolio_controller.dart';
import '../widgets/custom_widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage(
                      'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
                    ),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Fallback to icon if image fails to load
                    },
                    child: null,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    controller.personalInfo.value.name,
                    style: GoogleFonts.manrope(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.personalInfo.value.title,
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.personalInfo.value.location,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // About Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Me',
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.personalInfo.value.bio,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "I'm passionate about creating beautiful, functional mobile applications that provide exceptional user experiences. With expertise in Flutter development, I specialize in building cross-platform apps that work seamlessly on both iOS and Android.",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "When I'm not coding, you can find me exploring new technologies, contributing to open-source projects, or sharing my knowledge through blog posts and tutorials.",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Skills Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skills & Technologies',
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        [
                              'Flutter',
                              'Dart',
                              'Firebase',
                              'REST APIs',
                              'Git',
                              'Material Design',
                              'Provider',
                              'GetX',
                              'SQLite',
                              'Android Studio',
                              'VS Code',
                              'Figma',
                            ]
                            .map(
                              (skill) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF10B981,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF10B981,
                                    ).withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  skill,
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    color: AppColors.darkGreen,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Contact Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get In Touch',
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "I'm always interested in new opportunities and exciting projects. Feel free to reach out if you'd like to work together!",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Contact Info
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.envelope,
                        color: AppColors.darkGreen,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          controller.personalInfo.value.email,
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.mapMarkerAlt,
                        color: AppColors.darkGreen,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        controller.personalInfo.value.location,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Contact Button
                  Center(
                    child: CustomButton(
                      text: "Send Message",
                      onPressed: controller.launchEmail,
                      icon: FontAwesomeIcons.paperPlane,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Social Links
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialIconButton(
                          platform: "Twitter",
                          url: controller.personalInfo.value.socialLinks[0].url,
                          icon: FontAwesomeIcons.twitter,
                        ),
                        const SizedBox(width: 16),
                        SocialIconButton(
                          platform: "LinkedIn",
                          url: controller.personalInfo.value.socialLinks[1].url,
                          icon: FontAwesomeIcons.linkedin,
                        ),
                        const SizedBox(width: 16),
                        SocialIconButton(
                          platform: "GitHub",
                          url: controller.personalInfo.value.socialLinks[2].url,
                          icon: FontAwesomeIcons.github,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

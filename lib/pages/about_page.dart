import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../controllers/portfolio_controller.dart';
import '../utils/responsive_helper.dart';
import '../widgets/custom_widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _AboutHeroSection(controller: controller, isDesktop: isDesktop),

            const SizedBox(height: 48),

            // About Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.personalInfo.value.bio,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "I'm passionate about creating beautiful, functional mobile applications that provide exceptional user experiences. With expertise in Flutter development, I specialize in building cross-platform apps that work seamlessly on both iOS and Android.",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "When I'm not coding, you can find me exploring new technologies, contributing to open-source projects, or sharing my knowledge through blog posts and tutorials.",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
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
                color: Theme.of(context).colorScheme.surface,
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
                color: Theme.of(context).colorScheme.surface,
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "I'm always interested in new opportunities and exciting projects. Feel free to reach out if you'd like to work together!",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
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

class _AboutHeroSection extends StatelessWidget {
  const _AboutHeroSection({
    required this.controller,
    required this.isDesktop,
  });

  final PortfolioController controller;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final layout = isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: _buildLeftColumn(context),
              ),
              const SizedBox(width: 48),
              Expanded(
                flex: 6,
                child: _buildRightColumn(context),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeftColumn(context),
              const SizedBox(height: 32),
              _buildRightColumn(context),
            ],
          );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
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
      child: layout,
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Availability status
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Available for freelance work',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Main heading
        Text(
          'About me',
          style: GoogleFonts.manrope(
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        // Profile picture and social icons
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.grey[300],
              backgroundImage: const AssetImage(
                'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
              ),
              onBackgroundImageError: (exception, stackTrace) {},
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SocialIconButton(
                      platform: 'Twitter',
                      url: controller.personalInfo.value.socialLinks[0].url,
                      icon: FontAwesomeIcons.twitter,
                    ),
                    const SizedBox(width: 12),
                    SocialIconButton(
                      platform: 'LinkedIn',
                      url: controller.personalInfo.value.socialLinks[1].url,
                      icon: FontAwesomeIcons.linkedin,
                    ),
                    const SizedBox(width: 12),
                    SocialIconButton(
                      platform: 'GitHub',
                      url: controller.personalInfo.value.socialLinks[2].url,
                      icon: FontAwesomeIcons.github,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.personalInfo.value.email,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Short bio
        Text(
          "I'm Gokul, a passionate mobile app developer with a love for creating visually stunning and user-friendly digital experiences.",
          style: GoogleFonts.manrope(
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        // LinkedIn button
        InkWell(
          onTap: () => controller.launchSocialLink(
            controller.personalInfo.value.socialLinks[1].url,
          ),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Linked In',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_outward, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hi, I'm Gokul, a passionate mobile app developer and designer with a love for creating visually stunning experiences. With a strong background in design and front-end development, I specialize in crafting responsive mobile apps that not only look great but also provide seamless interactions across all devices.",
          style: GoogleFonts.manrope(
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Over the years, I've had the opportunity to work with a diverse range of clients, from startups to established brands, helping them bring their visions to life online.",
          style: GoogleFonts.manrope(
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Let's create something amazing together!",
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

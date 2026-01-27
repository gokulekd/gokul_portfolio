import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../controllers/portfolio_controller.dart';
import '../widgets/custom_widgets.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

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
            // Header Section
            Center(
              child: Column(
                children: [
                  Text(
                    'Let\'s Work Together',
                    style: GoogleFonts.manrope(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ready to bring your ideas to life? Let\'s discuss your project!',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Contact Information Cards
            Row(
              children: [
                Expanded(
                  child: _buildContactCard(
                    icon: FontAwesomeIcons.envelope,
                    title: 'Email',
                    subtitle: controller.personalInfo.value.email,
                    onTap: () async {
                      try {
                        await controller.launchEmail();
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Could not open email client: $e',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildContactCard(
                    icon: FontAwesomeIcons.mapMarkerAlt,
                    title: 'Location',
                    subtitle: controller.personalInfo.value.location,
                    onTap: () {
                      Get.snackbar(
                        'Location',
                        'Based in ${controller.personalInfo.value.location}',
                        backgroundColor: AppColors.darkGreen,
                        colorText: Colors.white,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Social Media Section
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
                    'Connect With Me',
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Follow me on social media for updates on my latest projects and insights.',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        icon: FontAwesomeIcons.twitter,
                        label: 'Twitter',
                        onTap:
                            () => controller.launchSocialLink(
                              controller.personalInfo.value.socialLinks[0].url,
                            ),
                      ),
                      _buildSocialButton(
                        icon: FontAwesomeIcons.linkedin,
                        label: 'LinkedIn',
                        onTap:
                            () => controller.launchSocialLink(
                              controller.personalInfo.value.socialLinks[1].url,
                            ),
                      ),
                      _buildSocialButton(
                        icon: FontAwesomeIcons.github,
                        label: 'GitHub',
                        onTap:
                            () => controller.launchSocialLink(
                              controller.personalInfo.value.socialLinks[2].url,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Contact Form Section
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
                    'Send a Message',
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Have a project in mind? Send me a message and let\'s discuss how we can work together.',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Contact Buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "Send Email",
                          onPressed: () async {
                            try {
                              await controller.launchEmail();
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Could not open email client: $e',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                          icon: FontAwesomeIcons.envelope,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: "View Resume",
                          onPressed: () {
                            Get.snackbar(
                              'Resume',
                              'Resume download feature coming soon!',
                              backgroundColor: AppColors.darkGreen,
                              colorText: Colors.white,
                            );
                          },
                          backgroundColor: Colors.black87,
                          icon: FontAwesomeIcons.download,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Call to Action
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.darkGreen, const Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Ready to Start Your Project?',
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "I'm always excited to work on new and challenging projects. Whether you need a mobile app, web application, or consultation, I'm here to help!",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: "Get In Touch",
                    onPressed: () async {
                      try {
                        await controller.launchEmail();
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Could not open email client: $e',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    backgroundColor: Colors.white,
                    textColor: AppColors.darkGreen,
                    icon: FontAwesomeIcons.paperPlane,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
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
          children: [
            Icon(icon, color: AppColors.darkGreen, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.manrope(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.darkGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: AppColors.darkGreen, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.manrope(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

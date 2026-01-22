import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[50]!, Colors.white],
        ),
      ),
      child: Column(
        children: [
          // Section identifier
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF00D4AA),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Available for freelance work",
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Main heading
          Text(
            "About me",
            style: GoogleFonts.manrope(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),

          // About content
          _buildAboutContent(context),
        ],
      ),
    );
  }

  Widget _buildAboutContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;

        final leftColumn = Column(
          children: [
            // Profile Image
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF00D4AA), width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D4AA).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF00D4AA).withOpacity(0.1),
                              const Color(0xFF00D4AA).withOpacity(0.2),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 100,
                          color: Color(0xFF00D4AA),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Social Icons
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildSocialIcon("X", Icons.close, "https://x.com"),
                _buildSocialIcon("in", Icons.work, "https://linkedin.com"),
                _buildSocialIcon(
                  "Email",
                  Icons.email,
                  "mailto:gokulofficialcommunication@gmail.com",
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Email
            Text(
              "gokulofficialcommunication@gmail.com",
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Short Bio
            Text(
              "Passionate mobile app developer and designer creating pixel-perfect experiences.",
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // LinkedIn Button
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse('https://linkedin.com');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D4AA),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D4AA).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Linked In",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

        final rightColumn = Column(
          crossAxisAlignment:
              isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, I'm Gokul, a passionate mobile app developer and designer with a love for creating visually stunning experiences. With a strong background in design and front-end development, I specialize in crafting responsive mobile app that not only look great but also provide interactions across all devices.",
              textAlign: isNarrow ? TextAlign.center : TextAlign.start,
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "I have 2+ years of experience in mobile app development, working with Flutter, Dart, and various design tools. My goal is to help businesses and individuals bring their ideas to life through beautiful, functional mobile applications.",
              textAlign: isNarrow ? TextAlign.center : TextAlign.start,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Let's work together to create something amazing!",
              textAlign: isNarrow ? TextAlign.center : TextAlign.start,
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ],
        );

        if (isNarrow) {
          return Column(
            children: [leftColumn, const SizedBox(height: 48), rightColumn],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: leftColumn),
            const SizedBox(width: 60),
            Expanded(flex: 1, child: rightColumn),
          ],
        );
      },
    );
  }

  Widget _buildSocialIcon(String label, IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Center(
          child:
              label.isEmpty
                  ? Icon(icon, size: 20, color: Colors.grey[600])
                  : Text(
                    label,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
        ),
      ),
    );
  }
}

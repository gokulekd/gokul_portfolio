import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_widgets.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 800;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        children: [
          // Status Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF82FF1F),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Available for freelance work",
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          // Main CTA
          Text(
            "Let's create something\nextraordinary together.",
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: isNarrow ? 40 : 64,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 48),

          // Contact Button
          CustomButton(
            text: "gokulofficialcommunication@gmail.com",
            onPressed: () {
              // Copy enabled
            },
            icon: FontAwesomeIcons.envelope,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
          ),

          const SizedBox(height: 80),

          // Divider
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 32),

          // Bottom Footer
          isNarrow
              ? Column(
                children: [
                  Text(
                    "© 2024 Gokul K S.",
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSocialLinks(),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "© 2024 Gokul K S. All Rights Reserved.",
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  _buildSocialLinks(),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFooterLink("Twitter", FontAwesomeIcons.twitter),
        const SizedBox(width: 24),
        _buildFooterLink("LinkedIn", FontAwesomeIcons.linkedin),
        const SizedBox(width: 24),
        _buildFooterLink("GitHub", FontAwesomeIcons.github),
      ],
    );
  }

  Widget _buildFooterLink(String label, IconData icon) {
    return InkWell(
      onTap: () {},
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}

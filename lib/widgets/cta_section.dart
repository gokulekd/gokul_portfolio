import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/portfolio_controller.dart';
import '../utils/responsive_helper.dart';

class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 24 : 48,
      ),
      child: Column(
        children: [
          Text(
            'I blend creativity with technical expertise',
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => controller.changePage(5), // Navigate to Contact page
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF82FF1F),
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 32 : 48,
                vertical: isMobile ? 16 : 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Text(
              'Become a client',
              style: GoogleFonts.manrope(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
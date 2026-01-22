import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 900;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: const Color(0xFFF8F8F8),
      child: Column(
        children: [
          Text(
            "How it works",
            style: GoogleFonts.manrope(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "My simple 3-step process to bring your ideas to life",
            style: GoogleFonts.manrope(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 60),
          isNarrow
              ? Column(
                children: [
                  _buildProcessStep(
                    "01",
                    "Discovery",
                    "We start by understanding your goals, user needs, and project requirements.",
                  ),
                  const SizedBox(height: 32),
                  _buildProcessStep(
                    "02",
                    "Development",
                    "I build your application using Flutter, ensuring high performance and clean code.",
                  ),
                  const SizedBox(height: 32),
                  _buildProcessStep(
                    "03",
                    "Launch",
                    "We test, refine, and launch your product to the world with ongoing support.",
                  ),
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildProcessStep(
                      "01",
                      "Discovery",
                      "We start by understanding your goals, user needs, and project requirements.",
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: _buildProcessStep(
                      "02",
                      "Development",
                      "I build your application using Flutter, ensuring high performance and clean code.",
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: _buildProcessStep(
                      "03",
                      "Launch",
                      "We test, refine, and launch your product to the world with ongoing support.",
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildProcessStep(String number, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 10,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF82FF1F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              number,
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF10B981), // Darker green for text
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

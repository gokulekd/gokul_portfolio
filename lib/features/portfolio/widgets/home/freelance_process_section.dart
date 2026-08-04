import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../models/site_content_models.dart';
import 'package:google_fonts/google_fonts.dart';

// `ProcessStep`/`ProcessItem` used to be the hardcoded step data; the section
// now reads `ProcessStepItem`/`ProcessStepDetail` from Firestore
// (`site_content_models.dart`) via `portfolioProvider.visibleProcessSteps`.

class FreelanceProcessSection extends ConsumerWidget {
  const FreelanceProcessSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final steps = ref.watch(
      portfolioProvider.select((s) => s.visibleProcessSteps),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 0,
      ),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "{04} - Freelance Process",
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.skillsGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
            child: Text(
              "How it works",
              style: GoogleFonts.manrope(
                fontSize: 60,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 60),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
                child: Column(
                  children: [
                    ...List.generate(
                      steps.length,
                      (index) => Column(
                        children: [
                          _buildProcessStep(steps[index], context),
                          if (index < steps.length - 1)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 32),
                              height: 1,
                              color: Colors.grey[800],
                            ),
                        ],
                      ),
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

  Widget _buildProcessStep(ProcessStepItem step, BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    // Label tag with round container
    final labelWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Text(
        step.label,
        style: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );

    // Number and slash widget
    final numberWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "/",
          style: GoogleFonts.manrope(fontSize: 20, color: Colors.grey[400]),
        ),
        const SizedBox(width: 8),
        Text(
          step.number,
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.skillsGreen,
          ),
        ),
      ],
    );

    // Main content
    final contentWidget = Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with time estimate
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  step.title,
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(Icons.access_time, size: 18, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(
                    "/${step.timeEstimate}/",
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bullet points
          ...step.items.map(
            (item) => Padding(
              padding: EdgeInsets.only(
                bottom: 12,
                left: isMobile ? 4 : 0,
                right: isMobile ? 4 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "* ",
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: item.key,
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: " ${item.description}",
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      // Mobile layout: label on top
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [labelWidget, const SizedBox(width: 12), numberWidget],
            ),
            const SizedBox(height: 16),
            contentWidget,
          ],
        ),
      );
    } else {
      // Desktop layout: label on the left
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelWidget,
          const SizedBox(width: 8),
          numberWidget,
          const SizedBox(width: 16),
          Expanded(child: contentWidget),
        ],
      );
    }
  }
}

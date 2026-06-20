import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../models/portfolio_models.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'contact_hero_section.dart' show HeroActionButton;

class ContactClosingSection extends ConsumerWidget {
  const ContactClosingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hPad =
        isMobile
            ? 20.0
            : isTablet
            ? 48.0
            : 88.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        hPad,
        isMobile ? 48 : 80,
        hPad,
        isMobile ? 48 : 80,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        decoration: BoxDecoration(
          color: const Color(0xFF0E1512),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ready to start something meaningful?',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 28 : 38,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Whether you need a polished Flutter build, design-aware implementation, or a reliable collaborator, I would love to hear about it.',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                HeroActionButton(
                  label: 'Get In Touch',
                  icon: Icons.mail_outline_rounded,
                  isPrimary: true,
                  onPressed: () => ref.read(portfolioProvider.notifier).launchEmail(),
                ),
                HeroActionButton(
                  label: 'View Resume',
                  icon: Icons.file_download_outlined,
                  onPressed: () => ref.read(portfolioProvider.notifier).launchResume(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMetric extends StatelessWidget {
  const ProfileMetric({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.72),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class ContactProfileCard extends StatelessWidget {
  const ContactProfileCard({super.key, required this.info});

  final PersonalInfo info;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: isMobile ? double.infinity : 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.grey[300],
            backgroundImage: const AssetImage(
              'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            info.name,
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            info.title,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.65),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),
          ProfileMetric(
            value: info.email,
            label: 'Primary contact for project discussions',
          ),
          const SizedBox(height: 14),
          ProfileMetric(
            value: info.location,
            label: 'Working remotely and open to collaboration',
          ),
          const SizedBox(height: 14),
          ProfileMetric(
            value: '${info.socialLinks.length}+',
            label: 'Social platforms available to connect on',
          ),
        ],
      ),
    );
  }
}

class AccentWaveDivider extends StatelessWidget {
  const AccentWaveDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 14,
      child: CustomPaint(painter: WaveLinePainter()),
    );
  }
}

class WaveLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primaryGreen.withValues(alpha: 0.78)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4;

    final path = Path();
    const waveWidth = 12.0;
    final halfHeight = size.height / 2;
    path.moveTo(0, halfHeight);

    for (double x = 0; x < size.width; x += waveWidth) {
      path.quadraticBezierTo(
        x + waveWidth / 4,
        0,
        x + waveWidth / 2,
        halfHeight,
      );
      path.quadraticBezierTo(
        x + 3 * waveWidth / 4,
        size.height,
        x + waveWidth,
        halfHeight,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

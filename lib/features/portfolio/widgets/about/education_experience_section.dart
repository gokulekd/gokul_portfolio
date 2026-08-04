import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../models/portfolio_models.dart';
import '../../models/site_content_models.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';

// `EducationEntry` used to be the hardcoded panel data; the section now
// reads `EducationItem` from Firestore (`site_content_models.dart`) via
// `portfolioProvider.visibleEducation`, same as the Experience timeline
// already did via `visibleExperiences`.

class EducationExperienceSection extends ConsumerWidget {
  const EducationExperienceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final isCompact =
        ResponsiveHelper.isMobile(context) ||
        ResponsiveHelper.isTablet(context);

    return isCompact
        ? Column(
          children: [
            EducationPanel(entries: state.visibleEducation),
            const SizedBox(height: 20),
            ExperiencePanel(experiences: state.visibleExperiences),
          ],
        )
        : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: EducationPanel(entries: state.visibleEducation)),
            const SizedBox(width: 24),
            Expanded(
              child: ExperiencePanel(
                experiences: state.visibleExperiences,
              ),
            ),
          ],
        );
  }
}

class EducationPanel extends StatelessWidget {
  const EducationPanel({super.key, required this.entries});

  final List<EducationItem> entries;

  @override
  Widget build(BuildContext context) {
    return DarkInfoPanel(
      title: "Formal Education",
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSingleColumn = constraints.maxWidth < 520;
          final items =
              entries
                  .map(
                    (entry) => EducationItemCard(
                      title: entry.title,
                      period: entry.period,
                      description: entry.description,
                    ),
                  )
                  .toList();

          if (isSingleColumn) {
            return Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  items[i],
                  if (i < items.length - 1) const SizedBox(height: 28),
                ],
              ],
            );
          }

          return Wrap(
            spacing: 28,
            runSpacing: 28,
            children:
                items
                    .map(
                      (item) => SizedBox(
                        width: (constraints.maxWidth - 28) / 2,
                        child: item,
                      ),
                    )
                    .toList(),
          );
        },
      ),
    );
  }
}

class ExperiencePanel extends StatelessWidget {
  const ExperiencePanel({super.key, required this.experiences});

  final List<Experience> experiences;

  @override
  Widget build(BuildContext context) {
    final splitIndex = (experiences.length / 2).ceil();
    final left = experiences.take(splitIndex).toList();
    final right = experiences.skip(splitIndex).toList();
    final isSingleColumn =
        ResponsiveHelper.isMobile(context) || experiences.length < 3;

    return DarkInfoPanel(
      title: "Work Experience",
      child:
          isSingleColumn
              ? Column(
                children: [
                  for (int i = 0; i < experiences.length; i++) ...[
                    ExperienceBullet(experience: experiences[i]),
                    if (i < experiences.length - 1) const SizedBox(height: 22),
                  ],
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < left.length; i++) ...[
                          ExperienceBullet(experience: left[i]),
                          if (i < left.length - 1) const SizedBox(height: 22),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 28),
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < right.length; i++) ...[
                          ExperienceBullet(experience: right[i]),
                          if (i < right.length - 1) const SizedBox(height: 22),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}

class DarkInfoPanel extends StatelessWidget {
  const DarkInfoPanel({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          const AboutAccentWaveDivider(),
          const SizedBox(height: 34),
          child,
        ],
      ),
    );
  }
}

class EducationItemCard extends StatelessWidget {
  const EducationItemCard({
    super.key,
    required this.title,
    required this.period,
    required this.description,
  });

  final String title;
  final String period;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          period,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.85),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.72),
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class ExperienceBullet extends StatelessWidget {
  const ExperienceBullet({super.key, required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryGreen, width: 2),
          ),
          child: Center(
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                experience.position,
                style: GoogleFonts.manrope(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${experience.company} • ${experience.duration}',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.78),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                experience.description,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.68),
                  height: 1.5,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AboutAccentWaveDivider extends StatelessWidget {
  const AboutAccentWaveDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 14,
      child: CustomPaint(painter: AboutWaveLinePainter()),
    );
  }
}

class AboutWaveLinePainter extends CustomPainter {
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

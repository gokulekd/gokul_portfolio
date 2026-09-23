import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../models/site_content_models.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../experience/experience_components.dart' show TimelineExperienceCard;

/// About page "Work Experience" and "Formal Education" sections, each with
/// the same left-aligned heading as My Work's Featured Projects and every
/// entry listed in full below it. Experience reads `visibleExperiences`,
/// education reads `visibleEducation`, both from Firestore.
class EducationExperienceSection extends ConsumerWidget {
  const EducationExperienceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final education = state.visibleEducation;
    final experiences = state.visibleExperiences;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hPad =
        isMobile
            ? 20.0
            : isTablet
            ? 48.0
            : 88.0;
    final sectionGap = isMobile ? 48.0 : 80.0;
    final cardGap = isMobile ? 16.0 : 24.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, sectionGap, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (experiences.isNotEmpty) ...[
            const _SectionHeading(
              eyebrow: '{01} - Experience',
              title: 'Work Experience',
              subtitle: 'Roles, teams and the products I have shipped',
            ),
            SizedBox(height: isMobile ? 32 : 52),
            for (int i = 0; i < experiences.length; i++) ...[
              TimelineExperienceCard(experience: experiences[i]),
              if (i < experiences.length - 1) SizedBox(height: cardGap),
            ],
          ],
          if (education.isNotEmpty && experiences.isNotEmpty)
            SizedBox(height: sectionGap),
          if (education.isNotEmpty) ...[
            const _SectionHeading(
              eyebrow: '{02} - Education',
              title: 'Formal Education',
              subtitle: 'Where the foundations were built',
            ),
            SizedBox(height: isMobile ? 32 : 52),
            for (int i = 0; i < education.length; i++) ...[
              EducationCard(entry: education[i]),
              if (i < education.length - 1) SizedBox(height: cardGap),
            ],
          ],
        ],
      ),
    );
  }
}

/// Eyebrow + big heading + subtitle, matching the Featured Projects header
/// on the My Work page.
class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              eyebrow,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 36 : 52,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            letterSpacing: -1.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.manrope(
            fontSize: isMobile ? 15 : 17,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// One education entry, styled like the experience timeline cards: title
/// with a green dot, the period in a pill, and the full description.
class EducationCard extends StatelessWidget {
  const EducationCard({super.key, required this.entry});

  final EducationItem entry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date pill pinned right on wider screens, under the title on phones.
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _expandUnless(
                isMobile,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        entry.title,
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 24 : 30,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          height: 1.05,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (entry.period.isNotEmpty) ...[
                SizedBox(width: 16, height: isMobile ? 14 : 0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    entry.period,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (entry.description.isNotEmpty) ...[
            const SizedBox(height: 18),
            Text(
              entry.description,
              style: GoogleFonts.manrope(
                fontSize: 15,
                height: 1.8,
                color: colorScheme.onSurface.withValues(alpha: 0.74),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The title row fills the space beside the date pill in a horizontal
/// layout; stacked on phones, it just takes the full width.
Widget _expandUnless(bool stacked, Widget child) =>
    stacked ? child : Expanded(child: child);

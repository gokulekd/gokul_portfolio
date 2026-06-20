import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../models/portfolio_models.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'contact_channels_section.dart' show ContactSectionHeading;

class SocialLinksSection extends ConsumerWidget {
  const SocialLinksSection({super.key, required this.links});

  final List<SocialLink> links;

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
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 48 : 80, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ContactSectionHeading(
            eyebrow: '{02} - Social Links',
            title: 'Stay connected beyond the inbox.',
            description:
                'Follow my work, browse profiles, and keep up with the latest projects and writing across platforms.',
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final items = links.take(6).toList(growable: false);
              final cardWidth =
                  constraints.maxWidth < 900
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 20) / 2;

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: items
                    .map(
                      (link) => SizedBox(
                        width: cardWidth,
                        child: SocialLinkCard(
                          link: link,
                          onTap: () => ref.read(portfolioProvider.notifier).launchSocialLink(link.url),
                        ),
                      ),
                    )
                    .toList(growable: false),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SocialLinkCard extends StatelessWidget {
  const SocialLinkCard({super.key, required this.link, required this.onTap});

  final SocialLink link;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: FaIcon(
                  _iconForPlatform(link.platform),
                  color: AppColors.darkGreen,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    link.platform,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    link.url,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      height: 1.6,
                      color: colorScheme.onSurface.withValues(alpha: 0.62),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.north_east_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.58),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _iconForPlatform(String platform) {
  switch (platform.toLowerCase()) {
    case 'twitter':
      return FontAwesomeIcons.xTwitter;
    case 'linkedin':
      return FontAwesomeIcons.linkedinIn;
    case 'github':
      return FontAwesomeIcons.github;
    case 'medium':
      return FontAwesomeIcons.medium;
    case 'instagram':
      return FontAwesomeIcons.instagram;
    case 'facebook':
      return FontAwesomeIcons.facebookF;
    default:
      return FontAwesomeIcons.globe;
  }
}

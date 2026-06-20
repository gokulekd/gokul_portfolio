import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';
import 'contact_section_components.dart';

class SocialPlatform {
  final String name;
  final String url;
  final Widget icon;

  const SocialPlatform({
    required this.name,
    required this.url,
    required this.icon,
  });
}

class ContactSection extends ConsumerWidget {
  const ContactSection({super.key});

  List<SocialPlatform> _buildPlatforms(PortfolioState state) {
    String urlFor(String platform) => state.getSocialLink(platform)?.url ?? '';

    return [
      SocialPlatform(
        name: "Twitter/X",
        url: urlFor('Twitter'),
        icon: const FaIcon(
          FontAwesomeIcons.xTwitter,
          color: Colors.black,
          size: 22,
        ),
      ),
      SocialPlatform(
        name: "GitHub",
        url: urlFor('GitHub'),
        icon: const FaIcon(
          FontAwesomeIcons.github,
          color: Colors.black,
          size: 22,
        ),
      ),
      SocialPlatform(
        name: "LinkedIn",
        url: urlFor('LinkedIn'),
        icon: const FaIcon(
          FontAwesomeIcons.linkedinIn,
          color: Colors.black,
          size: 22,
        ),
      ),
      SocialPlatform(
        name: "Medium",
        url: urlFor('Medium'),
        icon: const FaIcon(
          FontAwesomeIcons.medium,
          color: Colors.black,
          size: 22,
        ),
      ),
      SocialPlatform(
        name: "Instagram",
        url: urlFor('Instagram'),
        icon: const FaIcon(
          FontAwesomeIcons.instagram,
          color: Colors.black,
          size: 22,
        ),
      ),
    ];
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final isMobile = MediaQuery.of(context).size.width < 768;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final platforms = _buildPlatforms(state);

    return Container(
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned.fill(child: CustomPaint(painter: ContactBackgroundPainter())),
            // Main content
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 80,
                horizontal: isMobile ? 24 : 0,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 48,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Section identifier
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "{07} – Contact me",
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Main title
                        Text(
                          "I'm all over the internet",
                          style: GoogleFonts.manrope(
                            fontSize: isMobile ? 40 : 60,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Social cards grid
                        isMobile
                            ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[0],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[1],
                                        context,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[2],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[3],
                                        context,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[4],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildGetInTouchCard(context, ref),
                                    ),
                                  ],
                                ),
                              ],
                            )
                            : Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[0],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[1],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[2],
                                        context,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[3],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSocialCard(
                                        platforms[4],
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 2,
                                      child: _buildGetInTouchCard(context, ref),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildSocialCard(SocialPlatform platform, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () => _launchURL(platform.url),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surface : const Color(0xFF171717),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isDark
                    ? colorScheme.surfaceContainerHighest
                    : Colors.white.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Platform name
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                platform.name,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? colorScheme.onSurface : Colors.white,
                ),
              ),
            ),
            // Icon in bottom-right
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Center(child: platform.icon),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGetInTouchCard(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap:
          () => ref.read(portfolioProvider.notifier).launchEmail(
            subject: 'Let\'s work together!',
            body:
                'Hi Gokul,\n\nI came across your portfolio and would love to discuss a project with you.\n\n',
          ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surface : const Color(0xFF171717),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isDark
                    ? colorScheme.surfaceContainerHighest
                    : Colors.white.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.skillsGreen.withValues(
                alpha: isDark ? 0.35 : 0.5,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Creative Background Painting
              Positioned.fill(
                child: CustomPaint(painter: CreativeCardPainter()),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Stack(
                  children: [
                    // Text
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Get in touch",
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? colorScheme.onSurface : Colors.white,
                        ),
                      ),
                    ),
                    // Arrow icon in bottom-right
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? colorScheme.surfaceContainerHighest
                                  : Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isDark
                                    ? colorScheme.onSurface.withValues(
                                      alpha: 0.12,
                                    )
                                    : Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: isDark ? colorScheme.onSurface : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

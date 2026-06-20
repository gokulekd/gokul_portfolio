import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../models/portfolio_models.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'blog_components.dart';
import 'blog_profile_card.dart';

class BlogHeroSection extends ConsumerWidget {
  const BlogHeroSection({super.key, this.featuredPost});

  final BlogPost? featuredPost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final info = state.personalInfo;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final hPad =
        isMobile
            ? 20.0
            : isTablet
            ? 48.0
            : 88.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? const [
                    Color(0xFF080808),
                    Color(0xFF11151C),
                    Color(0xFF0A0A0A),
                  ]
                  : const [
                    Color(0xFFF8FBF7),
                    Color(0xFFEEF4FB),
                    Color(0xFFF9FAF8),
                  ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          hPad,
          isMobile ? 40 : 64,
          hPad,
          isMobile ? 40 : 64,
        ),
        child: Wrap(
          spacing: 36,
          runSpacing: 36,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 640,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Portfolio / Blog',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 16 : 24),
                  Text(
                    'Blog',
                    style: GoogleFonts.inter(
                      fontSize:
                          isMobile
                              ? 60
                              : isTablet
                              ? 88
                              : 108,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      height: 0.92,
                      letterSpacing: isMobile ? -2.5 : -4.5,
                    ),
                  ),
                  SizedBox(height: isMobile ? 18 : 28),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Text(
                      'Thoughts, notes, and practical writing on Flutter development, interface craft, and building products with clarity.',
                      style: GoogleFonts.manrope(
                        fontSize: isMobile ? 16 : 19,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurface.withValues(alpha: 0.58),
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 28 : 36),
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      BlogHeroActionButton(
                        label: 'Email Me',
                        icon: Icons.north_east_rounded,
                        isPrimary: true,
                        onPressed: () => ref.read(portfolioProvider.notifier).launchEmail(),
                      ),
                      BlogHeroActionButton(
                        label: 'Download CV',
                        icon: Icons.download_rounded,
                        onPressed: () => ref.read(portfolioProvider.notifier).launchResume(),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 28 : 40),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      BlogHeroPill(
                        icon: Icons.article_outlined,
                        label: '${state.blogPosts.length}+ Posts',
                      ),
                      const BlogHeroPill(
                        icon: Icons.draw_outlined,
                        label: 'Flutter & Product Notes',
                      ),
                      BlogHeroPill(
                        icon: Icons.location_on_outlined,
                        label: info.location,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BlogProfileCard(post: featuredPost),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../models/portfolio_models.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'blog_components.dart';

/// Blog page hero: intro copy, reading stats and a spotlight on the newest
/// post so readers can jump straight into something.
class BlogHeroSection extends ConsumerWidget {
  const BlogHeroSection({super.key, this.posts = const []});

  /// Public posts, newest first.
  final List<BlogPost> posts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hPad =
        isMobile
            ? 20.0
            : isTablet
            ? 48.0
            : 88.0;
    final latest = posts.isEmpty ? null : posts.first;

    final intro = _HeroIntro(posts: posts, latest: latest);

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
      // Soft green glow behind the latest-post card.
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.55, -0.1),
            radius: 1.1,
            colors: [
              AppColors.primaryGreen.withValues(alpha: isDark ? 0.10 : 0.07),
              AppColors.primaryGreen.withValues(alpha: 0),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            hPad,
            isMobile ? 40 : 72,
            hPad,
            isMobile ? 48 : 80,
          ),
          child:
              latest == null
                  ? intro
                  : isMobile || isTablet
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      intro,
                      const SizedBox(height: 40),
                      _LatestPostCard(post: latest),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: intro),
                      const SizedBox(width: 64),
                      Expanded(flex: 5, child: _LatestPostCard(post: latest)),
                    ],
                  ),
        ),
      ),
    );
  }
}

class _HeroIntro extends ConsumerWidget {
  const _HeroIntro({required this.posts, required this.latest});

  final List<BlogPost> posts;
  final BlogPost? latest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(portfolioProvider).personalInfo;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withValues(alpha: 0.58);

    final totalMinutes = posts.fold<int>(
      0,
      (sum, p) => sum + p.readingTimeMinutes,
    );
    final topicCount = posts.expand((p) => p.tags).toSet().length;

    return Column(
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
              color: muted,
              height: 1.6,
            ),
          ),
        ),
        SizedBox(height: isMobile ? 24 : 32),
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              backgroundImage: const AssetImage(
                'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Written by ',
                      style: TextStyle(color: muted),
                    ),
                    TextSpan(
                      text: info.name,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (info.title.isNotEmpty)
                      TextSpan(
                        text: '  ·  ${info.title}',
                        style: TextStyle(color: muted),
                      ),
                  ],
                ),
                style: GoogleFonts.manrope(fontSize: 14),
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 28 : 36),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            if (latest != null)
              BlogHeroActionButton(
                label: 'Start reading',
                icon: Icons.auto_stories_outlined,
                isPrimary: true,
                onPressed: () => openBlogPost(context, latest!),
              ),
            BlogHeroActionButton(
              label: 'Email me',
              icon: Icons.north_east_rounded,
              isPrimary: latest == null,
              onPressed:
                  () => ref.read(portfolioProvider.notifier).launchEmail(),
            ),
          ],
        ),
        if (posts.isNotEmpty) ...[
          SizedBox(height: isMobile ? 32 : 44),
          Wrap(
            spacing: isMobile ? 24 : 36,
            runSpacing: 16,
            children: [
              _HeroStat(
                value: '${posts.length}',
                label: posts.length == 1 ? 'Post' : 'Posts',
              ),
              _HeroStat(value: '$totalMinutes min', label: 'Of reading'),
              if (topicCount > 0)
                _HeroStat(
                  value: '$topicCount',
                  label: topicCount == 1 ? 'Topic' : 'Topics',
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(left: 14),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}

/// Clickable preview of the newest post.
class _LatestPostCard extends StatefulWidget {
  const _LatestPostCard({required this.post});

  final BlogPost post;

  @override
  State<_LatestPostCard> createState() => _LatestPostCardState();
}

class _LatestPostCardState extends State<_LatestPostCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withValues(alpha: 0.55);
    const radius = 28.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: blogCardColor(context),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color:
                _hovered
                    ? AppColors.primaryGreen.withValues(alpha: 0.5)
                    : colorScheme.onSurface.withValues(alpha: 0.08),
          ),
          boxShadow:
              Theme.of(context).brightness == Brightness.dark
                  ? blogCardShadow(context, hovered: _hovered)
                  : [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: _hovered ? 0.1 : 0.06,
                      ),
                      blurRadius: 36,
                      offset: const Offset(0, 20),
                    ),
                  ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: () => openBlogPost(context, post),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(radius - 10),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (post.imageUrl.isEmpty)
                            ColoredBox(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.05,
                              ),
                            )
                          else
                            Image.network(
                              post.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => ColoredBox(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.05,
                                    ),
                                  ),
                            ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'LATEST',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${formatDate(post.publishDate)}  ·  ${post.readingTimeMinutes} min read',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: muted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          post.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            letterSpacing: -0.4,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          post.excerpt,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            height: 1.6,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Text(
                              'Read the story',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: blogAccent(context),
                              ),
                            ),
                            const SizedBox(width: 6),
                            AnimatedSlide(
                              offset: Offset(_hovered ? 0.25 : 0, 0),
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                                color: blogAccent(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

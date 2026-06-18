import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/app_colors.dart';
import '../../../models/portfolio_models.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../utils/responsive_helper.dart';
import '../../../widgets/shared/custom_widgets.dart';
import '../../../widgets/shared/footer_section.dart';

class BlogPage extends ConsumerWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(portfolioProvider).blogPosts;

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: posts.isEmpty
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BlogHeroSection(),
                  _EmptyBlogState(),
                  FooterSection(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BlogHeroSection(featuredPost: posts.first),
                  _BlogFeaturedSection(featuredPost: posts.first),
                  _BlogPostsSection(posts: posts),
                  const FooterSection(),
                ],
              ),
      ),
    );
  }
}

class _BlogHeroSection extends ConsumerWidget {
  const _BlogHeroSection({this.featuredPost});

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
                      _HeroActionButton(
                        label: 'Email Me',
                        icon: Icons.north_east_rounded,
                        isPrimary: true,
                        onPressed: () => ref.read(portfolioProvider.notifier).launchEmail(),
                      ),
                      _HeroActionButton(
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
                      _HeroPill(
                        icon: Icons.article_outlined,
                        label: '${state.blogPosts.length}+ Posts',
                      ),
                      _HeroPill(
                        icon: Icons.draw_outlined,
                        label: 'Flutter & Product Notes',
                      ),
                      _HeroPill(
                        icon: Icons.location_on_outlined,
                        label: info.location,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _BlogProfileCard(post: featuredPost),
          ],
        ),
      ),
    );
  }
}

class _BlogFeaturedSection extends StatelessWidget {
  const _BlogFeaturedSection({required this.featuredPost});

  final BlogPost featuredPost;

  @override
  Widget build(BuildContext context) {
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
          const _SectionHeading(
            eyebrow: '{01} - Featured Story',
            title: 'A highlighted post right at the top.',
            description:
                'The latest or most important write-up gets a larger spotlight before the full list of posts below.',
          ),
          const SizedBox(height: 24),
          _FeaturedPostCard(post: featuredPost),
        ],
      ),
    );
  }
}

class _BlogPostsSection extends StatelessWidget {
  const _BlogPostsSection({required this.posts});

  final List<BlogPost> posts;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hPad =
        isMobile
            ? 20.0
            : isTablet
            ? 48.0
            : 88.0;
    final remainingPosts = posts.length > 1 ? posts.sublist(1) : posts;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        hPad,
        isMobile ? 48 : 80,
        hPad,
        isMobile ? 48 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeading(
            eyebrow: '{02} - All Posts',
            title: 'Blogs shown directly underneath the hero.',
            description:
                'Browse through the writing archive in a cleaner card layout that is easier to scan on desktop and mobile.',
          ),
          const SizedBox(height: 24),
          if (remainingPosts.isEmpty)
            BlogCard(
              title: posts.first.title,
              excerpt: posts.first.excerpt,
              imageUrl: posts.first.imageUrl,
              publishDate: posts.first.publishDate,
              tags: posts.first.tags,
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final useSingleColumn = constraints.maxWidth < 1000;

                if (useSingleColumn) {
                  return Column(
                    children: [
                      for (int i = 0; i < remainingPosts.length; i++) ...[
                        _BlogPostTile(post: remainingPosts[i]),
                        if (i != remainingPosts.length - 1)
                          const SizedBox(height: 24),
                      ],
                    ],
                  );
                }

                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: remainingPosts
                      .map(
                        (post) => SizedBox(
                          width: (constraints.maxWidth - 24) / 2,
                          child: _BlogPostTile(post: post),
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

class _BlogPostTile extends StatelessWidget {
  const _BlogPostTile({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showBlogPost(context, post),
      child: BlogCard(
        title: post.title,
        excerpt: post.excerpt,
        imageUrl: post.imageUrl,
        publishDate: post.publishDate,
        tags: post.tags,
      ),
    );
  }
}

class _FeaturedPostCard extends StatelessWidget {
  const _FeaturedPostCard({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 22 : 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2C1E), Color(0xFF144733)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 620,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'FEATURED',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  post.title,
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 30 : 42,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.04,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  post.excerpt,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    height: 1.7,
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 16,
                  runSpacing: 10,
                  children: [
                    _MetaText(
                      icon: FontAwesomeIcons.calendarDays,
                      label: _formatDate(post.publishDate),
                      color: Colors.white.withValues(alpha: 0.76),
                    ),
                    _MetaText(
                      icon: FontAwesomeIcons.user,
                      label: post.author,
                      color: Colors.white.withValues(alpha: 0.76),
                    ),
                    _MetaText(
                      icon: FontAwesomeIcons.clock,
                      label: '${post.readingTimeMinutes} min read',
                      color: Colors.white.withValues(alpha: 0.76),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top tags',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: post.tags
                      .take(4)
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showBlogPost(context, post),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF143927),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_stories_outlined, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        'Read Story',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlogProfileCard extends ConsumerWidget {
  const _BlogProfileCard({this.post});

  final BlogPost? post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = ResponsiveHelper.isMobile(context);

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
            'Writing Focus',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Short, practical notes around Flutter, product thinking, and interface execution.',
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.65),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),
          _ProfileMetric(
            value: '${ref.watch(portfolioProvider).blogPosts.length}+',
            label: 'Published posts available to read',
          ),
          const SizedBox(height: 14),
          _ProfileMetric(
            value: post == null ? 'Live' : '${post!.readingTimeMinutes} min',
            label:
                post == null
                    ? 'Fresh writing from connected sources'
                    : 'Reading time for the featured post',
          ),
          const SizedBox(height: 14),
          _ProfileMetric(
            value: post == null ? 'Notes' : '${post!.tags.length}',
            label:
                post == null
                    ? 'Focused on useful development insights'
                    : 'Tags attached to the featured article',
          ),
        ],
      ),
    );
  }
}

class _EmptyBlogState extends StatelessWidget {
  const _EmptyBlogState();

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          'No blog posts are available yet. Once posts are connected, they will appear here below the hero section.',
          style: GoogleFonts.manrope(fontSize: 16, height: 1.7),
        ),
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final buttonStyle =
        isPrimary
            ? ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              elevation: 0,
            )
            : OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              side: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            );

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );

    return isPrimary
        ? ElevatedButton(onPressed: onPressed, style: buttonStyle, child: child)
        : OutlinedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryGreen),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String eyebrow;
  final String title;
  final String description;

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
        const SizedBox(height: 14),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 30 : 42,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            height: 1.04,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            description,
            style: GoogleFonts.manrope(
              fontSize: 16,
              height: 1.7,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, size: 13, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
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
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.72),
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _formatDate(DateTime date) {
  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
}

void _showBlogPost(BuildContext context, BlogPost post) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 720),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 10,
                children: [
                  _MetaText(
                    icon: FontAwesomeIcons.calendarDays,
                    label: _formatDate(post.publishDate),
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  _MetaText(
                    icon: FontAwesomeIcons.user,
                    label: post.author,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  _MetaText(
                    icon: FontAwesomeIcons.clock,
                    label: '${post.readingTimeMinutes} min read',
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                post.content,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  height: 1.8,
                  color: colorScheme.onSurface.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: post.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AppColors.darkGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'Close',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


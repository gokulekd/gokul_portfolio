import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../models/portfolio_models.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'blog_components.dart';

class BlogPostsSection extends StatelessWidget {
  const BlogPostsSection({
    super.key,
    required this.posts,
    this.eyebrow = '{02} - All Posts',
  });

  final List<BlogPost> posts;
  final String eyebrow;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlogSectionHeading(
            eyebrow: eyebrow,
            title: 'Notes from building with Flutter.',
            description:
                'Practical write-ups on widgets, state and the small details that make apps feel right. Newest first.',
          ),
          const SizedBox(height: 32),
          BlogPostGrid(posts: posts),
        ],
      ),
    );
  }
}

/// Responsive grid of [BlogPostTile]s (3/2/1 columns by width) laid out in
/// equal-height rows.
class BlogPostGrid extends StatelessWidget {
  const BlogPostGrid({super.key, required this.posts});

  final List<BlogPost> posts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 24.0;
        final columns =
            constraints.maxWidth >= 1100
                ? 3
                : constraints.maxWidth >= 640
                ? 2
                : 1;

        // Rows of equal-height tiles so cards line up side by side.
        return Column(
          children: [
            for (int start = 0; start < posts.length; start += columns) ...[
              if (start > 0) const SizedBox(height: gap),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < columns; i++) ...[
                      if (i > 0) const SizedBox(width: gap),
                      Expanded(
                        child:
                            start + i < posts.length
                                ? BlogPostTile(post: posts[start + i])
                                : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class BlogPostTile extends StatefulWidget {
  const BlogPostTile({super.key, required this.post});

  final BlogPost post;

  @override
  State<BlogPostTile> createState() => _BlogPostTileState();
}

class _BlogPostTileState extends State<BlogPostTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withValues(alpha: 0.55);
    final accent = blogAccent(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const radius = 20.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedSlide(
        offset: Offset(0, _hovered ? -0.01 : 0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: blogCardColor(context),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color:
                  _hovered
                      ? AppColors.primaryGreen.withValues(alpha: 0.5)
                      : colorScheme.onSurface.withValues(alpha: 0.08),
            ),
            boxShadow: blogCardShadow(context, hovered: _hovered),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: () => openBlogPost(context, post),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(radius - 1),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child:
                          post.imageUrl.isEmpty
                              ? _ImagePlaceholder(color: colorScheme.onSurface)
                              : Image.network(
                                post.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => _ImagePlaceholder(
                                      color: colorScheme.onSurface,
                                    ),
                              ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
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
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              letterSpacing: -0.3,
                              color:
                                  _hovered
                                      ? accent
                                      : colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            post.excerpt,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              height: 1.6,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: post.tags
                                      .take(3)
                                      .map(
                                        (tag) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: accent.withValues(
                                              alpha: isDark ? 0.14 : 0.08,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            tag,
                                            style: GoogleFonts.manrope(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: accent,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(growable: false),
                                ),
                              ),
                              const SizedBox(width: 12),
                              AnimatedSlide(
                                offset: Offset(_hovered ? 0.15 : 0, 0),
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                  color: _hovered ? accent : muted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(alpha: 0.05),
      alignment: Alignment.center,
      child: Icon(
        Icons.article_outlined,
        size: 40,
        color: color.withValues(alpha: 0.25),
      ),
    );
  }
}

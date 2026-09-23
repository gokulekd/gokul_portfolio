import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../models/portfolio_models.dart';
import '../../../../core/utils/blog_source.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'blog_components.dart';

/// "All Posts" list with a search box and tag filter. While either is
/// active the results come from [searchablePosts] (every post, featured one
/// included) rather than just the grid's [posts].
class BlogPostsSection extends StatefulWidget {
  const BlogPostsSection({
    super.key,
    required this.posts,
    List<BlogPost>? searchablePosts,
    this.eyebrow = '{02} - All Posts',
  }) : searchablePosts = searchablePosts ?? posts;

  final List<BlogPost> posts;
  final List<BlogPost> searchablePosts;
  final String eyebrow;

  @override
  State<BlogPostsSection> createState() => _BlogPostsSectionState();
}

class _BlogPostsSectionState extends State<BlogPostsSection> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _tag;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isFiltering => _query.trim().isNotEmpty || _tag != null;

  /// Tags across all posts, most used first.
  List<String> get _tags {
    final counts = <String, int>{};
    for (final post in widget.searchablePosts) {
      for (final tag in post.tags) {
        counts[tag] = (counts[tag] ?? 0) + 1;
      }
    }
    return counts.keys.toList()
      ..sort((a, b) {
        final byCount = counts[b]!.compareTo(counts[a]!);
        return byCount != 0 ? byCount : a.toLowerCase().compareTo(b.toLowerCase());
      });
  }

  /// Every word of the query must appear in the title, excerpt, a tag or
  /// the platform name ("medium", "linkedin"...).
  bool _matches(BlogPost post) {
    if (_tag != null && !post.tags.contains(_tag)) return false;
    final words = _query.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    if (words.isEmpty) return true;
    final haystack = [
      post.title,
      post.excerpt,
      ...post.tags,
      BlogSource.fromUrl(post.url)?.name ?? '',
    ].join(' ').toLowerCase();
    return words.every(haystack.contains);
  }

  void _clear() {
    _searchController.clear();
    setState(() {
      _query = '';
      _tag = null;
    });
  }

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

    final results =
        _isFiltering
            ? widget.searchablePosts.where(_matches).toList()
            : widget.posts;

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
            eyebrow: widget.eyebrow,
            title: 'Notes from building with Flutter.',
            description:
                'Practical write-ups on widgets, state and the small details that make apps feel right. Newest first.',
          ),
          const SizedBox(height: 28),
          _BlogSearchField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            onClear: () {
              _searchController.clear();
              setState(() => _query = '');
            },
          ),
          if (_tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            _TagFilterBar(
              tags: _tags,
              selected: _tag,
              scrollable: isMobile,
              onSelected: (tag) => setState(() => _tag = tag),
            ),
          ],
          if (_isFiltering) ...[
            const SizedBox(height: 18),
            _ResultsSummary(count: results.length, onClear: _clear),
          ],
          const SizedBox(height: 28),
          if (results.isEmpty)
            _NoResults(onClear: _clear)
          else
            BlogPostGrid(posts: results),
        ],
      ),
    );
  }
}

class _BlogSearchField extends StatelessWidget {
  const _BlogSearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = blogAccent(context);
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: GoogleFonts.manrope(fontSize: 15, color: onSurface),
        cursorColor: accent,
        decoration: InputDecoration(
          hintText: 'Search posts, tags or platforms…',
          hintStyle: GoogleFonts.manrope(
            fontSize: 15,
            color: onSurface.withValues(alpha: 0.45),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: onSurface.withValues(alpha: 0.5),
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder:
                (context, value, _) =>
                    value.text.isEmpty
                        ? const SizedBox.shrink()
                        : IconButton(
                          tooltip: 'Clear search',
                          icon: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: onSurface.withValues(alpha: 0.6),
                          ),
                          onPressed: onClear,
                        ),
          ),
          filled: true,
          fillColor:
              isDark ? blogCardColor(context) : onSurface.withValues(alpha: 0.03),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          enabledBorder: border(onSurface.withValues(alpha: 0.10)),
          focusedBorder: border(AppColors.primaryGreen.withValues(alpha: 0.7), 1.5),
        ),
      ),
    );
  }
}

class _TagFilterBar extends StatelessWidget {
  const _TagFilterBar({
    required this.tags,
    required this.selected,
    required this.scrollable,
    required this.onSelected,
  });

  final List<String> tags;
  final String? selected;

  /// One swipeable row on phones; wrapping rows elsewhere.
  final bool scrollable;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final chips = [
      _FilterChip(
        label: 'All',
        selected: selected == null,
        onTap: () => onSelected(null),
      ),
      for (final tag in tags)
        _FilterChip(
          label: tag,
          selected: selected == tag,
          onTap: () => onSelected(selected == tag ? null : tag),
        ),
    ];

    if (!scrollable) {
      return Wrap(spacing: 8, runSpacing: 8, children: chips);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (int i = 0; i < chips.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            chips[i],
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = blogAccent(context);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color:
                selected
                    ? accent.withValues(alpha: isDark ? 0.18 : 0.10)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color:
                  selected
                      ? accent.withValues(alpha: 0.6)
                      : onSurface.withValues(alpha: 0.12),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? accent : onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultsSummary extends StatelessWidget {
  const _ResultsSummary({required this.count, required this.onClear});

  final int count;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        Text(
          count == 1 ? '1 post found' : '$count posts found',
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onClear,
          style: TextButton.styleFrom(
            foregroundColor: blogAccent(context),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 32),
          ),
          child: Text(
            'Clear filters',
            style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: onSurface.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 40,
            color: onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'No posts match your search.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try a different word or pick another tag.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: onSurface.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onClear,
            style: TextButton.styleFrom(foregroundColor: blogAccent(context)),
            child: Text(
              'Clear filters',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// Responsive list of posts: a 3- or 2-column grid of equal-height
/// [BlogPostTile]s on wide screens, and a list of [BlogPostListItem]s below
/// 1000px (roomier on tablets, compact on phones) so posts never end up
/// orphaned in a half-empty row.
class BlogPostGrid extends StatelessWidget {
  const BlogPostGrid({super.key, required this.posts});

  final List<BlogPost> posts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 24.0;
        if (constraints.maxWidth < 1000) {
          final large = constraints.maxWidth >= 600;
          return Column(
            children: [
              for (int i = 0; i < posts.length; i++)
                BlogPostListItem(
                  post: posts[i],
                  large: large,
                  showDivider: i != posts.length - 1,
                ),
            ],
          );
        }
        final columns = constraints.maxWidth >= 1100 ? 3 : 2;

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
    final source = BlogSource.fromUrl(post.url);
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
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
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
                          if (source != null)
                            Positioned(
                              top: 14,
                              left: 14,
                              child: BlogSourceBadge(source: source),
                            ),
                        ],
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
                              color: _hovered ? accent : colorScheme.onSurface,
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
                                  source != null
                                      ? Icons.north_east_rounded
                                      : Icons.arrow_forward_rounded,
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

/// Medium-style list row: text on the left, a 16:9 thumbnail on the right.
class BlogPostListItem extends StatelessWidget {
  const BlogPostListItem({
    super.key,
    required this.post,
    this.showDivider = true,
    this.large = false,
  });

  final BlogPost post;
  final bool showDivider;

  /// Bigger type and thumbnail for tablets.
  final bool large;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withValues(alpha: 0.55);
    final accent = blogAccent(context);
    final source = BlogSource.fromUrl(post.url);

    return InkWell(
      onTap: () => openBlogPost(context, post),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: large ? 28 : 20),
        decoration: BoxDecoration(
          border:
              showDivider
                  ? Border(
                    bottom: BorderSide(
                      color: colorScheme.onSurface.withValues(alpha: 0.08),
                    ),
                  )
                  : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.tags.isNotEmpty) ...[
                    Text(
                      post.tags.first.toUpperCase(),
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    post.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: large ? 21 : 17,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -0.2,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    post.excerpt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: large ? 15 : 13,
                      height: 1.5,
                      color: colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (source != null)
                        BlogSourceBadge(source: source, subtle: true),
                      Text(
                        '${formatDate(post.publishDate)}  ·  ${post.readingTimeMinutes} min read',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: large ? 28 : 16),
            // 16:9 like the covers, so their title text isn't cropped.
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: large ? 224 : 112,
                  height: large ? 126 : 63,
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
            ),
          ],
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

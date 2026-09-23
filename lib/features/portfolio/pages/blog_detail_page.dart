import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/providers/portfolio_provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/responsive_helper.dart';
import '../models/portfolio_models.dart';
import '../widgets/blog/blog_components.dart';
import '../widgets/shared/custom_widgets.dart';

/// Medium-style reader for a single blog post, reached via `/blog/:id`.
class BlogDetailPage extends ConsumerStatefulWidget {
  const BlogDetailPage({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends ConsumerState<BlogDetailPage> {
  final _scrollController = ScrollController();
  final _progress = ValueNotifier<double>(0);
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);

    // On a deep link / hard refresh the blog feed may not be loaded yet, so
    // fetch it once before deciding the post doesn't exist.
    final loaded = ref
        .read(portfolioProvider)
        .publicBlogPosts
        .any((p) => p.id == widget.postId);
    if (!loaded) {
      _isFetching = true;
      ref.read(portfolioProvider.notifier).refreshAdminBlogPosts().whenComplete(
        () {
          if (mounted) setState(() => _isFetching = false);
        },
      );
    }
  }

  void _updateProgress() {
    final position = _scrollController.position;
    final max = position.maxScrollExtent;
    _progress.value = max <= 0 ? 0 : (position.pixels / max).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _progress.dispose();
    super.dispose();
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.blog);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(portfolioProvider);
    final posts = state.publicBlogPosts;
    final post = posts.cast<BlogPost?>().firstWhere(
      (p) => p?.id == widget.postId,
      orElse: () => null,
    );

    if (post == null) {
      return Scaffold(
        appBar: const CustomAppBar(),
        drawer: const CustomDrawer(),
        body: Center(
          child: _isFetching
              ? const CircularProgressIndicator(color: AppColors.primaryGreen)
              : _NotFound(onBack: _goBack),
        ),
      );
    }

    final morePosts = posts.where((p) => p.id != post.id).take(3).toList();

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _ReadingColumn(
                  child: _ArticleBody(post: post, onBack: _goBack),
                ),
                if (morePosts.isNotEmpty) _MoreStories(posts: morePosts),
                const FooterSection(),
              ],
            ),
          ),
          // Reading progress bar.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _progress,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 3,
                backgroundColor: Colors.transparent,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Centers content in a comfortable ~700px measure, like Medium.
class _ReadingColumn extends StatelessWidget {
  const _ReadingColumn({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 728),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 20 : 24,
            isMobile ? 24 : 48,
            isMobile ? 20 : 24,
            isMobile ? 48 : 72,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ArticleBody extends StatelessWidget {
  const _ArticleBody({required this.post, required this.onBack});

  final BlogPost post;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withValues(alpha: 0.6);
    final divider = colorScheme.onSurface.withValues(alpha: 0.1);

    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: onBack,
            style: TextButton.styleFrom(
              foregroundColor: muted,
              padding: EdgeInsets.zero,
            ),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: Text(
              'All stories',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 20 : 32),
          Text(
            post.title,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 32 : 44,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              height: 1.15,
              letterSpacing: -1,
            ),
          ),
          if (post.excerpt.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              post.excerpt,
              style: GoogleFonts.manrope(
                fontSize: isMobile ? 18 : 21,
                height: 1.5,
                color: muted,
              ),
            ),
          ],
          const SizedBox(height: 28),
          _AuthorRow(post: post, muted: muted),
          const SizedBox(height: 20),
          Divider(color: divider, height: 1),
          const SizedBox(height: 32),
          if (post.imageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: colorScheme.onSurface.withValues(alpha: 0.05),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
          ..._buildContent(post.content, colorScheme, isMobile),
          const SizedBox(height: 40),
          if (post.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: post.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          const SizedBox(height: 32),
          Divider(color: divider, height: 1),
        ],
      ),
    );
  }

  /// Renders plain-text content as paragraphs split on blank lines, with light
  /// support for headings (`#`/`##` or a short ALL-CAPS line), `>` quotes and
  /// `-`/`*` bullet lists.
  List<Widget> _buildContent(
    String content,
    ColorScheme colorScheme,
    bool isMobile,
  ) {
    final bodyStyle = GoogleFonts.manrope(
      fontSize: isMobile ? 18 : 20,
      height: 1.75,
      color: colorScheme.onSurface.withValues(alpha: 0.85),
    );
    final blocks = content
        .trim()
        .split(RegExp(r'\n\s*\n'))
        .map((b) => b.trim())
        .where((b) => b.isNotEmpty);

    final widgets = <Widget>[];
    for (final block in blocks) {
      Widget child;
      final isCapsHeading = !block.contains('\n') &&
          block.length <= 80 &&
          RegExp('[A-Z]').hasMatch(block) &&
          block == block.toUpperCase();
      if (block.startsWith('#') || isCapsHeading) {
        child = Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            block.replaceFirst(RegExp(r'^#+\s*'), ''),
            style: GoogleFonts.inter(
              fontSize: isMobile ? 22 : 26,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1.3,
            ),
          ),
        );
      } else if (block.startsWith('>')) {
        child = Container(
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: colorScheme.onSurface, width: 3),
            ),
          ),
          child: Text(
            block
                .split('\n')
                .map((l) => l.replaceFirst(RegExp(r'^>\s?'), ''))
                .join('\n'),
            style: bodyStyle.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      } else if (RegExp(r'^[-*]\s').hasMatch(block)) {
        child = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: block
              .split('\n')
              .map(
                (line) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('•  ', style: bodyStyle),
                      Expanded(
                        child: Text(
                          line.replaceFirst(RegExp(r'^[-*]\s*'), ''),
                          style: bodyStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(growable: false),
        );
      } else {
        child = Text(block, style: bodyStyle);
      }
      widgets.add(
        Padding(padding: const EdgeInsets.only(bottom: 28), child: child),
      );
    }
    return widgets;
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.post, required this.muted});

  final BlogPost post;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.darkGreen,
          backgroundImage: const AssetImage(
            'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.author,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${post.readingTimeMinutes} min read  ·  ${formatDate(post.publishDate)}',
                style: GoogleFonts.manrope(fontSize: 13, color: muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MoreStories extends StatelessWidget {
  const _MoreStories({required this.posts});

  final List<BlogPost> posts;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.onSurface.withValues(alpha: 0.03),
      child: _ReadingColumn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'More stories',
              style: GoogleFonts.inter(
                fontSize: isMobile ? 22 : 26,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            for (final post in posts)
              InkWell(
                onTap: () => context.go(AppRoutes.blogPost(post.id)),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          height: 1.3,
                        ),
                      ),
                      if (post.excerpt.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          post.excerpt,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            height: 1.5,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        '${formatDate(post.publishDate)}  ·  ${post.readingTimeMinutes} min read',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.article_outlined, size: 64, color: Colors.black26),
        const SizedBox(height: 16),
        Text(
          'Story not found',
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onBack,
          child: Text('Back to blog', style: GoogleFonts.manrope(fontSize: 15)),
        ),
      ],
    );
  }
}

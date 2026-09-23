import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/providers/portfolio_provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/responsive_helper.dart';
import '../models/portfolio_models.dart';
import '../widgets/blog/blog_components.dart';
import '../widgets/blog/blog_posts_section.dart';
import '../widgets/shared/custom_widgets.dart';

const _kAuthorPhoto = 'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg';

/// Width of the text column — a comfortable ~70 characters per line.
const _kTextWidth = 700.0;

/// Width the cover image breaks out to, wider than the text column.
const _kWideWidth = 1040.0;

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
    final isMobile = ResponsiveHelper.isMobile(context);
    final hPad = isMobile ? 20.0 : 32.0;

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _ArticleHeader(post: post, onBack: _goBack, hPad: hPad),
                if (post.imageUrl.isNotEmpty)
                  _Constrained(
                    maxWidth: _kWideWidth,
                    hPad: isMobile ? 0 : hPad,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(isMobile ? 0 : 20),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          post.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => ColoredBox(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                    ),
                  ),
                _Constrained(
                  maxWidth: _kTextWidth,
                  hPad: hPad,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: isMobile ? 36 : 56,
                      bottom: isMobile ? 48 : 72,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectionArea(
                          child: _ArticleContent(content: post.content),
                        ),
                        const SizedBox(height: 16),
                        _ArticleFooter(post: post),
                        const SizedBox(height: 40),
                        const _AuthorCard(),
                      ],
                    ),
                  ),
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

/// Centers [child] at up to [maxWidth] with horizontal padding.
class _Constrained extends StatelessWidget {
  const _Constrained({
    required this.maxWidth,
    required this.hPad,
    required this.child,
  });

  final double maxWidth;
  final double hPad;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth + hPad * 2),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: child,
        ),
      ),
    );
  }
}

class _ArticleHeader extends StatelessWidget {
  const _ArticleHeader({
    required this.post,
    required this.onBack,
    required this.hPad,
  });

  final BlogPost post;
  final VoidCallback onBack;
  final double hPad;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withValues(alpha: 0.6);

    return _Constrained(
      maxWidth: _kTextWidth,
      hPad: hPad,
      child: Padding(
        padding: EdgeInsets.only(
          top: isMobile ? 24 : 48,
          bottom: isMobile ? 28 : 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: onBack,
              style: TextButton.styleFrom(
                foregroundColor: muted,
                padding: const EdgeInsets.symmetric(horizontal: 4),
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
            if (post.tags.isNotEmpty) ...[
              Text(
                post.tags.take(3).map((t) => t.toUpperCase()).join('  /  '),
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 16),
            ],
            SelectionArea(
              child: Text(
                post.title,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 34 : 48,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                  height: 1.12,
                  letterSpacing: isMobile ? -1 : -1.6,
                ),
              ),
            ),
            if (post.excerpt.isNotEmpty) ...[
              const SizedBox(height: 18),
              Text(
                post.excerpt,
                style: GoogleFonts.manrope(
                  fontSize: isMobile ? 18 : 21,
                  height: 1.55,
                  color: muted,
                ),
              ),
            ],
            SizedBox(height: isMobile ? 28 : 36),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.darkGreen,
                    backgroundImage: AssetImage(_kAuthorPhoto),
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
                  _ShareButtons(post: post),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareButtons extends StatelessWidget {
  const _ShareButtons({required this.post});

  final BlogPost post;

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final link = Uri.base.toString();
    final encodedLink = Uri.encodeComponent(link);
    final encodedTitle = Uri.encodeComponent(post.title);
    final color = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    Widget button(IconData icon, String tooltip, VoidCallback onPressed) {
      return IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: FaIcon(icon, size: 17, color: color),
        visualDensity: VisualDensity.compact,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        button(FontAwesomeIcons.link, 'Copy link', () async {
          await Clipboard.setData(ClipboardData(text: link));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Link copied'),
              behavior: SnackBarBehavior.floating,
              width: 200,
              duration: Duration(seconds: 2),
            ),
          );
        }),
        button(
          FontAwesomeIcons.linkedinIn,
          'Share on LinkedIn',
          () => _open(
            'https://www.linkedin.com/sharing/share-offsite/?url=$encodedLink',
          ),
        ),
        button(
          FontAwesomeIcons.xTwitter,
          'Share on X',
          () => _open(
            'https://twitter.com/intent/tweet?url=$encodedLink&text=$encodedTitle',
          ),
        ),
      ],
    );
  }
}

/// Renders plain-text content as paragraphs split on blank lines, with light
/// support for headings (`#`/`##` or a short ALL-CAPS line), `>` quotes and
/// `-`/`*` bullet lists.
class _ArticleContent extends StatelessWidget {
  const _ArticleContent({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final colorScheme = Theme.of(context).colorScheme;
    final bodyStyle = GoogleFonts.manrope(
      fontSize: isMobile ? 18 : 19.5,
      height: 1.8,
      color: colorScheme.onSurface.withValues(alpha: 0.84),
    );
    final blocks = content
        .trim()
        .split(RegExp(r'\n\s*\n'))
        .map((b) => b.trim())
        .where((b) => b.isNotEmpty);

    final widgets = <Widget>[];
    for (final block in blocks) {
      final isCapsHeading = !block.contains('\n') &&
          block.length <= 80 &&
          RegExp('[A-Z]').hasMatch(block) &&
          block == block.toUpperCase();

      if (block.startsWith('#') || isCapsHeading) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(top: isMobile ? 16 : 24, bottom: 16),
            child: Text(
              _sentenceCase(block.replaceFirst(RegExp(r'^#+\s*'), '')),
              style: GoogleFonts.inter(
                fontSize: isMobile ? 24 : 28,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                height: 1.3,
                letterSpacing: -0.5,
              ),
            ),
          ),
        );
        continue;
      }

      Widget child;
      if (block.startsWith('>')) {
        child = Container(
          padding: const EdgeInsets.fromLTRB(22, 4, 0, 4),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: AppColors.primaryGreen, width: 3),
            ),
          ),
          child: Text(
            block
                .split('\n')
                .map((l) => l.replaceFirst(RegExp(r'^>\s?'), ''))
                .join('\n'),
            style: bodyStyle.copyWith(
              fontStyle: FontStyle.italic,
              fontSize: (bodyStyle.fontSize ?? 19) + 2,
              color: colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        );
      } else if (RegExp(r'^[-*]\s').hasMatch(block)) {
        child = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: block
              .split('\n')
              .map(
                (line) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: (bodyStyle.fontSize ?? 19) * 0.75,
                          right: 14,
                          left: 4,
                        ),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  /// `WHAT "STATE" ACTUALLY MEANS` -> `What "state" actually means`.
  static String _sentenceCase(String text) {
    if (text != text.toUpperCase()) return text;
    final lower = text.toLowerCase();
    final first = lower.indexOf(RegExp('[a-z]'));
    if (first < 0) return text;
    return lower.substring(0, first) +
        lower[first].toUpperCase() +
        lower.substring(first + 1);
  }
}

class _ArticleFooter extends StatelessWidget {
  const _ArticleFooter({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            '·  ·  ·',
            style: GoogleFonts.inter(
              fontSize: 22,
              letterSpacing: 4,
              color: colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ),
        ),
        const SizedBox(height: 32),
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
      ],
    );
  }
}

/// "Written by" card closing out the article.
class _AuthorCard extends ConsumerWidget {
  const _AuthorCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(portfolioProvider).personalInfo;
    final isMobile = ResponsiveHelper.isMobile(context);
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withValues(alpha: 0.6);

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WRITTEN BY',
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: muted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          info.name,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        if (info.title.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            info.title,
            style: GoogleFonts.manrope(fontSize: 14, color: muted),
          ),
        ],
        if (info.bio.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            info.bio.replaceAll(RegExp(r'\s+'), ' ').trim(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 14,
              height: 1.6,
              color: colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            BlogHeroActionButton(
              label: 'Email me',
              icon: Icons.north_east_rounded,
              isPrimary: true,
              onPressed: () =>
                  ref.read(portfolioProvider.notifier).launchEmail(),
            ),
            BlogHeroActionButton(
              label: 'About me',
              icon: Icons.person_outline_rounded,
              onPressed: () => context.go(AppRoutes.about),
            ),
          ],
        ),
      ],
    );

    const avatar = CircleAvatar(
      radius: 36,
      backgroundColor: AppColors.darkGreen,
      backgroundImage: AssetImage(_kAuthorPhoto),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 22 : 28),
      decoration: BoxDecoration(
        color: AppColors.darkGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.darkGreen.withValues(alpha: 0.12)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [avatar, const SizedBox(height: 16), text],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatar,
                const SizedBox(width: 24),
                Expanded(child: text),
              ],
            ),
    );
  }
}

class _MoreStories extends StatelessWidget {
  const _MoreStories({required this.posts});

  final List<BlogPost> posts;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.onSurface.withValues(alpha: 0.03),
      child: _Constrained(
        maxWidth: 1200,
        hPad: isMobile
            ? 20
            : isTablet
            ? 48
            : 88,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 48 : 72),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'More stories',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 26 : 32,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 28),
              BlogPostGrid(posts: posts),
            ],
          ),
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

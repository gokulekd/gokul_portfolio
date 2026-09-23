import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/providers/portfolio_provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/blog_source.dart';
import '../../../core/utils/native_share.dart';
import '../../../core/utils/responsive_helper.dart';
import '../models/portfolio_models.dart';
import '../widgets/blog/blog_components.dart';
import '../widgets/blog/blog_posts_section.dart';
import '../widgets/shared/custom_widgets.dart';

const _kAuthorPhoto =
    'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg';

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

  /// Whether the phone reading bar is shown: once past the article header,
  /// and hidden again at the very end where the author card and footer are.
  final _showBar = ValueNotifier<bool>(false);
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
    _showBar.value = position.pixels > 320 && _progress.value < 0.9;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _progress.dispose();
    _showBar.dispose();
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
          child:
              _isFetching
                  ? const CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  )
                  : _NotFound(onBack: _goBack),
        ),
      );
    }

    // Published elsewhere: there's no body to render here, so point to the
    // original (a button rather than an auto-redirect, which popup blockers
    // would stop).
    final externalUrl = post.url;
    if (externalUrl != null && externalUrl.isNotEmpty) {
      return Scaffold(
        appBar: const CustomAppBar(),
        drawer: const CustomDrawer(),
        body: Center(
          child: _ExternalPostNotice(
            post: post,
            onOpen: () => openBlogPost(context, post),
            onBack: _goBack,
          ),
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
                          errorBuilder:
                              (_, __, ___) => ColoredBox(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.05),
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
          if (isMobile)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: SafeArea(
                top: false,
                child: _MobileReadingBar(
                  post: post,
                  progress: _progress,
                  visible: _showBar,
                  onBack: _goBack,
                  onTop:
                      () => _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                      ),
                ),
              ),
            ),
          // Reading progress bar.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _progress,
              builder:
                  (context, value, _) => LinearProgressIndicator(
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
                  color: blogAccent(context),
                ),
              ),
              const SizedBox(height: 16),
            ],
            SelectionArea(
              child: Text(
                post.title,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 30 : 48,
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
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ShareButtons(post: post, compact: isMobile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A plain path, not the /#/ app route: link previews (WhatsApp, LinkedIn, X)
// never see anything after #. /blog/<id> is a static page with this post's
// preview tags that forwards to the app (built by
// scripts/generate_blog_share_pages.py). Always the canonical www host, and
// built from the post id rather than the address bar, which is stale when
// arriving from the blog list.
String _shareLink(BlogPost post) => 'https://www.gokulks.in/blog/${post.id}';

Future<void> _copyLink(BuildContext context, BlogPost post) async {
  await Clipboard.setData(ClipboardData(text: _shareLink(post)));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Link copied'),
      behavior: SnackBarBehavior.floating,
      width: 200,
      duration: Duration(seconds: 2),
    ),
  );
}

/// Opens the phone's share sheet (WhatsApp, LinkedIn, Messages...), or copies
/// the link where there is none.
Future<void> _shareNatively(BuildContext context, BlogPost post) async {
  if (hasNativeShare) {
    try {
      await SharePlus.instance.share(
        ShareParams(uri: Uri.parse(_shareLink(post)), title: post.title),
      );
      return;
    } catch (_) {
      // Fall through to copying the link.
    }
  }
  if (context.mounted) await _copyLink(context, post);
}

class _ShareButtons extends StatelessWidget {
  const _ShareButtons({required this.post, this.compact = false});

  final BlogPost post;

  /// A single share-sheet button instead of copy/LinkedIn/X, for phones
  /// where the byline has no room for three icons.
  final bool compact;

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final encodedLink = Uri.encodeComponent(_shareLink(post));
    final encodedTitle = Uri.encodeComponent(post.title);
    final color = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.6);

    Widget button(IconData icon, String tooltip, VoidCallback onPressed) {
      return IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: FaIcon(icon, size: 17, color: color),
        visualDensity: VisualDensity.compact,
      );
    }

    if (compact) {
      return button(
        FontAwesomeIcons.shareNodes,
        'Share',
        () => _shareNatively(context, post),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        button(
          FontAwesomeIcons.link,
          'Copy link',
          () => _copyLink(context, post),
        ),
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

/// Floating bar shown on phones while reading: back, time left, back to top
/// and share.
class _MobileReadingBar extends StatelessWidget {
  const _MobileReadingBar({
    required this.post,
    required this.progress,
    required this.visible,
    required this.onBack,
    required this.onTop,
  });

  final BlogPost post;
  final ValueListenable<double> progress;
  final ValueListenable<bool> visible;
  final VoidCallback onBack;
  final VoidCallback onTop;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withValues(alpha: 0.7);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<bool>(
      valueListenable: visible,
      builder:
          (context, show, child) => IgnorePointer(
            ignoring: !show,
            child: AnimatedSlide(
              offset: Offset(0, show ? 0 : 1.6),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: show ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: child,
              ),
            ),
          ),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: blogCardColor(context),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: 'All stories',
              onPressed: onBack,
              icon: Icon(Icons.arrow_back_rounded, color: muted),
            ),
            Expanded(
              child: ValueListenableBuilder<double>(
                valueListenable: progress,
                builder: (context, value, _) {
                  final left = (post.readingTimeMinutes * (1 - value)).ceil();
                  return Text(
                    left <= 0 ? 'Almost done' : '$left min left',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: muted,
                    ),
                  );
                },
              ),
            ),
            IconButton(
              tooltip: 'Back to top',
              onPressed: onTop,
              icon: Icon(Icons.vertical_align_top_rounded, color: muted),
            ),
            const SizedBox(width: 2),
            FilledButton.icon(
              onPressed: () => _shareNatively(context, post),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                visualDensity: VisualDensity.compact,
              ),
              icon: const FaIcon(FontAwesomeIcons.shareNodes, size: 14),
              label: Text(
                'Share',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

/// Renders plain-text content as paragraphs split on blank lines, with light
/// support for headings (`#`/`##` or a short ALL-CAPS line), subheadings (a
/// short first line leading a paragraph), `>` quotes and `-`/`*` bullets.
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

    final casing = _wordCasing(content);

    final widgets = <Widget>[];
    for (final block in blocks) {
      final isCapsHeading =
          !block.contains('\n') &&
          block.length <= 80 &&
          RegExp('[A-Z]').hasMatch(block) &&
          block == block.toUpperCase();

      if (block.startsWith('#') || isCapsHeading) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(top: isMobile ? 16 : 24, bottom: 16),
            child: Text(
              _sentenceCase(block.replaceFirst(RegExp(r'^#+\s*'), ''), casing),
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

      // A short first line without end punctuation followed by more text is
      // a subheading, e.g. "Riverpod\nMade by the author of Provider...".
      final lines = block.split('\n');
      final isSubheading =
          lines.length > 1 &&
          lines.first.length <= 60 &&
          !RegExp(r'[.,:;!?]$').hasMatch(lines.first.trim()) &&
          !RegExp(r'^([-*>]|#)').hasMatch(lines.first);

      Widget child;
      if (isSubheading) {
        child = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lines.first.trim(),
              style: GoogleFonts.inter(
                fontSize: isMobile ? 19 : 21,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 6),
            Text(lines.skip(1).join('\n'), style: bodyStyle),
          ],
        );
      } else if (block.startsWith('>')) {
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

  /// Maps lowercase words to how the article body writes them, for words
  /// that must keep their casing: camelCase identifiers (setState) and names
  /// that never appear lowercase (Flutter, Riverpod).
  static Map<String, String> _wordCasing(String content) {
    final mixed = <String, String>{};
    final lowerSeen = <String>{};
    for (final m in RegExp(r'[A-Za-z][A-Za-z0-9]*').allMatches(content)) {
      final word = m[0]!;
      if (word == word.toUpperCase()) continue; // headings, acronyms
      if (word == word.toLowerCase()) {
        lowerSeen.add(word);
      } else {
        mixed.putIfAbsent(word.toLowerCase(), () => word);
      }
    }
    return {
      for (final e in mixed.entries)
        if (e.value.substring(1) != e.value.substring(1).toLowerCase() ||
            !lowerSeen.contains(e.key))
          e.key: e.value,
    };
  }

  /// `START SIMPLE: SETSTATE` -> `Start simple: setState`, using [casing] to
  /// restore words the article writes in a specific case.
  static String _sentenceCase(String text, Map<String, String> casing) {
    if (text != text.toUpperCase()) return text;
    final lower = text.toLowerCase().replaceAllMapped(
      RegExp(r'[a-z][a-z0-9]*'),
      (m) => casing[m[0]!] ?? m[0]!,
    );
    final first = lower.indexOf(RegExp('[A-Za-z]'));
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              onPressed:
                  () => ref.read(portfolioProvider.notifier).launchEmail(),
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
        color: blogAccent(context).withValues(alpha: isDark ? 0.07 : 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: blogAccent(context).withValues(alpha: isDark ? 0.22 : 0.12),
        ),
      ),
      child:
          isMobile
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
        hPad:
            isMobile
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

class _ExternalPostNotice extends StatelessWidget {
  const _ExternalPostNotice({
    required this.post,
    required this.onOpen,
    required this.onBack,
  });

  final BlogPost post;
  final VoidCallback onOpen;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final source = BlogSource.fromUrl(post.url)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlogSourceBadge(source: source, subtle: true),
            const SizedBox(height: 18),
            Text(
              post.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.25,
                color: onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This story is published on ${source.name}.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 15,
                color: onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onOpen,
              icon: const Icon(Icons.north_east_rounded, size: 18),
              label: Text(
                'Read on ${source.name}',
                style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onBack,
              child: Text('Back to blog', style: GoogleFonts.manrope(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}

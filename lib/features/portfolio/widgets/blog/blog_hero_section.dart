import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../models/portfolio_models.dart';
import '../shared/custom_widgets.dart';
import 'blog_components.dart';

/// Topics typed out one after another in the hero subtitle.
const _kTopics = [
  'Flutter internals.',
  'state management.',
  'pixel-perfect UI.',
  'shipping real apps.',
  'clean architecture.',
];

/// Blog page hero, laid out like the About page hero: the profile card on
/// the left, and a "My blog" heading with an animated subtitle, intro,
/// reading CTA and stats on the right.
class BlogHeroSection extends ConsumerStatefulWidget {
  const BlogHeroSection({super.key, this.posts = const []});

  /// Public posts, newest first.
  final List<BlogPost> posts;

  @override
  ConsumerState<BlogHeroSection> createState() => _BlogHeroSectionState();
}

class _BlogHeroSectionState extends ConsumerState<BlogHeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _textController;
  late final AnimationController _contentController;
  late final AnimationController _ctaController;

  @override
  void initState() {
    super.initState();
    _textController = _fadeController();
    _contentController = _fadeController();
    _ctaController = _fadeController();
    _startAfter(300, _textController);
    _startAfter(500, _contentController);
    _startAfter(700, _ctaController);
  }

  AnimationController _fadeController() => AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  void _startAfter(int ms, AnimationController controller) {
    Future.delayed(Duration(milliseconds: ms), () {
      if (mounted) controller.forward();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _contentController.dispose();
    _ctaController.dispose();
    super.dispose();
  }

  Widget _fadeIn(AnimationController controller, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: controller, curve: Curves.easeOut),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final horizontalPadding =
        isMobile
            ? 16.0
            : isTablet
            ? 40.0
            : 80.0;
    final verticalPadding =
        isMobile
            ? 32.0
            : isTablet
            ? 48.0
            : 64.0;

    final profileCard = ProfileHeroCard(
      imageRadius:
          isMobile
              ? 80.0
              : isTablet
              ? 100.0
              : 120.0,
      nameFontSize:
          isMobile
              ? 28.0
              : isTablet
              ? 36.0
              : 42.0,
      titleFontSize:
          isMobile
              ? 16.0
              : isTablet
              ? 18.0
              : 20.0,
      socialIconScale:
          isMobile
              ? 1.2
              : isTablet
              ? 1.35
              : 1.5,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? const [
                    Color(0xFF0A0A0A),
                    Color(0xFF111111),
                    Color(0xFF0A0A0A),
                  ]
                  : [Colors.grey[50]!, Colors.grey[100]!, Colors.grey[50]!],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child:
            isMobile
                ? Column(
                  children: [
                    profileCard,
                    const SizedBox(height: 40),
                    _buildContent(context, centered: true),
                  ],
                )
                : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 2, child: profileCard),
                    SizedBox(width: isTablet ? 40 : 80),
                    Expanded(flex: 3, child: _buildContent(context)),
                  ],
                ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {bool centered = false}) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final colorScheme = Theme.of(context).colorScheme;
    final posts = widget.posts;
    final latest = posts.isEmpty ? null : posts.first;
    final crossAlign =
        centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;
    final wrapAlign = centered ? WrapAlignment.center : WrapAlignment.start;

    final totalMinutes = posts.fold<int>(
      0,
      (sum, p) => sum + p.readingTimeMinutes,
    );
    final topicCount = posts.expand((p) => p.tags).toSet().length;

    return Column(
      crossAxisAlignment: crossAlign,
      mainAxisSize: MainAxisSize.min,
      children: [
        _fadeIn(
          _textController,
          Column(
            crossAxisAlignment: crossAlign,
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
              SizedBox(height: isMobile ? 12 : 16),
              Text(
                'My blog',
                textAlign: textAlign,
                style: GoogleFonts.inter(
                  fontSize:
                      isMobile
                          ? 52
                          : isTablet
                          ? 72
                          : 88,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  height: 0.95,
                  letterSpacing: isMobile ? -2.0 : -3.5,
                ),
              ),
              SizedBox(height: isMobile ? 20 : 28),
              _TypewriterSubtitle(
                topics: _kTopics,
                textAlign: textAlign,
                fontSize:
                    isMobile
                        ? 22
                        : isTablet
                        ? 28
                        : 34,
              ),
              SizedBox(height: isMobile ? 20 : 28),
            ],
          ),
        ),
        _fadeIn(
          _contentController,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              'Thoughts, notes and practical write-ups from building '
              'Flutter apps: what worked, what broke, and the small '
              'details that make an interface feel right.',
              textAlign: textAlign,
              style: GoogleFonts.manrope(
                fontSize:
                    isMobile
                        ? 16
                        : isTablet
                        ? 18
                        : 19,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.65),
                height: 1.6,
              ),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 28 : 36),
        _fadeIn(
          _ctaController,
          Column(
            crossAxisAlignment: crossAlign,
            children: [
              Wrap(
                spacing: 14,
                runSpacing: 14,
                alignment: wrapAlign,
                children: [
                  if (latest != null)
                    BlogHeroActionButton(
                      label: 'Start reading',
                      icon: Icons.auto_stories_outlined,
                      isPrimary: true,
                      onPressed: () => openBlogPost(context, latest),
                    ),
                  BlogHeroActionButton(
                    label: 'Email me',
                    icon: Icons.north_east_rounded,
                    isPrimary: latest == null,
                    onPressed:
                        () =>
                            ref.read(portfolioProvider.notifier).launchEmail(),
                  ),
                ],
              ),
              if (posts.isNotEmpty) ...[
                SizedBox(height: isMobile ? 28 : 36),
                Wrap(
                  spacing: isMobile ? 24 : 36,
                  runSpacing: 16,
                  alignment: wrapAlign,
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
          ),
        ),
      ],
    );
  }
}

/// "I write about [topic]" where the topic is typed out, held, deleted and
/// replaced by the next one, with a blinking cursor.
class _TypewriterSubtitle extends StatefulWidget {
  const _TypewriterSubtitle({
    required this.topics,
    required this.fontSize,
    required this.textAlign,
  });

  final List<String> topics;
  final double fontSize;
  final TextAlign textAlign;

  @override
  State<_TypewriterSubtitle> createState() => _TypewriterSubtitleState();
}

class _TypewriterSubtitleState extends State<_TypewriterSubtitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cursor = AnimationController(
    duration: const Duration(milliseconds: 530),
    vsync: this,
  )..repeat(reverse: true);

  Timer? _timer;
  int _topic = 0;
  int _chars = 0;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _schedule(const Duration(milliseconds: 900));
  }

  void _schedule(Duration delay) {
    _timer = Timer(delay, _tick);
  }

  void _tick() {
    if (!mounted) return;
    final word = widget.topics[_topic];
    setState(() {
      if (!_deleting) {
        _chars++;
      } else {
        _chars--;
      }
    });

    if (!_deleting && _chars == word.length) {
      _deleting = true;
      _schedule(const Duration(milliseconds: 1800)); // hold the full topic
    } else if (_deleting && _chars == 0) {
      _deleting = false;
      _topic = (_topic + 1) % widget.topics.length;
      _schedule(const Duration(milliseconds: 350));
    } else {
      _schedule(Duration(milliseconds: _deleting ? 35 : 75));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = blogAccent(context);
    final base = GoogleFonts.inter(
      fontSize: widget.fontSize,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: -0.6,
      color: colorScheme.onSurface.withValues(alpha: 0.85),
    );
    final typed = widget.topics[_topic].substring(0, _chars);
    final longest = widget.topics.reduce(
      (a, b) => a.length >= b.length ? a : b,
    );

    Widget line(String topic, {bool cursor = true}) {
      return Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'I write about '),
            TextSpan(
              text: topic,
              style: TextStyle(color: accent, fontWeight: FontWeight.w700),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: FadeTransition(
                opacity: cursor ? _cursor : const AlwaysStoppedAnimation(0),
                child: Container(
                  width: 3,
                  height: widget.fontSize * 0.95,
                  margin: const EdgeInsets.only(left: 3),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
        textAlign: widget.textAlign,
        style: base,
      );
    }

    // An invisible copy of the longest topic reserves its size (one line on
    // desktop, maybe two on phones), so the layout below never jumps while
    // text is typed and deleted.
    return Stack(
      alignment:
          widget.textAlign == TextAlign.center
              ? Alignment.topCenter
              : Alignment.topLeft,
      children: [
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: line(longest, cursor: false),
        ),
        line(typed),
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

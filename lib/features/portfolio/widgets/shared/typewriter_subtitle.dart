import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';

/// "[prefix][word]" where the word is typed out, held, deleted and replaced
/// by the next one, with a blinking cursor. Used by the page heroes.
class TypewriterSubtitle extends StatefulWidget {
  const TypewriterSubtitle({
    super.key,
    required this.prefix,
    required this.words,
    required this.fontSize,
    required this.textAlign,
  });

  final String prefix;
  final List<String> words;
  final double fontSize;
  final TextAlign textAlign;

  @override
  State<TypewriterSubtitle> createState() => _TypewriterSubtitleState();
}

class _TypewriterSubtitleState extends State<TypewriterSubtitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cursor = AnimationController(
    duration: const Duration(milliseconds: 530),
    vsync: this,
  )..repeat(reverse: true);

  Timer? _timer;
  int _word = 0;
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
    final word = widget.words[_word];
    setState(() {
      if (!_deleting) {
        _chars++;
      } else {
        _chars--;
      }
    });

    if (!_deleting && _chars == word.length) {
      _deleting = true;
      _schedule(const Duration(milliseconds: 1800)); // hold the full word
    } else if (_deleting && _chars == 0) {
      _deleting = false;
      _word = (_word + 1) % widget.words.length;
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
    // Brighter green in dark mode so it stays readable on near-black.
    final accent =
        Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF34D399)
            : AppColors.darkGreen;
    final base = GoogleFonts.inter(
      fontSize: widget.fontSize,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: -0.6,
      color: colorScheme.onSurface.withValues(alpha: 0.85),
    );
    final typed = widget.words[_word].substring(0, _chars);
    final longest = widget.words.reduce(
      (a, b) => a.length >= b.length ? a : b,
    );

    Widget line(String word, {bool cursor = true}) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: widget.prefix),
            TextSpan(
              text: word,
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

    // An invisible copy of the longest word reserves its size (one line on
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

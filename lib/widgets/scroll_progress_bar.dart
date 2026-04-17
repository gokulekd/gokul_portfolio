import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ScrollProgressBar extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollProgressBar({super.key, required this.scrollController});

  @override
  State<ScrollProgressBar> createState() => _ScrollProgressBarState();
}

class _ScrollProgressBarState extends State<ScrollProgressBar> {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final max = widget.scrollController.position.maxScrollExtent;
    if (max <= 0) return;
    final curr = widget.scrollController.offset;
    setState(() => _progress = (curr / max).clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 3,
        child: LinearProgressIndicator(
          value: _progress,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
          minHeight: 3,
        ),
      ),
    );
  }
}

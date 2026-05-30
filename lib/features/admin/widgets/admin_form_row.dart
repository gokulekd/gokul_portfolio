import 'package:flutter/material.dart';

/// Lays children side-by-side on wide screens, stacked on compact screens.
class AdminFormRow extends StatelessWidget {
  const AdminFormRow({
    super.key,
    required this.children,
    required this.compact,
    this.spacing = 14,
  });

  final List<Widget> children;
  final bool compact;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Column(
        children: children
            .expand((w) => [w, SizedBox(height: spacing)])
            .toList()
          ..removeLast(),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .expand((w) => [Expanded(child: w), SizedBox(width: spacing)])
          .toList()
        ..removeLast(),
    );
  }
}

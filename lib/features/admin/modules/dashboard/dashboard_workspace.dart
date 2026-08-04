import 'package:flutter/material.dart';

import 'widgets/main_action_grid.dart';

export 'widgets/main_action_grid.dart';

class DashboardWorkspace extends StatelessWidget {
  const DashboardWorkspace({
    super.key,
    required this.isCompact,
  });

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return MainActionGrid(isCompact: isCompact);
  }
}

import 'package:flutter/material.dart';

import '../../controllers/admin_portal_controller.dart';
import 'widgets/main_action_grid.dart';

export 'widgets/collection_row.dart';
export 'widgets/fallback_module_workspace.dart';
export 'widgets/main_action_grid.dart';

class DashboardWorkspace extends StatelessWidget {
  const DashboardWorkspace({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return MainActionGrid(controller: controller, isCompact: isCompact);
  }
}

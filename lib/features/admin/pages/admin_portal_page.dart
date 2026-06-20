import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/admin_portal_provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../models/admin_portal_models.dart';
import '../modules/admin_module_registry.dart';
import '../shared/admin_portal_navigation.dart';
import '../shared/portal_layout_widgets.dart';

class AdminPortalPage extends ConsumerWidget {
  const AdminPortalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompact = ResponsiveHelper.isMobileOrTablet(context);
    final module = ref.watch(adminPortalProvider).selectedModule;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0E),
      drawer: isCompact
          ? const Drawer(
              backgroundColor: Color(0xFF101113),
              child: AdminPortalNavigation(isDrawer: true),
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF090A0C), Color(0xFF111316)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isCompact) const AdminPortalNavigation(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    isCompact ? 18 : 28,
                    isCompact ? 18 : 24,
                    isCompact ? 18 : 28,
                    28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PortalTopBar(isCompact: isCompact),
                      if (module == AdminModule.dashboard) ...[
                        const SizedBox(height: 24),
                        const HeroHeader(),
                      ],
                      const SizedBox(height: 24),
                      AdminModuleRegistry.buildWorkspace(
                        module: module,
                        isCompact: isCompact,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

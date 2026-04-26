import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_helper.dart';
import '../controllers/admin_portal_controller.dart';
import '../modules/admin_module_registry.dart';
import '../shared/admin_portal_navigation.dart';
import '../shared/portal_layout_widgets.dart';

class AdminPortalPage extends StatelessWidget {
  AdminPortalPage({super.key});

  final AdminPortalController controller =
      Get.isRegistered<AdminPortalController>()
          ? Get.find<AdminPortalController>()
          : Get.put(AdminPortalController());

  @override
  Widget build(BuildContext context) {
    final isCompact = ResponsiveHelper.isMobileOrTablet(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0E),
      drawer:
          isCompact
              ? Drawer(
                backgroundColor: const Color(0xFF101113),
                child: AdminPortalNavigation(
                  controller: controller,
                  isDrawer: true,
                ),
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
              if (!isCompact) AdminPortalNavigation(controller: controller),
              Expanded(
                child: Obx(() {
                  final module = controller.selectedModule.value;

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      isCompact ? 18 : 28,
                      isCompact ? 18 : 24,
                      isCompact ? 18 : 28,
                      28,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PortalTopBar(
                          controller: controller,
                          isCompact: isCompact,
                        ),
                        const SizedBox(height: 24),
                        HeroHeader(controller: controller),
                        const SizedBox(height: 24),
                        AdminModuleRegistry.buildWorkspace(
                          module: module,
                          controller: controller,
                          isCompact: isCompact,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

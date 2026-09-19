import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/admin_portal_provider.dart';
import '../../../core/providers/portfolio_provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../models/admin_portal_models.dart';
import '../modules/admin_module_registry.dart';
import '../shared/admin_portal_navigation.dart';
import '../shared/portal_layout_widgets.dart';

class AdminPortalPage extends ConsumerStatefulWidget {
  const AdminPortalPage({super.key});

  @override
  ConsumerState<AdminPortalPage> createState() => _AdminPortalPageState();
}

class _AdminPortalPageState extends ConsumerState<AdminPortalPage> {
  /// Public-site tab title (mirrors `MyApp`), restored when the admin
  /// portal closes so an unread count never leaks onto the public pages.
  String _baseTitle = '';

  void _setTabTitle(int unread) {
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: unread > 0 ? '($unread) Admin — $_baseTitle' : _baseTitle,
      ),
    );
  }

  /// Fires only for leads that arrive after the first snapshot, so opening
  /// the portal never replays the whole existing inbox as "new".
  void _onPortalChanged(AdminPortalState? prev, AdminPortalState next) {
    final unread = next.liveSubmissions.where((s) => s.isUnread).length;
    _setTabTitle(unread);

    if (prev == null || !prev.submissionsLoaded) return;
    final known = prev.liveSubmissions.map((s) => s.id).toSet();
    final fresh = next.liveSubmissions
        .where((s) => s.isUnread && !known.contains(s.id))
        .toList();
    if (fresh.isEmpty) return;

    final notifier = ref.read(adminPortalProvider.notifier);
    final single = fresh.length == 1 ? fresh.first : null;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 10),
          content: Text(
            single != null
                ? 'New enquiry from ${single.name}'
                : '${fresh.length} new enquiries',
          ),
          action: SnackBarAction(
            label: 'VIEW',
            onPressed: () {
              notifier.selectModule(AdminModule.submissions);
              if (single != null) notifier.selectSubmission(single);
            },
          ),
        ),
      );
  }

  @override
  void dispose() {
    _setTabTitle(0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = ref.watch(portfolioProvider.select((s) => s.personalInfo));
    _baseTitle = '${info.name} — ${info.title}';
    ref.listen<AdminPortalState>(adminPortalProvider, _onPortalChanged);

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

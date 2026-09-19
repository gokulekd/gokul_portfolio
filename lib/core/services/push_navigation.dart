import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/admin/models/admin_portal_models.dart';
import '../firebase/firebase_bootstrap.dart';
import '../providers/admin_portal_provider.dart';
import '../routes/app_router.dart';
import '../routes/app_routes.dart';

/// Android: when the admin taps a new-enquiry push, open the app on the
/// Visitor Submissions inbox. (On web, `firebase-messaging-sw.js` handles the
/// click; while the app is in the foreground the in-app snackbar covers it.)
class PushNavigation {
  PushNavigation._();

  /// Native side (MainActivity) tells us when the owner tapped the notification
  /// that LeadMessagingService posted — that notification is built natively, so
  /// FCM's own opened-app callbacks below don't see it.
  static const _channel = MethodChannel('gokul_portfolio/push');

  static Future<void> attach(ProviderContainer container) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    if (!FirebaseBootstrap.isReady) return;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'openInbox') _openInbox(container);
    });
    try {
      if (await _channel.invokeMethod<bool>('consumeLaunchAction') == true) {
        _openInbox(container);
      }
    } on MissingPluginException {
      // Not running inside MainActivity (e.g. tests) — nothing to consume.
    }

    // App was launched by tapping the notification (cold start).
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _openInbox(container);

    // App was in the background and the notification was tapped.
    FirebaseMessaging.onMessageOpenedApp.listen((_) => _openInbox(container));
  }

  static void _openInbox(ProviderContainer container) {
    container
        .read(adminPortalProvider.notifier)
        .selectModule(AdminModule.submissions);
    // Not signed in? The admin route shows the sign-in gate first.
    appRouter.go(AppRoutes.admin);
  }
}

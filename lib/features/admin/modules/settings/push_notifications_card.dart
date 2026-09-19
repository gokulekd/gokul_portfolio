import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../shared/admin_portal_components.dart';

/// Enable/disable background push alerts for new visitor enquiries in this
/// browser. The in-app snackbar covers an open portal; push covers the rest.
class PushNotificationsCard extends ConsumerStatefulWidget {
  const PushNotificationsCard({super.key});

  @override
  ConsumerState<PushNotificationsCard> createState() =>
      _PushNotificationsCardState();
}

class _PushNotificationsCardState extends ConsumerState<PushNotificationsCard> {
  PushState? _state;
  bool _busy = false;
  String? _error;
  StreamSubscription<String>? _refreshSub;

  PushNotificationService get _service =>
      ref.read(pushNotificationServiceProvider);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _refreshSub?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final state = await _service.currentState();
      if (!mounted) return;
      setState(() => _state = state);
      if (state == PushState.on) _watchTokenRefresh();
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  void _watchTokenRefresh() {
    _refreshSub ??= _service.onTokenRefresh.listen(_service.saveRefreshedToken);
  }

  Future<void> _toggle() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (_state == PushState.on) {
        await _service.disable();
        _refreshSub?.cancel();
        _refreshSub = null;
        if (mounted) setState(() => _state = PushState.off);
      } else {
        final next = await _service.enable();
        if (next == PushState.on) _watchTokenRefresh();
        if (mounted) setState(() => _state = next);
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Something went wrong: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  ({String title, String detail, bool canToggle}) get _copy {
    return switch (_state) {
      null => (
        title: 'Checking…',
        detail: 'Looking up this browser\'s notification status.',
        canToggle: false,
      ),
      PushState.on => (
        title: 'Push alerts are on',
        detail:
            'This browser gets a notification for every new enquiry, even when the portal is closed.',
        canToggle: true,
      ),
      PushState.off => (
        title: 'Push alerts are off',
        detail:
            'Turn on to get a notification for new enquiries when the portal isn\'t open.',
        canToggle: true,
      ),
      PushState.blocked => (
        title: 'Notifications are blocked',
        detail:
            'Allow notifications for this site in your browser\'s site settings, then reload.',
        canToggle: false,
      ),
      PushState.notConfigured => (
        title: 'Not configured in this build',
        detail:
            'Build with FCM_VAPID_KEY set (see .env.example) to enable push notifications.',
        canToggle: false,
      ),
      PushState.unsupported => (
        title: 'Not supported here',
        detail: 'This browser or build can\'t receive web push notifications.',
        canToggle: false,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final copy = _copy;
    final isOn = _state == PushState.on;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isOn ? AppColors.primaryGreen : Colors.white)
                  .withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOn
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_outlined,
              color: isOn ? AppColors.primaryGreen : Colors.white54,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  copy.title,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _error ?? copy.detail,
                  style: GoogleFonts.manrope(
                    color: _error != null
                        ? const Color(0xFFFF7C7C)
                        : Colors.white54,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (copy.canToggle) ...[
            const SizedBox(width: 12),
            isOn
                ? AdminGhostButton(
                    label: _busy ? 'Working…' : 'Turn off',
                    icon: Icons.notifications_off_outlined,
                    onPressed: () {
                      if (!_busy) _toggle();
                    },
                  )
                : AdminPrimaryButton(
                    label: _busy ? 'Working…' : 'Turn on',
                    icon: Icons.notifications_active_rounded,
                    onPressed: _busy ? null : _toggle,
                  ),
          ],
        ],
      ),
    );
  }
}

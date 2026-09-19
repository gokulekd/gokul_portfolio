import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../firebase/firebase_bootstrap.dart';

enum PushState {
  /// Not a web build, Firebase isn't ready, or the browser has no Web Push.
  unsupported,

  /// The build has no `FCM_VAPID_KEY` dart-define, so a token can't be issued.
  notConfigured,

  /// The browser permission was denied — only the user can undo that.
  blocked,

  off,
  on,
}

/// Registers this browser for "new enquiry" push notifications.
///
/// The FCM token is stored in Firestore `admin_push_tokens/{token}`. The
/// Supabase Edge Function `notify-new-lead` reads that collection with a
/// service account and sends the pushes (see supabase/functions/). Firestore
/// rules only let a signed-in admin write here, so a random visitor can't
/// subscribe themselves to lead alerts.
class PushNotificationService {
  static const _vapidKey = String.fromEnvironment('FCM_VAPID_KEY');
  static const _collection = 'admin_push_tokens';

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;
  CollectionReference<Map<String, dynamic>> get _tokens =>
      FirebaseFirestore.instance.collection(_collection);

  Future<PushState> currentState() async {
    if (!kIsWeb || !FirebaseBootstrap.isReady) return PushState.unsupported;
    if (!await _messaging.isSupported()) return PushState.unsupported;
    if (_vapidKey.isEmpty) return PushState.notConfigured;

    final settings = await _messaging.getNotificationSettings();
    switch (settings.authorizationStatus) {
      case AuthorizationStatus.denied:
        return PushState.blocked;
      case AuthorizationStatus.authorized:
      case AuthorizationStatus.provisional:
        final token = await _messaging.getToken(vapidKey: _vapidKey);
        if (token == null) return PushState.off;
        final doc = await _tokens.doc(token).get();
        return doc.exists ? PushState.on : PushState.off;
      case AuthorizationStatus.notDetermined:
        return PushState.off;
    }
  }

  /// Must be called from a user gesture — browsers ignore permission prompts
  /// that aren't.
  Future<PushState> enable() async {
    final state = await currentState();
    if (state == PushState.unsupported || state == PushState.notConfigured) {
      return state;
    }

    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return PushState.blocked;
    }
    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      return PushState.off;
    }

    final token = await _messaging.getToken(vapidKey: _vapidKey);
    if (token == null) return PushState.off;
    await _saveToken(token);
    return PushState.on;
  }

  Future<void> disable() async {
    final token = await _messaging.getToken(vapidKey: _vapidKey);
    if (token != null) await _tokens.doc(token).delete();
    await _messaging.deleteToken();
  }

  /// FCM rotates tokens occasionally; keep the stored one current.
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  Future<void> saveRefreshedToken(String token) => _saveToken(token);

  Future<void> _saveToken(String token) {
    return _tokens.doc(token).set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

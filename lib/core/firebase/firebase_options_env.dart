import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseOptionsEnv {
  const FirebaseOptionsEnv._();

  static FirebaseOptions? get currentPlatform {
    if (kIsWeb) {
      return _web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.iOS:
        return _ios;
      case TargetPlatform.macOS:
        return _macos;
      default:
        return null;
    }
  }

  static FirebaseOptions? get _web {
    final apiKey = const String.fromEnvironment('FIREBASE_WEB_API_KEY');
    final appId = const String.fromEnvironment('FIREBASE_WEB_APP_ID');
    final messagingSenderId = const String.fromEnvironment(
      'FIREBASE_WEB_MESSAGING_SENDER_ID',
    );
    final projectId = const String.fromEnvironment('FIREBASE_WEB_PROJECT_ID');
    final authDomain = const String.fromEnvironment('FIREBASE_WEB_AUTH_DOMAIN');
    final storageBucket = const String.fromEnvironment(
      'FIREBASE_WEB_STORAGE_BUCKET',
    );
    final measurementId = const String.fromEnvironment(
      'FIREBASE_WEB_MEASUREMENT_ID',
    );

    if (!_hasCoreValues([apiKey, appId, messagingSenderId, projectId])) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: authDomain.isEmpty ? null : authDomain,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
      measurementId: measurementId.isEmpty ? null : measurementId,
    );
  }

  static FirebaseOptions? get _android {
    final apiKey = const String.fromEnvironment('FIREBASE_ANDROID_API_KEY');
    final appId = const String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
    final messagingSenderId = const String.fromEnvironment(
      'FIREBASE_ANDROID_MESSAGING_SENDER_ID',
    );
    final projectId = const String.fromEnvironment(
      'FIREBASE_ANDROID_PROJECT_ID',
    );
    final storageBucket = const String.fromEnvironment(
      'FIREBASE_ANDROID_STORAGE_BUCKET',
    );

    if (!_hasCoreValues([apiKey, appId, messagingSenderId, projectId])) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
    );
  }

  static FirebaseOptions? get _ios {
    final apiKey = const String.fromEnvironment('FIREBASE_IOS_API_KEY');
    final appId = const String.fromEnvironment('FIREBASE_IOS_APP_ID');
    final messagingSenderId = const String.fromEnvironment(
      'FIREBASE_IOS_MESSAGING_SENDER_ID',
    );
    final projectId = const String.fromEnvironment('FIREBASE_IOS_PROJECT_ID');
    final iosBundleId = const String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID');
    final storageBucket = const String.fromEnvironment(
      'FIREBASE_IOS_STORAGE_BUCKET',
    );

    if (!_hasCoreValues([apiKey, appId, messagingSenderId, projectId])) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      iosBundleId: iosBundleId.isEmpty ? null : iosBundleId,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
    );
  }

  static FirebaseOptions? get _macos {
    final apiKey = const String.fromEnvironment('FIREBASE_MACOS_API_KEY');
    final appId = const String.fromEnvironment('FIREBASE_MACOS_APP_ID');
    final messagingSenderId = const String.fromEnvironment(
      'FIREBASE_MACOS_MESSAGING_SENDER_ID',
    );
    final projectId = const String.fromEnvironment('FIREBASE_MACOS_PROJECT_ID');
    final iosBundleId = const String.fromEnvironment(
      'FIREBASE_MACOS_BUNDLE_ID',
    );
    final storageBucket = const String.fromEnvironment(
      'FIREBASE_MACOS_STORAGE_BUCKET',
    );

    if (!_hasCoreValues([apiKey, appId, messagingSenderId, projectId])) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      iosBundleId: iosBundleId.isEmpty ? null : iosBundleId,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
    );
  }

  static bool _hasCoreValues(List<String> values) {
    return values.every((value) => value.trim().isNotEmpty);
  }
}

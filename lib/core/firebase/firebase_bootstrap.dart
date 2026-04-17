import 'package:firebase_core/firebase_core.dart';

import 'firebase_options_env.dart';

class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool _isConfigured = false;
  static bool _isInitialized = false;
  static String _statusMessage =
      'Firebase is not configured yet. Add Firebase dart-defines to enable live auth and Firestore.';

  static bool get isConfigured => _isConfigured;
  static bool get isReady => _isConfigured && _isInitialized;
  static String get statusMessage => _statusMessage;

  static Future<void> initialize() async {
    final options = FirebaseOptionsEnv.currentPlatform;
    _isConfigured = options != null;

    if (!_isConfigured) {
      return;
    }

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: options);
      }

      _isInitialized = true;
      _statusMessage = 'Firebase initialized successfully.';
    } catch (error) {
      _isInitialized = false;
      _statusMessage = 'Firebase initialization failed: $error';
    }
  }
}

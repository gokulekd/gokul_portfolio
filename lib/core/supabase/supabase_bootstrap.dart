import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseBootstrap {
  SupabaseBootstrap._();

  static bool _isConfigured = false;
  static bool _isInitialized = false;
  static String _statusMessage = 'Supabase is not configured yet.';

  static bool get isConfigured => _isConfigured;
  static bool get isReady => _isConfigured && _isInitialized;
  static String get statusMessage => _statusMessage;

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    const url = String.fromEnvironment('SUPABASE_URL');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

    if (url.isEmpty || anonKey.isEmpty) {
      _statusMessage =
          'Supabase credentials not provided via --dart-define. '
          'Pass SUPABASE_URL and SUPABASE_ANON_KEY to enable file storage.';
      return;
    }

    _isConfigured = true;

    try {
      await Supabase.initialize(url: url, anonKey: anonKey);
      _isInitialized = true;
      _statusMessage = 'Supabase initialized successfully.';
    } catch (error) {
      _isInitialized = false;
      _statusMessage = 'Supabase initialization failed: $error';
    }
  }
}

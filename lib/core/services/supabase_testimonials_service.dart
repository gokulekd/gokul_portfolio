import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/portfolio/models/testimonial_entry.dart';
import '../supabase/supabase_bootstrap.dart';

class SupabaseTestimonialsService {
  static const String _table = 'testimonials';

  SupabaseClient get _client => SupabaseBootstrap.client;
  bool get isEnabled => SupabaseBootstrap.isReady;

  /// Every testimonial regardless of status — the admin portal needs
  /// pending/hidden ones too, only the public site filters to `published`.
  Future<List<TestimonialEntry>> fetchAll() async {
    if (!isEnabled) return [];
    try {
      final response = await _client
          .from(_table)
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((row) => TestimonialEntry.fromJson(Map<String, dynamic>.from(row as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Public submission entry point — always inserts as `pending` regardless
  /// of what the caller passes, so a visitor can never publish straight to
  /// the live portfolio.
  Future<TestimonialEntry?> submit(TestimonialEntry entry) async {
    if (!isEnabled) return null;
    try {
      final data = entry.toJson()
        ..remove('id')
        ..['status'] = TestimonialStatus.pending;
      final response = await _client.from(_table).insert(data).select().single();
      return TestimonialEntry.fromJson(response);
    } catch (_) {
      return null;
    }
  }

  /// Admin write path — create or update, including status transitions
  /// (approve/hide) and field edits.
  Future<TestimonialEntry?> save(TestimonialEntry entry) async {
    if (!isEnabled) return null;
    try {
      final data = entry.toJson();
      if (entry.id.isEmpty) {
        data.remove('id');
        final response = await _client.from(_table).insert(data).select().single();
        return TestimonialEntry.fromJson(response);
      } else {
        data.remove('created_at');
        final response = await _client
            .from(_table)
            .update(data)
            .eq('id', entry.id)
            .select()
            .single();
        return TestimonialEntry.fromJson(response);
      }
    } catch (_) {
      return null;
    }
  }

  Future<bool> delete(String id) async {
    if (!isEnabled) return false;
    try {
      await _client.from(_table).delete().eq('id', id);
      return true;
    } catch (_) {
      return false;
    }
  }
}

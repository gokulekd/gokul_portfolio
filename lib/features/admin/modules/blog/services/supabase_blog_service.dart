import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/supabase/supabase_bootstrap.dart';
import '../models/admin_blog_post.dart';

class SupabaseBlogService {
  static const String _table = 'blog_posts';

  SupabaseClient get _client => SupabaseBootstrap.client;
  bool get isEnabled => SupabaseBootstrap.isReady;

  Future<List<AdminBlogPost>> fetchPosts() async {
    if (!isEnabled) return [];
    try {
      final response = await _client
          .from(_table)
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((row) => AdminBlogPost.fromJson(Map<String, dynamic>.from(row as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<AdminBlogPost?> savePost(AdminBlogPost post) async {
    if (!isEnabled) return null;
    try {
      final data = post.toJson();
      if (post.id.isEmpty) {
        data.remove('id');
        final response = await _client.from(_table).insert(data).select().single();
        return AdminBlogPost.fromJson(response);
      } else {
        data.remove('created_at');
        final response = await _client
            .from(_table)
            .update(data)
            .eq('id', post.id)
            .select()
            .single();
        return AdminBlogPost.fromJson(response);
      }
    } catch (_) {
      return null;
    }
  }

  Future<bool> deletePost(String id) async {
    if (!isEnabled) return false;
    try {
      await _client.from(_table).delete().eq('id', id);
      return true;
    } catch (_) {
      return false;
    }
  }
}

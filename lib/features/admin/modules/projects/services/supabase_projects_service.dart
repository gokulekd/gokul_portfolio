import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/supabase/supabase_bootstrap.dart';
import '../models/app_project.dart';

class SupabaseProjectsService {
  static const String _table = 'app_projects';

  SupabaseClient get _client => SupabaseBootstrap.client;
  bool get isEnabled => SupabaseBootstrap.isReady;

  Future<List<AppProject>> fetchProjects() async {
    if (!isEnabled) return [];
    try {
      final response = await _client
          .from(_table)
          .select()
          .order('display_order', ascending: true);
      return (response as List)
          .map((row) => AppProject.fromJson(Map<String, dynamic>.from(row as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<AppProject?> saveProject(AppProject project) async {
    if (!isEnabled) return null;
    try {
      final data = project.toJson();
      if (project.id.isEmpty) {
        data.remove('id');
        final response = await _client
            .from(_table)
            .insert(data)
            .select()
            .single();
        return AppProject.fromJson(response);
      } else {
        data.remove('created_at');
        final response = await _client
            .from(_table)
            .update(data)
            .eq('id', project.id)
            .select()
            .single();
        return AppProject.fromJson(response);
      }
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteProject(String id) async {
    if (!isEnabled) return false;
    try {
      await _client.from(_table).delete().eq('id', id);
      return true;
    } catch (_) {
      return false;
    }
  }
}

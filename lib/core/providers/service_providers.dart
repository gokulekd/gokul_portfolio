import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/admin/modules/blog/services/supabase_blog_service.dart';
import '../../features/admin/modules/projects/services/supabase_projects_service.dart';
import '../../features/admin/services/admin_auth_service.dart';
import '../services/contact_service.dart';
import '../services/firebase_portfolio_service.dart';
import '../services/supabase_storage_service.dart';

final firebasePortfolioServiceProvider = Provider<FirebasePortfolioService>((ref) {
  return FirebasePortfolioService();
});

final supabaseStorageServiceProvider = Provider<SupabaseStorageService>((ref) {
  return SupabaseStorageService();
});

final adminAuthServiceProvider = Provider<AdminAuthService>((ref) {
  return AdminAuthService();
});

final supabaseProjectsServiceProvider = Provider<SupabaseProjectsService>((ref) {
  return SupabaseProjectsService();
});

final supabaseBlogServiceProvider = Provider<SupabaseBlogService>((ref) {
  return SupabaseBlogService();
});

final contactServiceProvider = Provider<ContactService>((ref) {
  return ContactService(ref.read(firebasePortfolioServiceProvider));
});

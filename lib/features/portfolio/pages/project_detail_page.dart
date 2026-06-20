import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../admin/modules/projects/models/app_project.dart';
import '../../../core/providers/portfolio_provider.dart';
import '../widgets/shared/custom_widgets.dart';
import '../widgets/projects/project_detail_components.dart';

class ProjectDetailPage extends ConsumerWidget {
  const ProjectDetailPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final AppProject? project = state.appProjects
        .cast<AppProject?>()
        .firstWhere((p) => p?.id == projectId, orElse: () => null);

    if (project == null) {
      return Scaffold(
        appBar: const CustomAppBar(),
        drawer: const CustomDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_off_rounded, size: 64, color: Colors.black26),
              const SizedBox(height: 16),
              Text(
                'Project not found',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Go back',
                  style: GoogleFonts.manrope(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ProjectDetailView(project: project);
  }
}

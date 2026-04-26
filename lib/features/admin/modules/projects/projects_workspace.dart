import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../../../models/portfolio_models.dart';
import '../../controllers/admin_portal_controller.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/preview_tile.dart';

class ProjectsWorkspace extends StatelessWidget {
  const ProjectsWorkspace({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final listPanel = AdminSurfaceCard(
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionHeader(
              eyebrow: 'PROJECT COLLECTION',
              title: 'Featured projects from Firestore',
              description:
                  'This module now reads and writes the real `projects` collection. Featured and published state control what the public portfolio shows.',
              action: AdminPrimaryButton(
                label: 'Add project',
                onPressed:
                    () => showProjectEditorDialog(
                      context,
                      controller: controller,
                    ),
              ),
            ),
            const SizedBox(height: 18),
            ...controller.projects.map(
              (project) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProjectEditorRow(
                  project: project,
                  onEdit:
                      () => showProjectEditorDialog(
                        context,
                        controller: controller,
                        project: project,
                      ),
                  onDelete: () async {
                    await controller.deleteProject(project);
                    Get.snackbar(
                      'Project removed',
                      '${project.title} was deleted from Firestore.',
                      backgroundColor: const Color(
                        0xFFFF7C7C,
                      ).withValues(alpha: 0.16),
                      colorText: Colors.white,
                    );
                  },
                  onFeatureToggle:
                      (value) =>
                          controller.toggleProjectFeatured(project, value),
                  onPublishToggle:
                      (value) =>
                          controller.toggleProjectPublished(project, value),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final sidePanel = AdminSurfaceCard(
      child: Obx(() {
        final featuredCount =
            controller.projects.where((project) => project.isFeatured).length;
        final publishedCount =
            controller.projects.where((project) => project.isPublished).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminSectionHeader(
              eyebrow: 'PROJECT STATUS',
              title: 'Public portfolio output',
              description:
                  'These counts reflect the same project collection now used by the public site.',
            ),
            const SizedBox(height: 18),
            PreviewTile(
              title: 'Featured on homepage',
              value: '$featuredCount project(s)',
              icon: Icons.folder_special_rounded,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 12),
            PreviewTile(
              title: 'Published to projects page',
              value: '$publishedCount project(s)',
              icon: Icons.public_rounded,
              color: const Color(0xFF5CD6FF),
            ),
            const SizedBox(height: 12),
            const PreviewTile(
              title: 'Collection mode',
              value: 'Live Firestore CRUD enabled',
              icon: Icons.cloud_done_rounded,
              color: Color(0xFFFFB44C),
            ),
          ],
        );
      }),
    );

    if (isCompact) {
      return Column(
        children: [listPanel, const SizedBox(height: 18), sidePanel],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: listPanel),
        const SizedBox(width: 18),
        Expanded(flex: 4, child: sidePanel),
      ],
    );
  }
}

class ProjectEditorRow extends StatelessWidget {
  const ProjectEditorRow({
    super.key,
    required this.project,
    required this.onEdit,
    required this.onDelete,
    required this.onFeatureToggle,
    required this.onPublishToggle,
  });

  final Project project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onFeatureToggle;
  final ValueChanged<bool> onPublishToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Text(
                          project.title,
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        AdminStateChip(
                          state:
                              project.isPublished
                                  ? AdminItemState.live
                                  : AdminItemState.draft,
                        ),
                        if (project.isFeatured)
                          const AdminStateChip(
                            state: AdminItemState.live,
                            label: 'Featured',
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.description,
                      style: GoogleFonts.manrope(
                        color: Colors.white60,
                        fontSize: 12.5,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded, color: Colors.white70),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ProjectMetaPill(
                label: project.category,
                icon: Icons.category_rounded,
              ),
              _ProjectMetaPill(
                label: 'Order ${project.displayOrder}',
                icon: Icons.swap_vert_rounded,
              ),
              _ProjectMetaPill(
                label: '${project.technologies.length} stack item(s)',
                icon: Icons.code_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Featured',
                style: GoogleFonts.manrope(color: Colors.white70),
              ),
              const SizedBox(width: 8),
              Switch(
                value: project.isFeatured,
                onChanged: onFeatureToggle,
                activeThumbColor: AppColors.primaryGreen,
              ),
              const SizedBox(width: 18),
              Text(
                'Published',
                style: GoogleFonts.manrope(color: Colors.white70),
              ),
              const SizedBox(width: 8),
              Switch(
                value: project.isPublished,
                onChanged: onPublishToggle,
                activeThumbColor: AppColors.primaryGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectMetaPill extends StatelessWidget {
  const _ProjectMetaPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showProjectEditorDialog(
  BuildContext context, {
  required AdminPortalController controller,
  Project? project,
}) async {
  final titleController = TextEditingController(text: project?.title ?? '');
  final descriptionController = TextEditingController(
    text: project?.description ?? '',
  );
  final imageUrlController = TextEditingController(
    text: project?.imageUrl ?? '',
  );
  final githubController = TextEditingController(
    text: project?.githubUrl ?? '',
  );
  final liveUrlController = TextEditingController(text: project?.liveUrl ?? '');
  final technologiesController = TextEditingController(
    text: project?.technologies.join(', ') ?? '',
  );
  final categoryController = TextEditingController(
    text: project?.category ?? 'Mobile App',
  );
  final orderController = TextEditingController(
    text:
        (project?.displayOrder ?? (controller.projects.length + 1)).toString(),
  );

  var isFeatured = project?.isFeatured ?? false;
  var isPublished = project?.isPublished ?? true;

  await showDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: const Color(0xFF14171A),
            insetPadding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        project == null ? 'Add Project' : 'Edit Project',
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This writes directly to the Firestore `projects` collection.',
                        style: GoogleFonts.manrope(
                          color: Colors.white60,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _ProjectFormField(
                        label: 'Title',
                        controller: titleController,
                      ),
                      const SizedBox(height: 14),
                      _ProjectFormField(
                        label: 'Description',
                        controller: descriptionController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 14),
                      _ProjectFormField(
                        label: 'Image URL',
                        controller: imageUrlController,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _ProjectFormField(
                              label: 'GitHub URL',
                              controller: githubController,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _ProjectFormField(
                              label: 'Live URL',
                              controller: liveUrlController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _ProjectFormField(
                              label: 'Category',
                              controller: categoryController,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _ProjectFormField(
                              label: 'Display Order',
                              controller: orderController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _ProjectFormField(
                        label: 'Technologies (comma separated)',
                        controller: technologiesController,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Text(
                            'Featured',
                            style: GoogleFonts.manrope(color: Colors.white70),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: isFeatured,
                            onChanged:
                                (value) => setState(() => isFeatured = value),
                            activeThumbColor: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 18),
                          Text(
                            'Published',
                            style: GoogleFonts.manrope(color: Colors.white70),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: isPublished,
                            onChanged:
                                (value) => setState(() => isPublished = value),
                            activeThumbColor: AppColors.primaryGreen,
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: AdminGhostButton(
                              label: 'Cancel',
                              icon: Icons.close_rounded,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: AdminPrimaryButton(
                              label: project == null ? 'Create' : 'Save',
                              icon: Icons.check_rounded,
                              onPressed: () async {
                                if (titleController.text.trim().isEmpty ||
                                    descriptionController.text.trim().isEmpty) {
                                  Get.snackbar(
                                    'Missing fields',
                                    'Title and description are required.',
                                    backgroundColor: const Color(
                                      0xFFFFB44C,
                                    ).withValues(alpha: 0.16),
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                final savedProject = Project(
                                  id: project?.id ?? '',
                                  title: titleController.text.trim(),
                                  description:
                                      descriptionController.text.trim(),
                                  imageUrl: imageUrlController.text.trim(),
                                  technologies: technologiesController.text
                                      .split(',')
                                      .map((item) => item.trim())
                                      .where((item) => item.isNotEmpty)
                                      .toList(growable: false),
                                  githubUrl:
                                      githubController.text.trim().isEmpty
                                          ? null
                                          : githubController.text.trim(),
                                  liveUrl:
                                      liveUrlController.text.trim().isEmpty
                                          ? null
                                          : liveUrlController.text.trim(),
                                  category:
                                      categoryController.text.trim().isEmpty
                                          ? 'Mobile App'
                                          : categoryController.text.trim(),
                                  isFeatured: isFeatured,
                                  isPublished: isPublished,
                                  displayOrder:
                                      int.tryParse(
                                        orderController.text.trim(),
                                      ) ??
                                      (project?.displayOrder ??
                                          controller.projects.length + 1),
                                  stars: project?.stars ?? 0,
                                  forks: project?.forks ?? 0,
                                );

                                await controller.saveProject(savedProject);
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }

                                Get.snackbar(
                                  project == null
                                      ? 'Project created'
                                      : 'Project updated',
                                  '${savedProject.title} was saved to Firestore.',
                                  backgroundColor: AppColors.primaryGreen
                                      .withValues(alpha: 0.16),
                                  colorText: Colors.white,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class _ProjectFormField extends StatelessWidget {
  const _ProjectFormField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            color: Colors.white70,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.manrope(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.04),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            hintStyle: GoogleFonts.manrope(color: Colors.white38),
          ),
        ),
      ],
    );
  }
}

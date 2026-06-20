import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/supabase/supabase_bootstrap.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/services/supabase_storage_service.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/admin_portal_components.dart';
import 'models/app_project.dart';
import 'widgets/empty_projects_state.dart';
import 'widgets/project_chips.dart';
import 'widgets/upload_widgets.dart';
import 'widgets/form_widgets.dart';

class ProjectsWorkspace extends ConsumerWidget {
  const ProjectsWorkspace({
    super.key,
    required this.isCompact,
  });

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(adminPortalProvider).liveAppProjects;
    final notifier = ref.read(adminPortalProvider.notifier);

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'APP PROJECTS',
            title: 'Your portfolio projects',
            description:
                'Projects are saved to Supabase. Add app name, description, icon, banner, store links, and website URL.',
            action: AdminPrimaryButton(
              label: 'Add project',
              onPressed: () => showAppProjectEditorDialog(
                context,
                ref: ref,
              ),
            ),
          ),
          const SizedBox(height: 18),
          if (projects.isEmpty)
            const EmptyProjectsState()
          else
            ...projects.map(
              (project) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppProjectRow(
                  project: project,
                  onEdit: () => showAppProjectEditorDialog(
                    context,
                    ref: ref,
                    project: project,
                  ),
                  onDelete: () async {
                    final ok = await notifier.deleteAppProject(project);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok
                                ? '${project.appName} was deleted.'
                                : 'Could not delete. Check Supabase config.',
                            style: GoogleFonts.manrope(color: Colors.white),
                          ),
                          backgroundColor: (ok
                                  ? const Color(0xFFFF7C7C)
                                  : Colors.orange)
                              .withValues(alpha: 0.85),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      );
                    }
                  },
                  onFeatureToggle: (value) =>
                      notifier.toggleAppProjectFeatured(project, value),
                  onPublishToggle: (value) =>
                      notifier.toggleAppProjectPublished(project, value),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AppProjectRow extends StatelessWidget {
  const AppProjectRow({
    super.key,
    required this.project,
    required this.onEdit,
    required this.onDelete,
    required this.onFeatureToggle,
    required this.onPublishToggle,
  });

  final AppProject project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onFeatureToggle;
  final ValueChanged<bool> onPublishToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (project.appBannerUrl.isNotEmpty)
            Image.network(
              project.appBannerUrl,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (_, __, ___) => Container(
                height: 160,
                color: Colors.white.withValues(alpha: 0.04),
                child: const Icon(Icons.image_not_supported_rounded,
                    color: Colors.white24),
              ),
            )
          else
            Container(
              height: 160,
              width: double.infinity,
              color: Colors.white.withValues(alpha: 0.04),
              child: Icon(Icons.image_rounded,
                  size: 36, color: Colors.white.withValues(alpha: 0.1)),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: project.appIconUrl.isNotEmpty
                      ? Image.network(
                          project.appIconUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.apps_rounded,
                              color: Colors.white24),
                        )
                      : const Icon(Icons.apps_rounded, color: Colors.white24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.appName,
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        children: [
                          AdminStateChip(
                            state: project.isPublished
                                ? AdminItemState.live
                                : AdminItemState.draft,
                          ),
                          if (project.isFeatured)
                            const AdminStateChip(
                                state: AdminItemState.live, label: 'Featured'),
                        ],
                      ),
                    ],
                  ),
                ),
                IconChip(icon: Icons.edit_rounded, onTap: onEdit),
                const SizedBox(width: 6),
                IconChip(
                    icon: Icons.delete_outline_rounded,
                    onTap: onDelete,
                    destructive: true),
              ],
            ),
          ),
          if (project.appDescription.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Text(
                project.appDescription,
                style: GoogleFonts.manrope(
                  color: Colors.white54,
                  fontSize: 12.5,
                  height: 1.6,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (project.techStack.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: project.techStack
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color:
                              AppColors.primaryGreen.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.primaryGreen.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.manrope(
                            color: AppColors.primaryGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (project.appWebsiteUrl.isNotEmpty)
                  ProjectLinkChip(
                      label: 'Website', icon: Icons.language_rounded),
                if (project.githubUrl != null &&
                    project.githubUrl!.isNotEmpty)
                  ProjectLinkChip(
                      label: 'GitHub',
                      icon: Icons.code_rounded,
                      color: const Color(0xFFE6EDF3)),
                if (project.playStoreUrl != null &&
                    project.playStoreUrl!.isNotEmpty)
                  ProjectLinkChip(
                      label: 'Play Store',
                      icon: Icons.shop_rounded,
                      color: const Color(0xFF34A853)),
                if (project.appStoreUrl != null &&
                    project.appStoreUrl!.isNotEmpty)
                  ProjectLinkChip(
                      label: 'App Store',
                      icon: Icons.apple_rounded,
                      color: const Color(0xFF5CD6FF)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              children: [
                Text('Featured',
                    style: GoogleFonts.manrope(
                        color: Colors.white54, fontSize: 13)),
                const SizedBox(width: 6),
                Switch(
                  value: project.isFeatured,
                  onChanged: onFeatureToggle,
                  activeThumbColor: AppColors.primaryGreen,
                ),
                const SizedBox(width: 14),
                Text('Published',
                    style: GoogleFonts.manrope(
                        color: Colors.white54, fontSize: 13)),
                const SizedBox(width: 6),
                Switch(
                  value: project.isPublished,
                  onChanged: onPublishToggle,
                  activeThumbColor: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showAppProjectEditorDialog(
  BuildContext context, {
  required WidgetRef ref,
  AppProject? project,
}) async {
  final notifier = ref.read(adminPortalProvider.notifier);
  final storage = ref.read(supabaseStorageServiceProvider);
  final currentProjects = ref.read(adminPortalProvider).liveAppProjects;

  final nameController = TextEditingController(text: project?.appName ?? '');
  final descriptionController =
      TextEditingController(text: project?.appDescription ?? '');
  final websiteController =
      TextEditingController(text: project?.appWebsiteUrl ?? '');
  final playStoreController =
      TextEditingController(text: project?.playStoreUrl ?? '');
  final appStoreController =
      TextEditingController(text: project?.appStoreUrl ?? '');
  final iconUrlController =
      TextEditingController(text: project?.appIconUrl ?? '');
  final bannerUrlController =
      TextEditingController(text: project?.appBannerUrl ?? '');
  final githubController =
      TextEditingController(text: project?.githubUrl ?? '');
  final orderController = TextEditingController(
    text: (project?.displayOrder ?? (currentProjects.length + 1)).toString(),
  );
  final techStackInputController = TextEditingController();
  final responsibilitiesController =
      TextEditingController(text: project?.developerResponsibilities ?? '');

  var isFeatured = project?.isFeatured ?? false;
  var isPublished = project?.isPublished ?? true;
  var isPersonalProject =
      (project?.githubUrl?.isNotEmpty ?? false) || project == null;
  var isUploadingIcon = false;
  var isUploadingBanner = false;
  var iconPreviewUrl = project?.appIconUrl ?? '';
  var bannerPreviewUrl = project?.appBannerUrl ?? '';
  var techStack = List<String>.from(project?.techStack ?? []);

  void showMsg(BuildContext ctx, String title, String body, Color color) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(
          '$title — $body',
          style: GoogleFonts.manrope(color: Colors.white),
        ),
        backgroundColor: color.withValues(alpha: 0.85),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Future<void> pickAndUpload(
    BuildContext ctx,
    StateSetter setDlgState,
    TextEditingController urlController,
    String folder, {
    required void Function(bool) setUploading,
    required void Function(String) setPreview,
  }) async {
    if (!SupabaseBootstrap.isReady) {
      showMsg(
        ctx,
        'Storage not configured',
        'Add SUPABASE_URL and SUPABASE_ANON_KEY.',
        Colors.orange,
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;

    setDlgState(() => setUploading(true));

    final uploadResult = await storage.uploadFromBytes(
      bucket: SupabaseStorageService.mediaBucket,
      folder: 'media/$folder',
      fileName: file.name,
      bytes: bytes,
    );

    if (uploadResult != null) {
      urlController.text = uploadResult.url;
      setDlgState(() {
        setUploading(false);
        setPreview(uploadResult.url);
      });
      final asset = MediaAssetRecord(
        id: '',
        name: file.name,
        url: uploadResult.url,
        supabasePath: uploadResult.path,
        bucket: SupabaseStorageService.mediaBucket,
        sizeBytes: file.size,
        assetType: MediaAssetType.image,
        uploadedAt: DateTime.now(),
      );
      await notifier.saveMediaAsset(asset);
    } else {
      setDlgState(() => setUploading(false));
      if (ctx.mounted) {
        showMsg(
          ctx,
          'Upload failed',
          'Could not upload. Check Supabase storage config.',
          Colors.red,
        );
      }
    }
  }

  await showDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0E1114),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BannerUploadZone(
                        bannerPreviewUrl: bannerPreviewUrl,
                        iconPreviewUrl: iconPreviewUrl,
                        isUploading: isUploadingBanner,
                        isUploadingIcon: isUploadingIcon,
                        onUploadBanner: () => pickAndUpload(
                          context,
                          setState,
                          bannerUrlController,
                          'project-banners',
                          setUploading: (v) => isUploadingBanner = v,
                          setPreview: (url) => bannerPreviewUrl = url,
                        ),
                        onUploadIcon: () => pickAndUpload(
                          context,
                          setState,
                          iconUrlController,
                          'project-icons',
                          setUploading: (v) => isUploadingIcon = v,
                          setPreview: (url) => iconPreviewUrl = url,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    project == null
                                        ? 'New Project'
                                        : 'Edit Project',
                                    style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(
                                    () => isPublished = !isPublished,
                                  ),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isPublished
                                          ? AppColors.primaryGreen
                                              .withValues(alpha: 0.15)
                                          : Colors.white.withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: isPublished
                                            ? AppColors.primaryGreen
                                                .withValues(alpha: 0.4)
                                            : Colors.white.withValues(alpha: 0.1),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isPublished
                                              ? Icons.public_rounded
                                              : Icons.public_off_rounded,
                                          size: 13,
                                          color: isPublished
                                              ? AppColors.primaryGreen
                                              : Colors.white38,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          isPublished ? 'Published' : 'Draft',
                                          style: GoogleFonts.manrope(
                                            color: isPublished
                                                ? AppColors.primaryGreen
                                                : Colors.white38,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => setState(
                                    () => isFeatured = !isFeatured,
                                  ),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isFeatured
                                          ? const Color(0xFFFFB44C)
                                              .withValues(alpha: 0.13)
                                          : Colors.white.withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: isFeatured
                                            ? const Color(0xFFFFB44C)
                                                .withValues(alpha: 0.4)
                                            : Colors.white.withValues(alpha: 0.1),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          size: 13,
                                          color: isFeatured
                                              ? const Color(0xFFFFB44C)
                                              : Colors.white38,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Featured',
                                          style: GoogleFonts.manrope(
                                            color: isFeatured
                                                ? const Color(0xFFFFB44C)
                                                : Colors.white38,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            AppProjectFormField(
                              label: 'App Name',
                              controller: nameController,
                              hint: 'e.g. My Awesome App',
                            ),
                            const SizedBox(height: 14),
                            AppProjectFormField(
                              label: 'Description',
                              controller: descriptionController,
                              maxLines: 6,
                              hint: 'Briefly describe what your app does…',
                            ),
                            const SizedBox(height: 20),
                            SectionDivider(label: 'Links'),
                            const SizedBox(height: 14),
                            AppProjectFormField(
                              label: 'Website URL',
                              controller: websiteController,
                              hint: 'https://yourapp.com',
                              prefixIcon: Icons.language_rounded,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  'Project type',
                                  style: GoogleFonts.manrope(
                                    color: Colors.white54,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ProjectTypeToggle(
                                  isPersonal: isPersonalProject,
                                  onChanged: (personal) => setState(() {
                                    isPersonalProject = personal;
                                    if (!personal) githubController.clear();
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            AppProjectFormField(
                              label: 'GitHub Repo',
                              controller: githubController,
                              hint: isPersonalProject
                                  ? 'https://github.com/you/repo'
                                  : 'Not applicable for company projects',
                              prefixIcon: Icons.code_rounded,
                              enabled: isPersonalProject,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: AppProjectFormField(
                                    label: 'Play Store',
                                    controller: playStoreController,
                                    hint: 'play.google.com/...',
                                    prefixIcon: Icons.shop_rounded,
                                    prefixColor: const Color(0xFF34A853),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppProjectFormField(
                                    label: 'App Store',
                                    controller: appStoreController,
                                    hint: 'apps.apple.com/...',
                                    prefixIcon: Icons.apple_rounded,
                                    prefixColor: const Color(0xFF5CD6FF),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SectionDivider(label: 'Tech Stack'),
                            const SizedBox(height: 14),
                            TechStackInput(
                              tags: techStack,
                              inputController: techStackInputController,
                              onAdd: (tag) => setState(() => techStack.add(tag)),
                              onRemove: (tag) =>
                                  setState(() => techStack.remove(tag)),
                            ),
                            const SizedBox(height: 20),
                            SectionDivider(
                                label: 'Developer Responsibilities'),
                            const SizedBox(height: 14),
                            AppProjectFormField(
                              label: 'What you built & contributed',
                              controller: responsibilitiesController,
                              maxLines: 6,
                              hint:
                                  'Describe your role, features you developed, architecture decisions…',
                            ),
                            const SizedBox(height: 20),
                            SectionDivider(label: 'Settings'),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: 140,
                              child: AppProjectFormField(
                                label: 'Display Order',
                                controller: orderController,
                                keyboardType: TextInputType.number,
                                prefixIcon: Icons.swap_vert_rounded,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                Expanded(
                                  child: AdminGhostButton(
                                    label: 'Cancel',
                                    icon: Icons.close_rounded,
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: AdminPrimaryButton(
                                    label: project == null
                                        ? 'Create project'
                                        : 'Save changes',
                                    icon: Icons.check_rounded,
                                    onPressed: () async {
                                      if (nameController.text.trim().isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'App name is required.',
                                              style: GoogleFonts.manrope(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: const Color(
                                                    0xFFFFB44C)
                                                .withValues(alpha: 0.85),
                                            behavior:
                                                SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      final savedProject = AppProject(
                                        id: project?.id ?? '',
                                        appName: nameController.text.trim(),
                                        appDescription:
                                            descriptionController.text.trim(),
                                        appIconUrl:
                                            iconUrlController.text.trim(),
                                        appBannerUrl:
                                            bannerUrlController.text.trim(),
                                        appWebsiteUrl:
                                            websiteController.text.trim(),
                                        githubUrl: githubController.text
                                                .trim()
                                                .isEmpty
                                            ? null
                                            : githubController.text.trim(),
                                        playStoreUrl: playStoreController.text
                                                .trim()
                                                .isEmpty
                                            ? null
                                            : playStoreController.text.trim(),
                                        appStoreUrl: appStoreController.text
                                                .trim()
                                                .isEmpty
                                            ? null
                                            : appStoreController.text.trim(),
                                        isFeatured: isFeatured,
                                        isPublished: isPublished,
                                        displayOrder: int.tryParse(
                                              orderController.text.trim(),
                                            ) ??
                                            (project?.displayOrder ??
                                                currentProjects.length + 1),
                                        createdAt: project?.createdAt ??
                                            DateTime.now(),
                                        techStack: List.from(techStack),
                                        developerResponsibilities:
                                            responsibilitiesController.text
                                                .trim(),
                                      );

                                      final ok = await notifier
                                          .saveAppProject(savedProject);

                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              ok
                                                  ? '${savedProject.appName} was saved to Supabase.'
                                                  : 'Could not save. Check Supabase config.',
                                              style: GoogleFonts.manrope(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor:
                                                (ok
                                                        ? AppColors.primaryGreen
                                                        : Colors.orange)
                                                    .withValues(alpha: 0.85),
                                            behavior:
                                                SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

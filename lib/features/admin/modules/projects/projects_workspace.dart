import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/supabase/supabase_bootstrap.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../../../providers/admin_portal_provider.dart';
import '../../../../providers/service_providers.dart';
import '../../../../services/supabase_storage_service.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/admin_portal_components.dart';
import 'models/app_project.dart';

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
            const _EmptyProjectsState()
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

class _EmptyProjectsState extends StatelessWidget {
  const _EmptyProjectsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.apps_rounded,
              size: 40,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 14),
            Text(
              'No projects yet',
              style: GoogleFonts.manrope(
                color: Colors.white60,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add your first app project to show it on the portfolio.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
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
                _IconChip(icon: Icons.edit_rounded, onTap: onEdit),
                const SizedBox(width: 6),
                _IconChip(
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
                  _ProjectLinkChip(
                      label: 'Website', icon: Icons.language_rounded),
                if (project.githubUrl != null &&
                    project.githubUrl!.isNotEmpty)
                  _ProjectLinkChip(
                      label: 'GitHub',
                      icon: Icons.code_rounded,
                      color: const Color(0xFFE6EDF3)),
                if (project.playStoreUrl != null &&
                    project.playStoreUrl!.isNotEmpty)
                  _ProjectLinkChip(
                      label: 'Play Store',
                      icon: Icons.shop_rounded,
                      color: const Color(0xFF34A853)),
                if (project.appStoreUrl != null &&
                    project.appStoreUrl!.isNotEmpty)
                  _ProjectLinkChip(
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

class _IconChip extends StatelessWidget {
  const _IconChip({
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Icon(
          icon,
          size: 15,
          color: destructive ? const Color(0xFFFF7C7C) : Colors.white70,
        ),
      ),
    );
  }
}

class _ProjectLinkChip extends StatelessWidget {
  const _ProjectLinkChip({
    required this.label,
    required this.icon,
    this.color = Colors.white54,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
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
                      _BannerUploadZone(
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
                            _AppProjectFormField(
                              label: 'App Name',
                              controller: nameController,
                              hint: 'e.g. My Awesome App',
                            ),
                            const SizedBox(height: 14),
                            _AppProjectFormField(
                              label: 'Description',
                              controller: descriptionController,
                              maxLines: 6,
                              hint: 'Briefly describe what your app does…',
                            ),
                            const SizedBox(height: 20),
                            _SectionDivider(label: 'Links'),
                            const SizedBox(height: 14),
                            _AppProjectFormField(
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
                                _ProjectTypeToggle(
                                  isPersonal: isPersonalProject,
                                  onChanged: (personal) => setState(() {
                                    isPersonalProject = personal;
                                    if (!personal) githubController.clear();
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _AppProjectFormField(
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
                                  child: _AppProjectFormField(
                                    label: 'Play Store',
                                    controller: playStoreController,
                                    hint: 'play.google.com/...',
                                    prefixIcon: Icons.shop_rounded,
                                    prefixColor: const Color(0xFF34A853),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _AppProjectFormField(
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
                            _SectionDivider(label: 'Tech Stack'),
                            const SizedBox(height: 14),
                            _TechStackInput(
                              tags: techStack,
                              inputController: techStackInputController,
                              onAdd: (tag) => setState(() => techStack.add(tag)),
                              onRemove: (tag) =>
                                  setState(() => techStack.remove(tag)),
                            ),
                            const SizedBox(height: 20),
                            _SectionDivider(
                                label: 'Developer Responsibilities'),
                            const SizedBox(height: 14),
                            _AppProjectFormField(
                              label: 'What you built & contributed',
                              controller: responsibilitiesController,
                              maxLines: 6,
                              hint:
                                  'Describe your role, features you developed, architecture decisions…',
                            ),
                            const SizedBox(height: 20),
                            _SectionDivider(label: 'Settings'),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: 140,
                              child: _AppProjectFormField(
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

class _BannerUploadZone extends StatelessWidget {
  const _BannerUploadZone({
    required this.bannerPreviewUrl,
    required this.iconPreviewUrl,
    required this.isUploading,
    required this.isUploadingIcon,
    required this.onUploadBanner,
    required this.onUploadIcon,
  });

  final String bannerPreviewUrl;
  final String iconPreviewUrl;
  final bool isUploading;
  final bool isUploadingIcon;
  final VoidCallback onUploadBanner;
  final VoidCallback onUploadIcon;

  @override
  Widget build(BuildContext context) {
    final hasBanner = bannerPreviewUrl.isNotEmpty;
    final hasIcon = iconPreviewUrl.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: isUploading ? null : onUploadBanner,
          child: Container(
            height: 420,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasBanner
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        bannerPreviewUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _BannerPlaceholder(isUploading: isUploading),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.55),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 12,
                        child: _UploadChip(
                          label: 'Change banner',
                          isUploading: isUploading,
                        ),
                      ),
                    ],
                  )
                : _BannerPlaceholder(isUploading: isUploading),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: isUploadingIcon ? null : onUploadIcon,
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D21),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.5,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: hasIcon
                          ? Image.network(
                              iconPreviewUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _IconPlaceholder(isUploading: isUploadingIcon),
                            )
                          : _IconPlaceholder(isUploading: isUploadingIcon),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isUploadingIcon
                              ? Colors.black54
                              : AppColors.primaryGreen,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF0E1114),
                            width: 2,
                          ),
                        ),
                        child: isUploadingIcon
                            ? const Padding(
                                padding: EdgeInsets.all(4),
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  valueColor: AlwaysStoppedAnimation(
                                    AppColors.primaryGreen,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt_rounded,
                                size: 11,
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Icon',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Tap icon to upload · 512 × 512 recommended',
                    style: GoogleFonts.manrope(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder({required this.isUploading});
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isUploading)
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(AppColors.primaryGreen),
            ),
          )
        else ...[
          Icon(
            Icons.add_photo_alternate_rounded,
            size: 30,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          Text(
            'Click to upload banner',
            style: GoogleFonts.manrope(
              color: Colors.white30,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Recommended: 1200 × 630',
            style: GoogleFonts.manrope(
              color: Colors.white.withValues(alpha: 0.2),
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}

class _IconPlaceholder extends StatelessWidget {
  const _IconPlaceholder({required this.isUploading});
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isUploading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.primaryGreen),
              ),
            )
          : Icon(
              Icons.apps_rounded,
              size: 28,
              color: Colors.white.withValues(alpha: 0.2),
            ),
    );
  }
}

class _UploadChip extends StatelessWidget {
  const _UploadChip({required this.label, required this.isUploading});
  final String label;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUploading)
            const SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation(AppColors.primaryGreen),
              ),
            )
          else
            const Icon(
              Icons.upload_rounded,
              size: 12,
              color: Colors.white70,
            ),
          const SizedBox(width: 6),
          Text(
            isUploading ? 'Uploading…' : label,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.manrope(
            color: Colors.white30,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Divider(
            color: Colors.white.withValues(alpha: 0.07),
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _AppProjectFormField extends StatelessWidget {
  const _AppProjectFormField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.hint,
    this.prefixIcon,
    this.prefixColor = Colors.white38,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? hint;
  final IconData? prefixIcon;
  final Color prefixColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            color: enabled ? Colors.white54 : Colors.white24,
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          enabled: enabled,
          style: GoogleFonts.manrope(
            color: enabled ? Colors.white : Colors.white24,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.02),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.primaryGreen.withValues(alpha: 0.5),
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
            hintText: hint,
            hintStyle: GoogleFonts.manrope(
              color: enabled ? Colors.white24 : Colors.white12,
              fontSize: 13,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    size: 16,
                    color: enabled ? prefixColor : Colors.white12,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _TechStackInput extends StatelessWidget {
  const _TechStackInput({
    required this.tags,
    required this.inputController,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> tags;
  final TextEditingController inputController;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  void _submit() {
    final tag = inputController.text.trim();
    if (tag.isEmpty || tags.contains(tag)) return;
    onAdd(tag);
    inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: inputController,
                style: GoogleFonts.manrope(color: Colors.white, fontSize: 14),
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.primaryGreen.withValues(alpha: 0.5),
                    ),
                  ),
                  hintText: 'e.g. Flutter, Firebase, Riverpod…',
                  hintStyle:
                      GoogleFonts.manrope(color: Colors.white24, fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _submit,
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.primaryGreen.withValues(alpha: 0.35)),
                ),
                child: Icon(Icons.add_rounded,
                    color: AppColors.primaryGreen, size: 20),
              ),
            ),
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color:
                              AppColors.primaryGreen.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tag,
                          style: GoogleFonts.manrope(
                            color: AppColors.primaryGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => onRemove(tag),
                          child: Icon(
                            Icons.close_rounded,
                            size: 12,
                            color:
                                AppColors.primaryGreen.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _ProjectTypeToggle extends StatelessWidget {
  const _ProjectTypeToggle({
    required this.isPersonal,
    required this.onChanged,
  });

  final bool isPersonal;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TypeChip(
            label: 'Personal',
            icon: Icons.person_rounded,
            selected: isPersonal,
            onTap: () => onChanged(true),
          ),
          _TypeChip(
            label: 'Company',
            icon: Icons.business_rounded,
            selected: !isPersonal,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryGreen.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.primaryGreen.withValues(alpha: 0.45)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: selected ? AppColors.primaryGreen : Colors.white38,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                color: selected ? AppColors.primaryGreen : Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

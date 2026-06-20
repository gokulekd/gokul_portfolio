import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/supabase/supabase_bootstrap.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/services/supabase_storage_service.dart';
import '../../shared/admin_portal_components.dart';

class ResumeManagementWorkspace extends ConsumerStatefulWidget {
  const ResumeManagementWorkspace({
    super.key,
    required this.isCompact,
  });

  final bool isCompact;

  @override
  ConsumerState<ResumeManagementWorkspace> createState() =>
      _ResumeManagementWorkspaceState();
}

class _ResumeManagementWorkspaceState
    extends ConsumerState<ResumeManagementWorkspace> {
  bool _isDragTarget = false;
  bool _isUploading = false;

  SupabaseStorageService get _storage =>
      ref.read(supabaseStorageServiceProvider);

  void _showSnack(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.manrope(color: Colors.white)),
        backgroundColor: color.withValues(alpha: 0.85),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Future<void> _pickResume() async {
    if (!SupabaseBootstrap.isReady) {
      _showSnack(
        'Add SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define to enable uploads.',
        Colors.orange,
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;

    setState(() => _isUploading = true);

    final uploadResult = await _storage.uploadFromBytes(
      bucket: SupabaseStorageService.resumesBucket,
      folder: 'resumes',
      fileName: file.name,
      bytes: bytes,
    );

    if (uploadResult == null) {
      setState(() => _isUploading = false);
      _showSnack(
        'Could not upload to Supabase. Check bucket permissions.',
        const Color(0xFFFF7C7C),
      );
      return;
    }

    final current = ref.read(adminPortalProvider).liveResumeConfig;
    final newConfig = (current ?? const ResumeConfig()).withNewActive(
      url: uploadResult.url,
      fileName: file.name,
      sizeBytes: file.size,
      supabasePath: uploadResult.path,
    );

    final saved =
        await ref.read(adminPortalProvider.notifier).saveResumeConfig(newConfig);

    setState(() => _isUploading = false);

    if (saved) {
      _showSnack(
        '${file.name} is now your active resume.',
        AppColors.primaryGreen,
      );
    }
  }

  Future<void> _deleteActiveResume() async {
    final config = ref.read(adminPortalProvider).liveResumeConfig;
    if (config == null || !config.hasResume) return;

    if (config.activeSupabasePath != null &&
        config.activeSupabasePath!.isNotEmpty &&
        SupabaseBootstrap.isReady) {
      await _storage.deleteFile(
        bucket: SupabaseStorageService.resumesBucket,
        path: config.activeSupabasePath!,
      );
    }

    final cleared = ResumeConfig(versions: config.versions);
    await ref.read(adminPortalProvider.notifier).saveResumeConfig(cleared);

    _showSnack('Active resume deleted.', const Color(0xFFFF7C7C));
  }

  Future<void> _restoreVersion(ResumeVersion version) async {
    final current = ref.read(adminPortalProvider).liveResumeConfig;
    if (current == null) return;

    final updatedVersions = current.versions
        .where((v) => v.supabasePath != version.supabasePath)
        .toList();
    if (current.hasResume) {
      updatedVersions.insert(
        0,
        ResumeVersion(
          url: current.activeUrl!,
          fileName: current.activeFileName ?? '',
          sizeBytes: current.activeSizeBytes ?? 0,
          uploadedAt: current.updatedAt ?? DateTime.now(),
          supabasePath: current.activeSupabasePath ?? '',
        ),
      );
    }

    final restored = ResumeConfig(
      activeUrl: version.url,
      activeFileName: version.fileName,
      activeSizeBytes: version.sizeBytes,
      activeSupabasePath: version.supabasePath,
      versions: updatedVersions,
    );
    await ref.read(adminPortalProvider.notifier).saveResumeConfig(restored);

    _showSnack(
      '${version.fileName} is now your active resume.',
      AppColors.primaryGreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(adminPortalProvider).liveResumeConfig;
    final hasResume = config?.hasResume ?? false;
    final versions = config?.versions ?? [];

    final uploadPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'RESUME MANAGEMENT',
            title: 'Upload & manage your CV',
            description:
                'The latest version is stored in Supabase and linked across your portfolio. The public resume button uses this URL.',
            action: hasResume
                ? AdminGhostButton(
                    label: 'Replace',
                    icon: Icons.swap_horiz_rounded,
                    onPressed: _pickResume,
                  )
                : null,
          ),
          const SizedBox(height: 20),
          if (!SupabaseBootstrap.isReady)
            _SupabaseBanner()
          else ...[
            if (hasResume) ...[
              ActiveResumeCard(
                fileName: config!.activeFileName ?? 'resume',
                fileSize: config.activeSizeLabel,
                resumeUrl: config.activeUrl!,
                onReplace: _pickResume,
                onDelete: _deleteActiveResume,
              ),
              const SizedBox(height: 20),
            ],
            DragTarget<Object>(
              onWillAcceptWithDetails: (_) {
                setState(() => _isDragTarget = true);
                return true;
              },
              onLeave: (_) => setState(() => _isDragTarget = false),
              onAcceptWithDetails: (_) {
                setState(() => _isDragTarget = false);
                _pickResume();
              },
              builder: (context, candidates, rejected) {
                return GestureDetector(
                  onTap: _pickResume,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: _isDragTarget
                          ? AppColors.primaryGreen.withValues(alpha: 0.10)
                          : Colors.white.withValues(alpha: 0.02),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: _isDragTarget
                            ? AppColors.primaryGreen.withValues(alpha: 0.45)
                            : Colors.white.withValues(alpha: 0.08),
                        style: BorderStyle.solid,
                        width: 1.5,
                      ),
                    ),
                    child: _isUploading
                        ? Column(
                            children: [
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryGreen,
                                ),
                                strokeWidth: 2.5,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Uploading to Supabase…',
                                style: GoogleFonts.manrope(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen.withValues(
                                    alpha: 0.12,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.upload_rounded,
                                  color: AppColors.primaryGreen,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                hasResume
                                    ? 'Drop new file to replace'
                                    : 'Click to upload or drag & drop',
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Supported formats: PDF, DOC, DOCX · Max 10 MB',
                                style: GoogleFonts.manrope(
                                  color: Colors.white54,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );

    final historyPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'VERSION HISTORY',
            title: 'Previous resume versions',
            description:
                'Previous uploads are kept in Supabase. Restore any version to make it active.',
          ),
          const SizedBox(height: 18),
          if (versions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No previous versions yet.',
                  style: GoogleFonts.manrope(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            ...versions.map(
              (v) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _VersionRow(
                  version: v,
                  onRestore: () => _restoreVersion(v),
                ),
              ),
            ),
        ],
      ),
    );

    if (widget.isCompact) {
      return Column(
        children: [uploadPanel, const SizedBox(height: 18), historyPanel],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: uploadPanel),
        const SizedBox(width: 18),
        Expanded(flex: 5, child: historyPanel),
      ],
    );
  }
}

class _SupabaseBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Supabase storage is not configured. Run with --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=... to enable uploads.',
              style: GoogleFonts.manrope(color: Colors.orange, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveResumeCard extends StatelessWidget {
  const ActiveResumeCard({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.resumeUrl,
    required this.onReplace,
    required this.onDelete,
  });

  final String fileName;
  final String fileSize;
  final String resumeUrl;
  final VoidCallback onReplace;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            fileName,
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'ACTIVE',
                            style: GoogleFonts.manrope(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$fileSize · Stored in Supabase',
                      style: GoogleFonts.manrope(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AdminPrimaryButton(
                label: 'Open',
                icon: Icons.open_in_new_rounded,
                onPressed: () async {
                  final uri = Uri.parse(resumeUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              AdminGhostButton(
                label: 'Replace',
                icon: Icons.swap_horiz_rounded,
                onPressed: onReplace,
              ),
              AdminGhostButton(
                label: 'Delete',
                icon: Icons.delete_outline_rounded,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VersionRow extends StatelessWidget {
  const _VersionRow({required this.version, required this.onRestore});

  final ResumeVersion version;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          const Icon(Icons.history_rounded, color: Colors.white38, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  version.fileName,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${version.sizeLabel}  ·  ${_uploadedLabel(version.uploadedAt)}',
                  style: GoogleFonts.manrope(
                    color: Colors.white54,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onRestore,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              foregroundColor: AppColors.primaryGreen,
            ),
            child: Text(
              'Restore',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _uploadedLabel(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

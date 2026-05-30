import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/app_colors.dart';
import '../../../../core/supabase/supabase_bootstrap.dart';
import '../../../../models/firebase_content_models.dart';
import '../../../../services/supabase_storage_service.dart';
import '../../controllers/admin_portal_controller.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/preview_tile.dart';

class MediaLibraryWorkspace extends StatefulWidget {
  const MediaLibraryWorkspace({
    super.key,
    required this.controller,
    required this.isCompact,
  });
  final AdminPortalController controller;
  final bool isCompact;

  @override
  State<MediaLibraryWorkspace> createState() => _MediaLibraryWorkspaceState();
}

class _MediaLibraryWorkspaceState extends State<MediaLibraryWorkspace> {
  bool _isUploading = false;
  String _filter = 'All';
  MediaAssetRecord? _selected;

  SupabaseStorageService get _storage => Get.find<SupabaseStorageService>();

  List<MediaAssetRecord> get _filtered {
    final assets = widget.controller.liveMediaAssets;
    return switch (_filter) {
      'Images' =>
        assets.where((a) => a.assetType == MediaAssetType.image).toList(),
      'Documents' =>
        assets.where((a) => a.assetType == MediaAssetType.document).toList(),
      _ => assets.toList(),
    };
  }

  Future<void> _pickFiles() async {
    if (!SupabaseBootstrap.isReady) {
      Get.snackbar(
        'Storage not configured',
        'Add SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define to enable uploads.',
        backgroundColor: Colors.orange.withValues(alpha: 0.16),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
        'svg',
        'pdf',
        'doc',
        'docx',
      ],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    setState(() => _isUploading = true);

    for (final file in result.files) {
      final bytes = file.bytes;
      if (bytes == null) continue;

      final ext = (file.extension ?? '').toLowerCase();
      final assetType =
          ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'].contains(ext)
              ? MediaAssetType.image
              : ['pdf', 'doc', 'docx'].contains(ext)
              ? MediaAssetType.document
              : MediaAssetType.other;

      final folder =
          assetType == MediaAssetType.image ? 'media/images' : 'media/docs';

      final uploadResult = await _storage.uploadFromBytes(
        bucket: SupabaseStorageService.mediaBucket,
        folder: folder,
        fileName: file.name,
        bytes: bytes,
      );

      if (uploadResult == null) continue;

      final asset = MediaAssetRecord(
        id: '',
        name: file.name,
        url: uploadResult.url,
        supabasePath: uploadResult.path,
        bucket: SupabaseStorageService.mediaBucket,
        sizeBytes: file.size,
        assetType: assetType,
        uploadedAt: DateTime.now(),
      );

      await widget.controller.saveMediaAsset(asset);
    }

    setState(() => _isUploading = false);
  }

  Future<void> _deleteAsset(MediaAssetRecord asset) async {
    if (asset.supabasePath.isNotEmpty && SupabaseBootstrap.isReady) {
      await _storage.deleteFile(
        bucket: asset.bucket,
        path: asset.supabasePath,
      );
    }
    if (_selected?.id == asset.id) {
      setState(() => _selected = null);
    }
    await widget.controller.deleteMediaAsset(asset);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final assets = widget.controller.liveMediaAssets;
      final filtered = _filtered;
      final imageCount =
          assets.where((a) => a.assetType == MediaAssetType.image).length;
      final docCount =
          assets.where((a) => a.assetType == MediaAssetType.document).length;
      final totalMb =
          assets.fold<int>(0, (sum, a) => sum + a.sizeBytes) / 1024 / 1024;

      final library = AdminSurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionHeader(
              eyebrow: 'MEDIA LIBRARY',
              title: 'Images & assets',
              description:
                  '${assets.length} files · ${totalMb.toStringAsFixed(1)} MB — stored in Supabase. Tap a file to copy its URL.',
              action: AdminPrimaryButton(
                label: _isUploading ? 'Uploading…' : 'Upload files',
                icon:
                    _isUploading
                        ? Icons.hourglass_top_rounded
                        : Icons.upload_rounded,
                onPressed: _isUploading ? null : _pickFiles,
              ),
            ),
            const SizedBox(height: 16),
            if (!SupabaseBootstrap.isReady)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _StorageBanner(),
              ),
            Row(
              children: ['All', 'Images', 'Documents'].map((f) {
                final active = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _filter = f;
                      _selected = null;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color:
                            active
                                ? AppColors.primaryGreen.withValues(alpha: 0.16)
                                : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color:
                              active
                                  ? AppColors.primaryGreen.withValues(alpha: 0.4)
                                  : Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Text(
                        f,
                        style: GoogleFonts.manrope(
                          color: active ? AppColors.primaryGreen : Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (_isUploading)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryGreen,
                    ),
                    minHeight: 3,
                  ),
                ),
              ),
            if (filtered.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    assets.isEmpty
                        ? 'No files yet. Upload some above.'
                        : 'No files match this filter.',
                    style: GoogleFonts.manrope(color: Colors.white38),
                  ),
                ),
              )
            else
              ...filtered.map(
                (asset) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => setState(
                      () =>
                          _selected =
                              _selected?.id == asset.id ? null : asset,
                    ),
                    child: MediaAssetRow(
                      asset: asset,
                      isSelected: _selected?.id == asset.id,
                      onDelete: () => _deleteAsset(asset),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );

      final detailPanel = AdminSurfaceCard(
        child:
            _selected == null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AdminSectionHeader(
                      eyebrow: 'FILE DETAILS',
                      title: 'Select a file',
                      description:
                          'Tap any file to inspect its metadata and copy its Supabase URL.',
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Icon(
                        Icons.perm_media_rounded,
                        size: 48,
                        color: Colors.white12,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const AdminSectionHeader(
                      eyebrow: 'STORAGE STATS',
                      title: 'Library overview',
                      description: '',
                    ),
                    const SizedBox(height: 14),
                    PreviewTile(
                      title: 'Total files',
                      value: '${assets.length} assets',
                      icon: Icons.folder_rounded,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(height: 10),
                    PreviewTile(
                      title: 'Images',
                      value: '$imageCount files',
                      icon: Icons.image_rounded,
                      color: const Color(0xFF5CD6FF),
                    ),
                    const SizedBox(height: 10),
                    PreviewTile(
                      title: 'Documents',
                      value: '$docCount files',
                      icon: Icons.description_rounded,
                      color: const Color(0xFFFFB44C),
                    ),
                    const SizedBox(height: 10),
                    PreviewTile(
                      title: 'Total size',
                      value: '${totalMb.toStringAsFixed(1)} MB',
                      icon: Icons.storage_rounded,
                      color: const Color(0xFFFF7C7C),
                    ),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminSectionHeader(
                      eyebrow: 'FILE DETAILS',
                      title: _selected!.name,
                      description: 'Uploaded ${_selected!.uploadedLabel}',
                    ),
                    const SizedBox(height: 18),
                    if (_selected!.assetType == MediaAssetType.image &&
                        _selected!.url.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          _selected!.url,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => _AssetPlaceholder(
                                asset: _selected!,
                              ),
                        ),
                      )
                    else
                      _AssetPlaceholder(asset: _selected!),
                    const SizedBox(height: 16),
                    PreviewTile(
                      title: 'File name',
                      value: _selected!.name,
                      icon: Icons.insert_drive_file_rounded,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(height: 10),
                    PreviewTile(
                      title: 'Size',
                      value: _selected!.sizeLabel,
                      icon: Icons.data_usage_rounded,
                      color: const Color(0xFF5CD6FF),
                    ),
                    const SizedBox(height: 10),
                    PreviewTile(
                      title: 'Type',
                      value: _selected!.assetType.name[0].toUpperCase() +
                          _selected!.assetType.name.substring(1),
                      icon: Icons.category_rounded,
                      color: const Color(0xFFFFB44C),
                    ),
                    const SizedBox(height: 18),
                    AdminPrimaryButton(
                      label: 'Open file',
                      icon: Icons.open_in_new_rounded,
                      onPressed: () async {
                        final uri = Uri.parse(_selected!.url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    AdminGhostButton(
                      label: 'Delete file',
                      icon: Icons.delete_outline_rounded,
                      onPressed: () => _deleteAsset(_selected!),
                    ),
                  ],
                ),
      );

      if (widget.isCompact) {
        return Column(
          children: [library, const SizedBox(height: 18), detailPanel],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 8, child: library),
          const SizedBox(width: 18),
          Expanded(flex: 4, child: detailPanel),
        ],
      );
    });
  }
}

class _StorageBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Supabase not configured — uploads disabled. Pass SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define.',
              style: GoogleFonts.manrope(color: Colors.orange, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetPlaceholder extends StatelessWidget {
  const _AssetPlaceholder({required this.asset});
  final MediaAssetRecord asset;

  Color get _color => switch (asset.assetType) {
    MediaAssetType.image => AppColors.primaryGreen,
    MediaAssetType.document => const Color(0xFF5CD6FF),
    MediaAssetType.other => const Color(0xFFFFB44C),
  };

  IconData get _icon => switch (asset.assetType) {
    MediaAssetType.image => Icons.image_rounded,
    MediaAssetType.document => Icons.description_rounded,
    MediaAssetType.other => Icons.insert_drive_file_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _color.withValues(alpha: 0.2)),
      ),
      child: Icon(_icon, size: 40, color: _color),
    );
  }
}

class MediaAssetRow extends StatelessWidget {
  const MediaAssetRow({
    super.key,
    required this.asset,
    required this.isSelected,
    required this.onDelete,
  });

  final MediaAssetRecord asset;
  final bool isSelected;
  final VoidCallback onDelete;

  Color get _color => switch (asset.assetType) {
    MediaAssetType.image => AppColors.primaryGreen,
    MediaAssetType.document => const Color(0xFF5CD6FF),
    MediaAssetType.other => const Color(0xFFFFB44C),
  };

  IconData get _icon => switch (asset.assetType) {
    MediaAssetType.image => Icons.image_rounded,
    MediaAssetType.document => Icons.description_rounded,
    MediaAssetType.other => Icons.insert_drive_file_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color:
            isSelected
                ? AppColors.primaryGreen.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              isSelected
                  ? AppColors.primaryGreen.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_icon, color: _color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${asset.sizeLabel}  ·  ${asset.uploadedLabel}',
                  style: GoogleFonts.manrope(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFFF7C7C),
              size: 17,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}

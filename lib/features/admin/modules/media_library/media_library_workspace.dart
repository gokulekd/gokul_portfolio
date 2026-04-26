import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/preview_tile.dart';

enum MediaType { image, document, other }

class MediaAsset {
  const MediaAsset({
    required this.id,
    required this.name,
    required this.sizeKb,
    required this.type,
    required this.uploadedAt,
    this.url,
  });

  final String id;
  final String name;
  final double sizeKb;
  final MediaType type;
  final DateTime uploadedAt;
  final String? url;

  String get sizeLabel {
    if (sizeKb >= 1024) return '${(sizeKb / 1024).toStringAsFixed(1)} MB';
    return '${sizeKb.toStringAsFixed(0)} KB';
  }

  String get uploadedLabel {
    final diff = DateTime.now().difference(uploadedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  IconData get icon => switch (type) {
    MediaType.image => Icons.image_rounded,
    MediaType.document => Icons.description_rounded,
    MediaType.other => Icons.insert_drive_file_rounded,
  };

  Color get color => switch (type) {
    MediaType.image => AppColors.primaryGreen,
    MediaType.document => const Color(0xFF5CD6FF),
    MediaType.other => const Color(0xFFFFB44C),
  };
}

class MediaLibraryWorkspace extends StatefulWidget {
  const MediaLibraryWorkspace({super.key, required this.isCompact});
  final bool isCompact;

  @override
  State<MediaLibraryWorkspace> createState() => _MediaLibraryWorkspaceState();
}

class _MediaLibraryWorkspaceState extends State<MediaLibraryWorkspace> {
  bool _isUploading = false;
  String _filter = 'All';
  MediaAsset? _selected;

  final _assets = <MediaAsset>[
    MediaAsset(
      id: '1',
      name: 'profile_photo.jpg',
      sizeKb: 248,
      type: MediaType.image,
      uploadedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    MediaAsset(
      id: '2',
      name: 'project_cover_flutter.png',
      sizeKb: 512,
      type: MediaType.image,
      uploadedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    MediaAsset(
      id: '3',
      name: 'gokul_resume_v3.pdf',
      sizeKb: 1820,
      type: MediaType.document,
      uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    MediaAsset(
      id: '4',
      name: 'admin_dashboard_preview.png',
      sizeKb: 384,
      type: MediaType.image,
      uploadedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  List<MediaAsset> get _filtered => switch (_filter) {
    'Images' => _assets.where((a) => a.type == MediaType.image).toList(),
    'Documents' => _assets.where((a) => a.type == MediaType.document).toList(),
    _ => _assets,
  };

  Future<void> _pickFiles() async {
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
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;

    setState(() => _isUploading = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() {
      for (final file in result.files) {
        final ext = (file.extension ?? '').toLowerCase();
        final type =
            ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'].contains(ext)
                ? MediaType.image
                : ['pdf', 'doc', 'docx'].contains(ext)
                ? MediaType.document
                : MediaType.other;
        _assets.insert(
          0,
          MediaAsset(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: file.name,
            sizeKb: (file.size / 1024).clamp(1, double.infinity),
            type: type,
            uploadedAt: DateTime.now(),
          ),
        );
      }
      _isUploading = false;
    });
  }

  double get _totalMb => _assets.fold(0.0, (sum, a) => sum + a.sizeKb) / 1024;

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final imageCount = _assets.where((a) => a.type == MediaType.image).length;
    final docCount = _assets.where((a) => a.type == MediaType.document).length;

    final library = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'MEDIA LIBRARY',
            title: 'Images & assets',
            description:
                '${_assets.length} files · ${_totalMb.toStringAsFixed(1)} MB used. Tap a file to see details.',
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
          Row(
            children:
                ['All', 'Images', 'Documents'].map((f) {
                  final active = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap:
                          () => setState(() {
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
                                  ? AppColors.primaryGreen.withValues(
                                    alpha: 0.16,
                                  )
                                  : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color:
                                active
                                    ? AppColors.primaryGreen.withValues(
                                      alpha: 0.4,
                                    )
                                    : Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Text(
                          f,
                          style: GoogleFonts.manrope(
                            color:
                                active
                                    ? AppColors.primaryGreen
                                    : Colors.white54,
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
                  'No files here. Upload some above.',
                  style: GoogleFonts.manrope(color: Colors.white38),
                ),
              ),
            )
          else
            ...filtered.map(
              (asset) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap:
                      () => setState(
                        () =>
                            _selected =
                                _selected?.id == asset.id ? null : asset,
                      ),
                  child: MediaAssetRow(
                    asset: asset,
                    isSelected: _selected?.id == asset.id,
                    onDelete:
                        () => setState(() {
                          _assets.removeWhere((a) => a.id == asset.id);
                          if (_selected?.id == asset.id) _selected = null;
                        }),
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
                        'Tap any file in the list to inspect its metadata and copy its reference URL.',
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
                    value: '${_assets.length} assets',
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
                    value: '${_totalMb.toStringAsFixed(1)} MB',
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
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: _selected!.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selected!.color.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(
                      _selected!.icon,
                      size: 40,
                      color: _selected!.color,
                    ),
                  ),
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
                    value:
                        _selected!.type.name[0].toUpperCase() +
                        _selected!.type.name.substring(1),
                    icon: Icons.category_rounded,
                    color: const Color(0xFFFFB44C),
                  ),
                  const SizedBox(height: 18),
                  AdminGhostButton(
                    label: 'Delete file',
                    icon: Icons.delete_outline_rounded,
                    onPressed:
                        () => setState(() {
                          _assets.removeWhere((a) => a.id == _selected!.id);
                          _selected = null;
                        }),
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
  }
}

class MediaAssetRow extends StatelessWidget {
  const MediaAssetRow({
    super.key,
    required this.asset,
    required this.isSelected,
    required this.onDelete,
  });

  final MediaAsset asset;
  final bool isSelected;
  final VoidCallback onDelete;

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
              color: asset.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(asset.icon, color: asset.color, size: 18),
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

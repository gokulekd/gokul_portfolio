import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../shared/admin_portal_components.dart';

class ResumeManagementWorkspace extends StatefulWidget {
  const ResumeManagementWorkspace({super.key, required this.isCompact});
  final bool isCompact;

  @override
  State<ResumeManagementWorkspace> createState() =>
      _ResumeManagementWorkspaceState();
}

class _ResumeManagementWorkspaceState extends State<ResumeManagementWorkspace> {
  bool _isDragTarget = false;
  String? _uploadedFileName;
  String? _uploadedFileSize;
  String? _uploadedDate;
  bool _isUploading = false;

  final _versions = <_ResumeVersion>[
    _ResumeVersion(
      name: 'gokul_resume_v2.pdf',
      date: 'Mar 2025',
      size: '1.8 MB',
      isCurrent: false,
    ),
    _ResumeVersion(
      name: 'gokul_resume_v1.pdf',
      date: 'Jan 2025',
      size: '1.5 MB',
      isCurrent: false,
    ),
  ];

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: false,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() => _isUploading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isUploading = false;
        if (_uploadedFileName != null) {
          _versions.insert(
            0,
            _ResumeVersion(
              name: _uploadedFileName!,
              date: 'Previous',
              size: _uploadedFileSize ?? '--',
              isCurrent: false,
            ),
          );
        }
        _uploadedFileName = file.name;
        _uploadedFileSize =
            file.size != 0
                ? '${(file.size / 1024 / 1024).toStringAsFixed(1)} MB'
                : 'Unknown size';
        _uploadedDate = 'Just now';
      });
      Get.snackbar(
        'Resume uploaded',
        '${file.name} is now your active resume.',
        backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.16),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'RESUME MANAGEMENT',
            title: 'Upload & manage your CV',
            description:
                'Keep your resume up to date. The latest version will be linked across your portfolio.',
            action:
                _uploadedFileName != null
                    ? AdminGhostButton(
                      label: 'Replace',
                      icon: Icons.swap_horiz_rounded,
                      onPressed: _pickResume,
                    )
                    : null,
          ),
          const SizedBox(height: 20),
          if (_uploadedFileName != null) ...[
            ActiveResumeCard(
              fileName: _uploadedFileName!,
              fileSize: _uploadedFileSize ?? '--',
              uploadedDate: _uploadedDate ?? '--',
              onReplace: _pickResume,
              onDelete: () {
                setState(() {
                  _uploadedFileName = null;
                  _uploadedFileSize = null;
                  _uploadedDate = null;
                });
              },
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
                    color:
                        _isDragTarget
                            ? AppColors.primaryGreen.withValues(alpha: 0.10)
                            : Colors.white.withValues(alpha: 0.02),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color:
                          _isDragTarget
                              ? AppColors.primaryGreen.withValues(alpha: 0.45)
                              : Colors.white.withValues(alpha: 0.08),
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  child:
                      _isUploading
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
                                'Uploading...',
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
                                'Click to upload or drag & drop',
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
                'Older versions are kept for reference. You can restore any previous version.',
          ),
          const SizedBox(height: 18),
          if (_versions.isEmpty)
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
            ..._versions.map(
              (v) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _VersionRow(version: v),
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

class ActiveResumeCard extends StatelessWidget {
  const ActiveResumeCard({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.uploadedDate,
    required this.onReplace,
    required this.onDelete,
  });

  final String fileName;
  final String fileSize;
  final String uploadedDate;
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
                      '$fileSize · Uploaded $uploadedDate',
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
                label: 'Download',
                icon: Icons.download_rounded,
                onPressed: () {},
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

class _ResumeVersion {
  _ResumeVersion({
    required this.name,
    required this.date,
    required this.size,
    required this.isCurrent,
  });

  final String name;
  final String date;
  final String size;
  final bool isCurrent;
}

class _VersionRow extends StatelessWidget {
  const _VersionRow({required this.version});

  final _ResumeVersion version;

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
                  version.name,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${version.date} · ${version.size}',
                  style: GoogleFonts.manrope(
                    color: Colors.white54,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
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
}

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../shared/admin_portal_components.dart';

class CreatePostWorkspace extends StatefulWidget {
  const CreatePostWorkspace({super.key, required this.isCompact});
  final bool isCompact;

  @override
  State<CreatePostWorkspace> createState() => _CreatePostWorkspaceState();
}

class _CreatePostWorkspaceState extends State<CreatePostWorkspace> {
  final _textController = TextEditingController();
  final _hashtagController = TextEditingController();
  String _visibility = 'Public';
  final List<String> _hashtags = [];
  final List<Uint8List> _selectedImages = [];
  bool _isPosting = false;

  static const int _maxChars = 3000;
  final _visibilityOptions = ['Public', 'Portfolio Only', 'Draft'];

  @override
  void dispose() {
    _textController.dispose();
    _hashtagController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );
    if (result != null) {
      setState(() {
        for (final file in result.files) {
          if (file.bytes != null && _selectedImages.length < 4) {
            _selectedImages.add(file.bytes!);
          }
        }
      });
    }
  }

  void _addHashtag() {
    final tag = _hashtagController.text.trim().replaceAll('#', '');
    if (tag.isNotEmpty && !_hashtags.contains(tag) && _hashtags.length < 10) {
      setState(() {
        _hashtags.add(tag);
        _hashtagController.clear();
      });
    }
  }

  Future<void> _submitPost() async {
    if (_textController.text.trim().isEmpty && _selectedImages.isEmpty) return;
    setState(() => _isPosting = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isPosting = false;
      _textController.clear();
      _selectedImages.clear();
      _hashtags.clear();
      _visibility = 'Public';
    });
    Get.snackbar(
      'Post published',
      'Your post is now live.',
      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.16),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool get _canPost =>
      (_textController.text.trim().isNotEmpty || _selectedImages.isNotEmpty) &&
      !_isPosting;

  @override
  Widget build(BuildContext context) {
    final editor = AdminSurfaceCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primaryGreen, Color(0xFF57D4FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'GK',
                  style: GoogleFonts.manrope(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gokul K S',
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _visibility,
                          isDense: true,
                          dropdownColor: const Color(0xFF1C1F23),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white70,
                            size: 16,
                          ),
                          style: GoogleFonts.manrope(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          items:
                              _visibilityOptions
                                  .map(
                                    (opt) => DropdownMenuItem(
                                      value: opt,
                                      child: Text(opt),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _visibility = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _textController,
            builder: (context, value, _) {
              final remaining = _maxChars - value.text.length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: 7,
                    maxLength: _maxChars,
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.65,
                    ),
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: GoogleFonts.manrope(
                        color: Colors.white38,
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.03),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$remaining characters remaining',
                    style: GoogleFonts.manrope(
                      color:
                          remaining < 100
                              ? const Color(0xFFFFB44C)
                              : Colors.white38,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              );
            },
          ),
          if (_selectedImages.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.memory(
                            _selectedImages[index],
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap:
                                () => setState(
                                  () => _selectedImages.removeAt(index),
                                ),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                PostActionButton(
                  icon: Icons.image_rounded,
                  label: 'Photo',
                  color: AppColors.primaryGreen,
                  onTap: _pickImages,
                  badge:
                      _selectedImages.isNotEmpty
                          ? '${_selectedImages.length}'
                          : null,
                ),
                PostActionButton(
                  icon: Icons.videocam_rounded,
                  label: 'Video',
                  color: const Color(0xFF5CD6FF),
                  onTap: () {},
                ),
                PostActionButton(
                  icon: Icons.attach_file_rounded,
                  label: 'Document',
                  color: const Color(0xFFFFB44C),
                  onTap: () async {
                    await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'doc', 'docx'],
                    );
                  },
                ),
                PostActionButton(
                  icon: Icons.tag_rounded,
                  label: 'Hashtag',
                  color: const Color(0xFFFF7C7C),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder:
                          (_) => HashtagDialog(
                            controller: _hashtagController,
                            onAdd: _addHashtag,
                          ),
                    );
                  },
                ),
                PostActionButton(
                  icon: Icons.emoji_emotions_rounded,
                  label: 'Emoji',
                  color: const Color(0xFFFFD700),
                  onTap: () {},
                ),
                PostActionButton(
                  icon: Icons.alternate_email_rounded,
                  label: 'Mention',
                  color: const Color(0xFFB57AFF),
                  onTap: () {},
                ),
              ],
            ),
          ),
          if (_hashtags.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _hashtags
                      .map(
                        (tag) => Chip(
                          label: Text(
                            '#$tag',
                            style: GoogleFonts.manrope(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: AppColors.primaryGreen.withValues(
                            alpha: 0.12,
                          ),
                          deleteIconColor: AppColors.primaryGreen.withValues(
                            alpha: 0.6,
                          ),
                          side: BorderSide(
                            color: AppColors.primaryGreen.withValues(
                              alpha: 0.22,
                            ),
                          ),
                          onDeleted:
                              () => setState(() => _hashtags.remove(tag)),
                        ),
                      )
                      .toList(),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: AdminGhostButton(
                  label: 'Save Draft',
                  icon: Icons.save_rounded,
                  onPressed: () {
                    Get.snackbar(
                      'Draft saved',
                      'Your draft has been saved.',
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child:
                    _isPosting
                        ? Container(
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryGreen,
                              ),
                            ),
                          ),
                        )
                        : AdminPrimaryButton(
                          label: 'Post',
                          icon: Icons.send_rounded,
                          onPressed: _canPost ? _submitPost : null,
                        ),
              ),
            ],
          ),
        ],
      ),
    );

    final previewPanel = AdminSurfaceCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'POST PREVIEW',
            title: 'How it will look',
            description:
                'A live preview of your post card as it appears on the portfolio feed.',
          ),
          const SizedBox(height: 18),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _textController,
            builder: (context, value, _) {
              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryGreen,
                                Color(0xFF57D4FF),
                              ],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'GK',
                            style: GoogleFonts.manrope(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gokul K S',
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _visibility,
                              style: GoogleFonts.manrope(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      value.text.isEmpty
                          ? 'Your post text will appear here...'
                          : value.text,
                      style: GoogleFonts.manrope(
                        color:
                            value.text.isEmpty ? Colors.white38 : Colors.white,
                        fontSize: 13,
                        height: 1.6,
                      ),
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (_selectedImages.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _selectedImages.first,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (_selectedImages.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '+${_selectedImages.length - 1} more image(s)',
                            style: GoogleFonts.manrope(
                              color: Colors.white54,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                    ],
                    if (_hashtags.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        children:
                            _hashtags
                                .map(
                                  (tag) => Text(
                                    '#$tag',
                                    style: GoogleFonts.manrope(
                                      color: AppColors.primaryGreen,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    if (widget.isCompact) {
      return Column(
        children: [editor, const SizedBox(height: 18), previewPanel],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: editor),
        const SizedBox(width: 18),
        Expanded(flex: 5, child: previewPanel),
      ],
    );
  }
}

class PostActionButton extends StatelessWidget {
  const PostActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 17),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge!,
                  style: GoogleFonts.manrope(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HashtagDialog extends StatelessWidget {
  const HashtagDialog({
    super.key,
    required this.controller,
    required this.onAdd,
  });

  final TextEditingController controller;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF14171A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Hashtag',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: GoogleFonts.manrope(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'e.g. flutter',
                hintStyle: GoogleFonts.manrope(color: Colors.white38),
                prefixText: '# ',
                prefixStyle: GoogleFonts.manrope(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w700,
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) {
                onAdd();
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AdminGhostButton(
                    label: 'Cancel',
                    icon: Icons.close_rounded,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AdminPrimaryButton(
                    label: 'Add',
                    icon: Icons.add_rounded,
                    onPressed: () {
                      onAdd();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

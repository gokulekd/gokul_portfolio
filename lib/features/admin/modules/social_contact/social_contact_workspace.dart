import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../../../models/firebase_content_models.dart';
import '../../controllers/admin_portal_controller.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/dialog_widgets.dart';
import '../../shared/preview_tile.dart';

class SocialContactWorkspace extends StatelessWidget {
  const SocialContactWorkspace({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  void _openLinkDialog(BuildContext context, {ManagedSocialLink? existing}) {
    final platformCtrl = TextEditingController(text: existing?.platform ?? '');
    final valueCtrl = TextEditingController(text: existing?.value ?? '');
    String type = existing?.type ?? 'url';
    bool isVisible = existing?.isVisible ?? true;

    showDialog<void>(
      context: context,
      builder:
          (ctx) => StatefulBuilder(
            builder:
                (ctx, setState) => AlertDialog(
                  backgroundColor: const Color(0xFF1A1C1F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    existing == null ? 'Add Social Link' : 'Edit Social Link',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DialogField(
                          controller: platformCtrl,
                          label: 'Platform name',
                          hint: 'e.g. LinkedIn',
                        ),
                        const SizedBox(height: 14),
                        DialogField(
                          controller: valueCtrl,
                          label: type == 'email' ? 'Email address' : 'URL',
                          hint:
                              type == 'email'
                                  ? 'you@example.com'
                                  : 'https://...',
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text(
                              'Type',
                              style: GoogleFonts.manrope(
                                color: Colors.white54,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            TypeChip(
                              label: 'URL',
                              selected: type == 'url',
                              onTap: () => setState(() => type = 'url'),
                            ),
                            const SizedBox(width: 8),
                            TypeChip(
                              label: 'Email',
                              selected: type == 'email',
                              onTap: () => setState(() => type = 'email'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Visible on portfolio',
                              style: GoogleFonts.manrope(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            Switch(
                              value: isVisible,
                              onChanged: (v) => setState(() => isVisible = v),
                              activeThumbColor: AppColors.primaryGreen,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.manrope(color: Colors.white54),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final platform = platformCtrl.text.trim();
                        final value = valueCtrl.text.trim();
                        if (platform.isEmpty || value.isEmpty) return;
                        final links = controller.socialLinks;
                        final nextOrder =
                            links.isEmpty
                                ? 1
                                : links
                                        .map((l) => l.displayOrder)
                                        .reduce((a, b) => a > b ? a : b) +
                                    1;
                        final link = ManagedSocialLink(
                          id:
                              existing?.id ??
                              platform.toLowerCase().replaceAll(' ', '_'),
                          platform: platform,
                          value: value,
                          type: type,
                          displayOrder: existing?.displayOrder ?? nextOrder,
                          isVisible: isVisible,
                        );
                        controller.saveSocialLink(link);
                        Navigator.of(ctx).pop();
                      },
                      child: Text(
                        'Save',
                        style: GoogleFonts.manrope(
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final linkList = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'SOCIAL & CONTACT',
            title: 'Public contact channels',
            description:
                'Manage every link visible on the portfolio contact section. Changes sync to Firestore immediately.',
            action: AdminPrimaryButton(
              label: 'Add link',
              icon: Icons.add_rounded,
              onPressed: () => _openLinkDialog(context),
            ),
          ),
          const SizedBox(height: 18),
          Obx(() {
            final links = controller.socialLinks;
            if (links.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No social links yet. Add one above.',
                    style: GoogleFonts.manrope(color: Colors.white38),
                  ),
                ),
              );
            }
            return Column(
              children:
                  links
                      .map(
                        (link) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SocialLinkRow(
                            link: link,
                            onEdit:
                                () => _openLinkDialog(context, existing: link),
                            onDelete: () => controller.deleteSocialLink(link),
                            onToggleVisibility:
                                (val) => controller.saveSocialLink(
                                  link.copyWith(isVisible: val),
                                ),
                          ),
                        ),
                      )
                      .toList(),
            );
          }),
        ],
      ),
    );

    final infoPanel = AdminSurfaceCard(
      child: Obx(() {
        final links = controller.socialLinks;
        final visibleCount = links.where((l) => l.isVisible).length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminSectionHeader(
              eyebrow: 'LINK STATS',
              title: 'Channel overview',
              description: 'Summary of public contact channels.',
            ),
            const SizedBox(height: 18),
            PreviewTile(
              title: 'Total links',
              value: '${links.length} channels configured',
              icon: Icons.link_rounded,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 12),
            PreviewTile(
              title: 'Visible',
              value: '$visibleCount links shown publicly',
              icon: Icons.visibility_rounded,
              color: const Color(0xFF5CD6FF),
            ),
            const SizedBox(height: 12),
            PreviewTile(
              title: 'Hidden',
              value: '${links.length - visibleCount} links hidden',
              icon: Icons.visibility_off_rounded,
              color: const Color(0xFFFFB44C),
            ),
          ],
        );
      }),
    );

    if (isCompact) {
      return Column(
        children: [linkList, const SizedBox(height: 18), infoPanel],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: linkList),
        const SizedBox(width: 18),
        Expanded(flex: 4, child: infoPanel),
      ],
    );
  }
}

class SocialLinkRow extends StatelessWidget {
  const SocialLinkRow({
    super.key,
    required this.link,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleVisibility,
  });

  final ManagedSocialLink link;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggleVisibility;

  IconData get _icon {
    return switch (link.platform.toLowerCase()) {
      'linkedin' => Icons.work_rounded,
      'github' => Icons.code_rounded,
      'twitter' || 'x' => Icons.tag_rounded,
      'instagram' => Icons.camera_alt_rounded,
      'youtube' => Icons.play_circle_rounded,
      'medium' => Icons.article_rounded,
      'email' => Icons.mail_rounded,
      _ => Icons.link_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: AppColors.primaryGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      link.platform,
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        link.type.toUpperCase(),
                        style: GoogleFonts.manrope(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  link.value,
                  style: GoogleFonts.manrope(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Transform.scale(
            scale: 0.82,
            child: Switch(
              value: link.isVisible,
              onChanged: onToggleVisibility,
              activeThumbColor: AppColors.primaryGreen,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.white54,
              size: 18,
            ),
            tooltip: 'Edit',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFFF7C7C),
              size: 18,
            ),
            tooltip: 'Delete',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

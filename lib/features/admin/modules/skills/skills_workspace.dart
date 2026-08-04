import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/skill_icons.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../shared/dialog_widgets.dart';
import '../../shared/preview_tile.dart';
import '../../widgets/admin_buttons.dart';
import '../../widgets/admin_section_header.dart';
import '../../widgets/admin_surface_card.dart';
import 'widgets/skill_row.dart';

export 'widgets/skill_row.dart';

class SkillsWorkspace extends ConsumerStatefulWidget {
  const SkillsWorkspace({
    super.key,
    required this.isCompact,
  });

  final bool isCompact;

  @override
  ConsumerState<SkillsWorkspace> createState() => _SkillsWorkspaceState();
}

class _SkillsWorkspaceState extends ConsumerState<SkillsWorkspace> {
  void _openEditDialog(
    List<SkillItem> skills, {
    SkillItem? existing,
    int? index,
  }) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final categoryCtrl = TextEditingController(text: existing?.category ?? '');
    final descriptionCtrl = TextEditingController(text: existing?.description ?? '');
    int percent = existing?.percent ?? 80;
    String iconKey = existing?.iconKey ?? kSkillIconKeys.first;
    bool isVisible = existing?.isVisible ?? true;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: const Color(0xFF1A1C1F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            existing == null ? 'Add Skill' : 'Edit Skill',
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
                  controller: nameCtrl,
                  label: 'Skill name',
                  hint: 'e.g. Flutter',
                ),
                const SizedBox(height: 14),
                DialogField(
                  controller: categoryCtrl,
                  label: 'Category',
                  hint: 'e.g. Mobile, Backend, Design',
                ),
                const SizedBox(height: 14),
                DialogField(
                  controller: descriptionCtrl,
                  label: 'Description',
                  hint: 'Short line shown under the skill name',
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Icon',
                    style: GoogleFonts.manrope(
                      color: Colors.white54,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final key in kSkillIconKeys)
                      GestureDetector(
                        onTap: () => setDlg(() => iconKey = key),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: iconKey == key
                                ? AppColors.primaryGreen.withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: iconKey == key
                                  ? AppColors.primaryGreen
                                  : Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Icon(
                            iconForSkillKey(key),
                            size: 18,
                            color: iconKey == key ? AppColors.primaryGreen : Colors.white54,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      'Proficiency',
                      style: GoogleFonts.manrope(
                        color: Colors.white54,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$percent%',
                      style: GoogleFonts.manrope(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: percent.toDouble(),
                  min: 10,
                  max: 100,
                  divisions: 18,
                  activeColor: AppColors.primaryGreen,
                  inactiveColor: Colors.white12,
                  onChanged: (v) => setDlg(() => percent = v.round()),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Visible on portfolio',
                      style: GoogleFonts.manrope(color: Colors.white70, fontSize: 13),
                    ),
                    Switch(
                      value: isVisible,
                      onChanged: (v) => setDlg(() => isVisible = v),
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
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                final item = SkillItem(
                  id: existing?.id ?? '',
                  name: name,
                  percent: percent,
                  iconKey: iconKey,
                  description: descriptionCtrl.text.trim(),
                  category: categoryCtrl.text.trim(),
                  displayOrder: (index ?? skills.length) + 1,
                  isVisible: isVisible,
                );
                ref.read(adminPortalProvider.notifier).saveSkill(item);
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Save',
                style: GoogleFonts.manrope(color: AppColors.primaryGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final skills = ref.watch(portfolioProvider.select((s) => s.skills));

    final skillList = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'SKILLS & EXPERIENCE',
            title: 'Technical proficiency',
            description:
                'Manage your skill stack and proficiency levels shown on the portfolio.',
            action: AdminPrimaryButton(
              label: 'Add skill',
              icon: Icons.add_rounded,
              onPressed: () => _openEditDialog(skills),
            ),
          ),
          const SizedBox(height: 18),
          if (skills.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No skills yet. Add one above.',
                  style: GoogleFonts.manrope(color: Colors.white38),
                ),
              ),
            )
          else
            ...skills.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SkillRow(
                  skill: entry.value,
                  onEdit: () => _openEditDialog(skills, existing: entry.value, index: entry.key),
                  onDelete: () => ref.read(adminPortalProvider.notifier).deleteSkill(entry.value.id),
                  onToggle: (v) => ref
                      .read(adminPortalProvider.notifier)
                      .saveSkill(entry.value.copyWith(isVisible: v)),
                ),
              ),
            ),
        ],
      ),
    );

    final statsPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'SKILL STATS',
            title: 'Stack overview',
            description: 'Summary of skills by category.',
          ),
          const SizedBox(height: 18),
          PreviewTile(
            title: 'Total skills',
            value: '${skills.length} skills listed',
            icon: Icons.stacked_line_chart_rounded,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Avg proficiency',
            value: skills.isEmpty
                ? 'No skills yet'
                : '${(skills.map((s) => s.percent).reduce((a, b) => a + b) / skills.length).round()}% average',
            icon: Icons.bar_chart_rounded,
            color: const Color(0xFF5CD6FF),
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Categories',
            value: skills.isEmpty
                ? 'No categories'
                : '${skills.map((s) => s.category).where((c) => c.isNotEmpty).toSet().length} distinct categories',
            icon: Icons.category_rounded,
            color: const Color(0xFFFFB44C),
          ),
        ],
      ),
    );

    if (widget.isCompact) {
      return Column(
        children: [skillList, const SizedBox(height: 18), statsPanel],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: skillList),
        const SizedBox(width: 18),
        Expanded(flex: 4, child: statsPanel),
      ],
    );
  }
}

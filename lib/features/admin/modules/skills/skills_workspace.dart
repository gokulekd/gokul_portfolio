import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../controllers/admin_portal_controller.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/dialog_widgets.dart';
import '../../shared/preview_tile.dart';

class SkillsWorkspace extends StatefulWidget {
  const SkillsWorkspace({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  @override
  State<SkillsWorkspace> createState() => _SkillsWorkspaceState();
}

class _SkillsWorkspaceState extends State<SkillsWorkspace> {
  final _skills = <SkillEntry>[
    SkillEntry(name: 'Flutter', percent: 95, category: 'Mobile'),
    SkillEntry(name: 'Dart', percent: 90, category: 'Language'),
    SkillEntry(name: 'Firebase', percent: 85, category: 'Backend'),
    SkillEntry(name: 'GetX', percent: 88, category: 'State Mgmt'),
    SkillEntry(name: 'REST APIs', percent: 80, category: 'Integration'),
    SkillEntry(name: 'UI/UX Design', percent: 75, category: 'Design'),
  ];

  void _openEditDialog({SkillEntry? existing, int? index}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final categoryCtrl = TextEditingController(text: existing?.category ?? '');
    int percent = existing?.percent ?? 80;

    showDialog<void>(
      context: context,
      builder:
          (ctx) => StatefulBuilder(
            builder:
                (ctx, setDlg) => AlertDialog(
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
                  content: Column(
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
                    ],
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
                        final category = categoryCtrl.text.trim();
                        if (name.isEmpty) return;
                        setState(() {
                          if (index != null) {
                            _skills[index] = SkillEntry(
                              name: name,
                              percent: percent,
                              category: category,
                            );
                          } else {
                            _skills.add(
                              SkillEntry(
                                name: name,
                                percent: percent,
                                category: category,
                              ),
                            );
                          }
                        });
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
              onPressed: () => _openEditDialog(),
            ),
          ),
          const SizedBox(height: 18),
          ..._skills.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SkillRow(
                skill: entry.value,
                onEdit:
                    () => _openEditDialog(
                      existing: entry.value,
                      index: entry.key,
                    ),
                onDelete: () => setState(() => _skills.removeAt(entry.key)),
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
            value: '${_skills.length} skills listed',
            icon: Icons.stacked_line_chart_rounded,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Avg proficiency',
            value:
                _skills.isEmpty
                    ? 'No skills yet'
                    : '${(_skills.map((s) => s.percent).reduce((a, b) => a + b) / _skills.length).round()}% average',
            icon: Icons.bar_chart_rounded,
            color: const Color(0xFF5CD6FF),
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Categories',
            value:
                _skills.isEmpty
                    ? 'No categories'
                    : '${_skills.map((s) => s.category).toSet().length} distinct categories',
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

class SkillEntry {
  SkillEntry({
    required this.name,
    required this.percent,
    required this.category,
  });
  final String name;
  final int percent;
  final String category;
}

class SkillRow extends StatelessWidget {
  const SkillRow({
    super.key,
    required this.skill,
    required this.onEdit,
    required this.onDelete,
  });

  final SkillEntry skill;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      skill.name,
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        skill.category,
                        style: GoogleFonts.manrope(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: skill.percent / 100,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryGreen,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${skill.percent}%',
                      style: GoogleFonts.manrope(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.white54,
              size: 18,
            ),
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
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

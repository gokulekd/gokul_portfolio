import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../controllers/admin_portal_controller.dart';
import '../../shared/dialog_widgets.dart';
import '../../shared/preview_tile.dart';
import '../../widgets/admin_buttons.dart';
import '../../widgets/admin_section_header.dart';
import '../../widgets/admin_surface_card.dart';
import 'models/skill_entry.dart';
import 'widgets/skill_row.dart';

export 'models/skill_entry.dart';
export 'widgets/skill_row.dart';

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
    const SkillEntry(name: 'Flutter', percent: 95, category: 'Mobile'),
    const SkillEntry(name: 'Dart', percent: 90, category: 'Language'),
    const SkillEntry(name: 'Firebase', percent: 85, category: 'Backend'),
    const SkillEntry(name: 'GetX', percent: 88, category: 'State Mgmt'),
    const SkillEntry(name: 'REST APIs', percent: 80, category: 'Integration'),
    const SkillEntry(name: 'UI/UX Design', percent: 75, category: 'Design'),
  ];

  void _openEditDialog({SkillEntry? existing, int? index}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final categoryCtrl = TextEditingController(text: existing?.category ?? '');
    int percent = existing?.percent ?? 80;

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
                  final entry = SkillEntry(
                    name: name,
                    percent: percent,
                    category: category,
                  );
                  if (index != null) {
                    _skills[index] = entry;
                  } else {
                    _skills.add(entry);
                  }
                });
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
                onEdit: () =>
                    _openEditDialog(existing: entry.value, index: entry.key),
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
            value: _skills.isEmpty
                ? 'No skills yet'
                : '${(_skills.map((s) => s.percent).reduce((a, b) => a + b) / _skills.length).round()}% average',
            icon: Icons.bar_chart_rounded,
            color: const Color(0xFF5CD6FF),
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Categories',
            value: _skills.isEmpty
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

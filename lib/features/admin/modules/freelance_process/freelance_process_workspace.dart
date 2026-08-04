import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../shared/content_list_workspace.dart' show ContentItem, ContentItemRow;
import '../../shared/dialog_widgets.dart';
import '../../shared/preview_tile.dart';
import '../../widgets/admin_buttons.dart';
import '../../widgets/admin_section_header.dart';
import '../../widgets/admin_surface_card.dart';

/// Bespoke editor for the "Freelance Process" steps. `ProcessStepItem` has
/// four flat fields (label, number, title, timeEstimate) plus a nested
/// `items` list (2-4 sub-bullets, each a `key`/`description` pair) — too much
/// shape for `ContentListWorkspace`'s 3-field limit, so this gets its own
/// dialog.
///
/// Decision (Day 5): sub-items are edited as one line per bullet in a single
/// multiline field, formatted "Key: description" — matching how the key
/// already reads on the public card (bold label + colon, then body text).
/// A line with no colon becomes a bullet with an empty key. This avoids
/// building a full nested add/remove-row UI for what's a short, rarely
/// reordered list.
class FreelanceProcessWorkspace extends ConsumerStatefulWidget {
  const FreelanceProcessWorkspace({super.key, required this.isCompact});

  final bool isCompact;

  @override
  ConsumerState<FreelanceProcessWorkspace> createState() =>
      _FreelanceProcessWorkspaceState();
}

class _FreelanceProcessWorkspaceState
    extends ConsumerState<FreelanceProcessWorkspace> {
  static List<ProcessStepDetail> _parseItems(String raw) {
    return raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .map((line) {
          final colonIndex = line.indexOf(':');
          if (colonIndex == -1) {
            return ProcessStepDetail(key: '', description: line);
          }
          return ProcessStepDetail(
            key: line.substring(0, colonIndex + 1).trim(),
            description: line.substring(colonIndex + 1).trim(),
          );
        })
        .toList();
  }

  static String _itemsToText(List<ProcessStepDetail> items) {
    return items
        .map((i) => i.key.isEmpty ? i.description : '${i.key} ${i.description}')
        .join('\n');
  }

  void _openDialog(
    List<ProcessStepItem> steps, {
    ProcessStepItem? existing,
    int? index,
  }) {
    final labelCtrl = TextEditingController(text: existing?.label ?? '');
    final numberCtrl = TextEditingController(
      text: existing?.number ?? ((index ?? steps.length) + 1).toString().padLeft(2, '0'),
    );
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final timeCtrl = TextEditingController(text: existing?.timeEstimate ?? '');
    final itemsCtrl = TextEditingController(
      text: existing == null ? '' : _itemsToText(existing.items),
    );
    bool isVisible = existing?.isVisible ?? true;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: const Color(0xFF1A1C1F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            existing == null ? 'Add Process Step' : 'Edit Process Step',
            style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DialogField(
                    controller: labelCtrl,
                    label: 'Label',
                    hint: 'e.g. Discovery',
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DialogField(
                          controller: numberCtrl,
                          label: 'Number',
                          hint: 'e.g. 01',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DialogField(
                          controller: timeCtrl,
                          label: 'Time estimate',
                          hint: 'e.g. 3-5 days',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  DialogField(
                    controller: titleCtrl,
                    label: 'Title',
                    hint: "e.g. We'll dive deep into your goals and vision",
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),
                  DialogField(
                    controller: itemsCtrl,
                    label: 'Sub-steps (one per line, "Key: description")',
                    hint: 'Initial Consultation: Understand the client\'s vision, goals, and target audience.',
                    maxLines: 6,
                  ),
                  const SizedBox(height: 14),
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: GoogleFonts.manrope(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () {
                final label = labelCtrl.text.trim();
                final title = titleCtrl.text.trim();
                if (label.isEmpty || title.isEmpty) return;
                final step = ProcessStepItem(
                  id: existing?.id ?? '',
                  label: label,
                  number: numberCtrl.text.trim(),
                  title: title,
                  timeEstimate: timeCtrl.text.trim(),
                  items: _parseItems(itemsCtrl.text),
                  displayOrder: (index ?? steps.length) + 1,
                  isVisible: isVisible,
                );
                ref.read(adminPortalProvider.notifier).saveProcessStep(step);
                Navigator.of(ctx).pop();
              },
              child: Text('Save', style: GoogleFonts.manrope(color: AppColors.primaryGreen)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = ref.watch(portfolioProvider.select((s) => s.processSteps));

    final stepList = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'FREELANCE PROCESS',
            title: 'Client journey steps',
            description:
                'Define how prospects understand the collaboration flow from first message to delivery.',
            action: AdminPrimaryButton(
              label: 'Add step',
              icon: Icons.add_rounded,
              onPressed: () => _openDialog(steps),
            ),
          ),
          const SizedBox(height: 18),
          if (steps.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No steps yet. Add one above.',
                  style: GoogleFonts.manrope(color: Colors.white38),
                ),
              ),
            )
          else
            ...steps.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ContentItemRow(
                  item: ContentItem(
                    id: entry.value.id,
                    title: '${entry.value.label} · ${entry.value.title}',
                    body: entry.value.items
                        .map((i) => i.key.isEmpty ? i.description : '${i.key} ${i.description}')
                        .join('  '),
                    meta: entry.value.number,
                    isVisible: entry.value.isVisible,
                  ),
                  onEdit: () => _openDialog(steps, existing: entry.value, index: entry.key),
                  onDelete: () => ref
                      .read(adminPortalProvider.notifier)
                      .deleteProcessStep(entry.value.id),
                  onToggle: (v) => ref
                      .read(adminPortalProvider.notifier)
                      .saveProcessStep(entry.value.copyWith(isVisible: v)),
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
            eyebrow: 'OVERVIEW',
            title: 'Process stats',
            description: 'Current publish state for this collection.',
          ),
          const SizedBox(height: 18),
          PreviewTile(
            title: 'Total steps',
            value: '${steps.length} steps',
            icon: Icons.list_rounded,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Live',
            value: '${steps.where((s) => s.isVisible).length} visible publicly',
            icon: Icons.visibility_rounded,
            color: const Color(0xFF5CD6FF),
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Hidden',
            value: '${steps.where((s) => !s.isVisible).length} in draft',
            icon: Icons.visibility_off_rounded,
            color: const Color(0xFFFF7C7C),
          ),
        ],
      ),
    );

    if (widget.isCompact) {
      return Column(children: [stepList, const SizedBox(height: 18), statsPanel]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: stepList),
        const SizedBox(width: 18),
        Expanded(flex: 4, child: statsPanel),
      ],
    );
  }
}

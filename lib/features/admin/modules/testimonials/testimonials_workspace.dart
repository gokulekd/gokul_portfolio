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

/// Bespoke editor for client testimonials. `TestimonialItem` has a rating
/// (0.5-step slider, defaults to 5.0) and an optional avatar URL on top of
/// the flat name/role/quote fields — too much for `ContentListWorkspace`'s
/// 3-field limit, so this gets its own dialog. An empty avatar URL is valid;
/// the public card already falls back to author initials
/// (`testimonials_section.dart`).
class TestimonialsWorkspace extends ConsumerStatefulWidget {
  const TestimonialsWorkspace({super.key, required this.isCompact});

  final bool isCompact;

  @override
  ConsumerState<TestimonialsWorkspace> createState() =>
      _TestimonialsWorkspaceState();
}

class _TestimonialsWorkspaceState extends ConsumerState<TestimonialsWorkspace> {
  void _openDialog(
    List<TestimonialItem> testimonials, {
    TestimonialItem? existing,
    int? index,
  }) {
    final nameCtrl = TextEditingController(text: existing?.authorName ?? '');
    final roleCtrl = TextEditingController(text: existing?.authorRole ?? '');
    final textCtrl = TextEditingController(text: existing?.text ?? '');
    final avatarCtrl = TextEditingController(text: existing?.avatarUrl ?? '');
    double rating = existing?.rating ?? 5.0;
    bool isVisible = existing?.isVisible ?? true;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: const Color(0xFF1A1C1F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            existing == null ? 'Add Testimonial' : 'Edit Testimonial',
            style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DialogField(
                    controller: nameCtrl,
                    label: 'Client name',
                    hint: 'e.g. Jane Doe',
                  ),
                  const SizedBox(height: 14),
                  DialogField(
                    controller: roleCtrl,
                    label: 'Role / Company',
                    hint: 'e.g. CEO, Acme Corp',
                  ),
                  const SizedBox(height: 14),
                  DialogField(
                    controller: textCtrl,
                    label: 'Quote',
                    hint: 'What the client said…',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 14),
                  DialogField(
                    controller: avatarCtrl,
                    label: 'Avatar URL (optional)',
                    hint: 'Leave blank to show initials instead',
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        'Rating',
                        style: GoogleFonts.manrope(
                          color: Colors.white54,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${rating.toStringAsFixed(1)}/5',
                        style: GoogleFonts.manrope(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: rating,
                    min: 1,
                    max: 5,
                    divisions: 8,
                    activeColor: AppColors.primaryGreen,
                    inactiveColor: Colors.white12,
                    onChanged: (v) => setDlg(() => rating = v),
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: GoogleFonts.manrope(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final text = textCtrl.text.trim();
                if (name.isEmpty || text.isEmpty) return;
                final testimonial = TestimonialItem(
                  id: existing?.id ?? '',
                  rating: rating,
                  text: text,
                  authorName: name,
                  authorRole: roleCtrl.text.trim(),
                  avatarUrl: avatarCtrl.text.trim(),
                  displayOrder: (index ?? testimonials.length) + 1,
                  isVisible: isVisible,
                );
                ref.read(adminPortalProvider.notifier).saveTestimonial(testimonial);
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
    final testimonials = ref.watch(portfolioProvider.select((s) => s.testimonials));

    final testimonialList = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'TESTIMONIALS',
            title: 'Client feedback',
            description: 'Manage client quotes and social proof shown on the portfolio.',
            action: AdminPrimaryButton(
              label: 'Add testimonial',
              icon: Icons.add_rounded,
              onPressed: () => _openDialog(testimonials),
            ),
          ),
          const SizedBox(height: 18),
          if (testimonials.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No testimonials yet. Add one above.',
                  style: GoogleFonts.manrope(color: Colors.white38),
                ),
              ),
            )
          else
            ...testimonials.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ContentItemRow(
                  item: ContentItem(
                    id: entry.value.id,
                    title: entry.value.authorName,
                    body: entry.value.text,
                    meta: '${entry.value.rating.toStringAsFixed(1)}★'
                        '${entry.value.authorRole.isNotEmpty ? ' · ${entry.value.authorRole}' : ''}',
                    isVisible: entry.value.isVisible,
                  ),
                  onEdit: () => _openDialog(testimonials, existing: entry.value, index: entry.key),
                  onDelete: () => ref
                      .read(adminPortalProvider.notifier)
                      .deleteTestimonial(entry.value.id),
                  onToggle: (v) => ref
                      .read(adminPortalProvider.notifier)
                      .saveTestimonial(entry.value.copyWith(isVisible: v)),
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
            title: 'Testimonial stats',
            description: 'Current publish state for this collection.',
          ),
          const SizedBox(height: 18),
          PreviewTile(
            title: 'Total testimonials',
            value: '${testimonials.length} testimonials',
            icon: Icons.list_rounded,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Live',
            value: '${testimonials.where((t) => t.isVisible).length} visible publicly',
            icon: Icons.visibility_rounded,
            color: const Color(0xFF5CD6FF),
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Hidden',
            value: '${testimonials.where((t) => !t.isVisible).length} in draft',
            icon: Icons.visibility_off_rounded,
            color: const Color(0xFFFF7C7C),
          ),
        ],
      ),
    );

    if (widget.isCompact) {
      return Column(children: [testimonialList, const SizedBox(height: 18), statsPanel]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: testimonialList),
        const SizedBox(width: 18),
        Expanded(flex: 4, child: statsPanel),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../portfolio/models/testimonial_entry.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/dialog_widgets.dart';
import '../../shared/preview_tile.dart';
import '../../widgets/admin_buttons.dart';
import '../../widgets/admin_section_header.dart';
import '../../widgets/admin_state_chip.dart';
import '../../widgets/admin_surface_card.dart';

/// Moderation queue for testimonials submitted through the public
/// `/leave-a-review` page (see `TestimonialSubmissionPage`). Every submission
/// lands as `pending` in Supabase — nothing here is ever live until an admin
/// approves it. `TestimonialEntry` has a rating, optional uploaded avatar,
/// and a `status` (pending/published/hidden), so this gets its own custom
/// list rather than reusing `ContentListWorkspace`.
enum _StatusFilter { all, pending, published, hidden }

class TestimonialsWorkspace extends ConsumerStatefulWidget {
  const TestimonialsWorkspace({super.key, required this.isCompact});

  final bool isCompact;

  @override
  ConsumerState<TestimonialsWorkspace> createState() =>
      _TestimonialsWorkspaceState();
}

class _TestimonialsWorkspaceState extends ConsumerState<TestimonialsWorkspace> {
  _StatusFilter _filter = _StatusFilter.all;
  bool _isRefreshing = false;

  /// New submissions land in Supabase directly from the public page — this
  /// running session's `portfolioProvider` only fetches testimonials once at
  /// startup, so an admin already sitting on this workspace won't see a
  /// fresh pending review until something re-fetches. Wire that to a manual
  /// refresh rather than polling.
  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    await ref.read(portfolioProvider.notifier).refreshTestimonials();
    if (mounted) setState(() => _isRefreshing = false);
  }

  void _openDialog(
    WidgetRef ref, {
    TestimonialEntry? existing,
  }) {
    final nameCtrl = TextEditingController(text: existing?.authorName ?? '');
    final roleCtrl = TextEditingController(text: existing?.authorRole ?? '');
    final textCtrl = TextEditingController(text: existing?.text ?? '');
    final avatarCtrl = TextEditingController(text: existing?.avatarUrl ?? '');
    double rating = existing?.rating ?? 5.0;
    String status = existing?.status ?? TestimonialStatus.published;

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
                    label: 'Name',
                    hint: 'e.g. Jane Doe',
                  ),
                  const SizedBox(height: 14),
                  DialogField(
                    controller: roleCtrl,
                    label: 'Role / Company',
                    hint: 'e.g. Product Manager, Acme Corp',
                  ),
                  const SizedBox(height: 14),
                  DialogField(
                    controller: textCtrl,
                    label: 'Message',
                    hint: 'What they said…',
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Status',
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
                    children: [
                      TypeChip(
                        label: 'Pending',
                        selected: status == TestimonialStatus.pending,
                        onTap: () => setDlg(() => status = TestimonialStatus.pending),
                      ),
                      TypeChip(
                        label: 'Published',
                        selected: status == TestimonialStatus.published,
                        onTap: () => setDlg(() => status = TestimonialStatus.published),
                      ),
                      TypeChip(
                        label: 'Hidden',
                        selected: status == TestimonialStatus.hidden,
                        onTap: () => setDlg(() => status = TestimonialStatus.hidden),
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
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final text = textCtrl.text.trim();
                if (name.isEmpty || text.isEmpty) return;
                final entry = TestimonialEntry(
                  id: existing?.id ?? '',
                  rating: rating,
                  text: text,
                  authorName: name,
                  authorRole: roleCtrl.text.trim(),
                  avatarUrl: avatarCtrl.text.trim(),
                  status: status,
                  createdAt: existing?.createdAt ?? DateTime.now(),
                );
                Navigator.of(ctx).pop();
                await ref.read(adminPortalProvider.notifier).saveTestimonialEntry(entry);
              },
              child: Text('Save', style: GoogleFonts.manrope(color: AppColors.primaryGreen)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(WidgetRef ref, TestimonialEntry entry) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1C1F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete testimonial?', style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700)),
        content: Text(
          'This permanently removes ${entry.authorName}\'s review. This can\'t be undone.',
          style: GoogleFonts.manrope(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: GoogleFonts.manrope(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(adminPortalProvider.notifier).deleteTestimonialEntry(entry.id);
            },
            child: Text('Delete', style: GoogleFonts.manrope(color: const Color(0xFFFF7C7C))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final testimonials = ref.watch(portfolioProvider.select((s) => s.testimonials));
    final notifier = ref.read(adminPortalProvider.notifier);

    final pending = testimonials.where((t) => t.isPending).toList();
    final published = testimonials.where((t) => t.isVisible).toList();
    final hidden = testimonials.where((t) => t.isHidden).toList();

    final filtered = switch (_filter) {
      _StatusFilter.all => testimonials,
      _StatusFilter.pending => pending,
      _StatusFilter.published => published,
      _StatusFilter.hidden => hidden,
    };
    // Pending submissions surface first so new reviews don't get buried.
    final sorted = [...filtered]..sort((a, b) {
      if (a.isPending != b.isPending) return a.isPending ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    final testimonialList = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'TESTIMONIALS',
            title: 'Real reviews from real people',
            description:
                'Submitted via the public /leave-a-review link. Approve to publish, hide to keep private, or edit before it goes live.',
            action: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AdminGhostButton(
                  label: _isRefreshing ? 'Refreshing…' : 'Refresh',
                  icon: Icons.refresh_rounded,
                  onPressed: _isRefreshing ? () {} : _refresh,
                ),
                const SizedBox(width: 10),
                AdminPrimaryButton(
                  label: 'Add testimonial',
                  icon: Icons.add_rounded,
                  onPressed: () => _openDialog(ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip(
                label: 'All',
                count: testimonials.length,
                selected: _filter == _StatusFilter.all,
                onTap: () => setState(() => _filter = _StatusFilter.all),
              ),
              _FilterChip(
                label: 'Pending review',
                count: pending.length,
                selected: _filter == _StatusFilter.pending,
                highlight: pending.isNotEmpty,
                onTap: () => setState(() => _filter = _StatusFilter.pending),
              ),
              _FilterChip(
                label: 'Published',
                count: published.length,
                selected: _filter == _StatusFilter.published,
                onTap: () => setState(() => _filter = _StatusFilter.published),
              ),
              _FilterChip(
                label: 'Hidden',
                count: hidden.length,
                selected: _filter == _StatusFilter.hidden,
                onTap: () => setState(() => _filter = _StatusFilter.hidden),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (sorted.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  testimonials.isEmpty
                      ? 'No testimonials yet. Share the /leave-a-review link to collect some.'
                      : 'Nothing in this filter.',
                  style: GoogleFonts.manrope(color: Colors.white38),
                ),
              ),
            )
          else
            ...sorted.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TestimonialRow(
                  entry: entry,
                  onEdit: () => _openDialog(ref, existing: entry),
                  onDelete: () => _confirmDelete(ref, entry),
                  onApprove: () => notifier.saveTestimonialEntry(
                    entry.copyWith(status: TestimonialStatus.published),
                  ),
                  onHide: () => notifier.saveTestimonialEntry(
                    entry.copyWith(status: TestimonialStatus.hidden),
                  ),
                  onPublish: () => notifier.saveTestimonialEntry(
                    entry.copyWith(status: TestimonialStatus.published),
                  ),
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
            title: 'Pending review',
            value: '${pending.length} awaiting a decision',
            icon: Icons.hourglass_top_rounded,
            color: const Color(0xFFFFB44C),
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Published',
            value: '${published.length} live on the portfolio',
            icon: Icons.visibility_rounded,
            color: const Color(0xFF5CD6FF),
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Hidden',
            value: '${hidden.length} kept private',
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    this.highlight = false,
  });

  final String label;
  final int count;
  final bool selected;
  final bool highlight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = highlight ? const Color(0xFFFFB44C) : AppColors.primaryGreen;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.16) : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? accent.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(
                color: selected ? accent : Colors.white60,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.manrope(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestimonialRow extends StatelessWidget {
  const _TestimonialRow({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
    required this.onApprove,
    required this.onHide,
    required this.onPublish,
  });

  final TestimonialEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onApprove;
  final VoidCallback onHide;
  final VoidCallback onPublish;

  String _initials(String name) {
    final parts = name.split(' ').where((p) => p.trim().isNotEmpty).take(2).toList();
    if (parts.isEmpty) return '?';
    return parts.map((p) => p[0].toUpperCase()).join();
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  AdminItemState get _state => switch (entry.status) {
    TestimonialStatus.published => AdminItemState.live,
    TestimonialStatus.hidden => AdminItemState.hidden,
    _ => AdminItemState.draft,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: entry.isPending
            ? const Color(0xFFFFB44C).withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: entry.isPending
              ? const Color(0xFFFFB44C).withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white12,
                backgroundImage: entry.avatarUrl.isNotEmpty ? NetworkImage(entry.avatarUrl) : null,
                child: entry.avatarUrl.isEmpty
                    ? Text(
                        _initials(entry.authorName),
                        style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.authorName,
                            style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.5),
                          ),
                        ),
                        AdminStateChip(
                          state: _state,
                          label: entry.isPending ? 'Pending' : null,
                        ),
                      ],
                    ),
                    if (entry.authorRole.isNotEmpty)
                      Text(
                        entry.authorRole,
                        style: GoogleFonts.manrope(color: Colors.white54, fontSize: 11.5, fontWeight: FontWeight.w600),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          final filled = i < entry.rating.round();
                          return Icon(
                            filled ? Icons.star_rounded : Icons.star_border_rounded,
                            size: 14,
                            color: filled ? AppColors.primaryGreen : Colors.white24,
                          );
                        }),
                        const SizedBox(width: 6),
                        Text(
                          '${entry.rating.toStringAsFixed(1)}/5 · ${_timeAgo(entry.createdAt)}',
                          style: GoogleFonts.manrope(color: Colors.white38, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            entry.text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(color: Colors.white70, fontSize: 12.5, height: 1.55),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (entry.isPending) ...[
                _ActionButton(label: 'Approve', icon: Icons.check_rounded, color: AppColors.primaryGreen, onTap: onApprove),
                _ActionButton(label: 'Hide', icon: Icons.visibility_off_rounded, color: Colors.white54, onTap: onHide),
              ] else if (entry.isHidden)
                _ActionButton(label: 'Publish', icon: Icons.visibility_rounded, color: AppColors.primaryGreen, onTap: onPublish)
              else
                _ActionButton(label: 'Hide', icon: Icons.visibility_off_rounded, color: Colors.white54, onTap: onHide),
              _ActionButton(label: 'Edit', icon: Icons.edit_rounded, color: Colors.white54, onTap: onEdit),
              _ActionButton(label: 'Delete', icon: Icons.delete_outline_rounded, color: const Color(0xFFFF7C7C), onTap: onDelete),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
            Text(label, style: GoogleFonts.manrope(color: color, fontSize: 11.5, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

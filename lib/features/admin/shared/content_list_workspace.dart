import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../models/admin_portal_models.dart';
import 'admin_portal_components.dart';
import 'dialog_widgets.dart';
import 'preview_tile.dart';

class ContentItem {
  const ContentItem({
    required this.title,
    required this.body,
    this.meta,
    this.isVisible = true,
  });

  final String title;
  final String body;
  final String? meta;
  final bool isVisible;

  ContentItem copyWith({
    String? title,
    String? body,
    String? meta,
    bool? isVisible,
  }) => ContentItem(
    title: title ?? this.title,
    body: body ?? this.body,
    meta: meta ?? this.meta,
    isVisible: isVisible ?? this.isVisible,
  );
}

class ContentListWorkspace extends StatefulWidget {
  const ContentListWorkspace({
    super.key,
    required this.module,
    required this.isCompact,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.itemLabel,
    required this.fieldOneLabel,
    required this.fieldOneHint,
    required this.fieldTwoLabel,
    required this.fieldTwoHint,
    this.fieldThreeLabel,
    this.fieldThreeHint,
    required this.defaultItems,
  });

  final AdminModule module;
  final bool isCompact;
  final String eyebrow;
  final String title;
  final String description;
  final String itemLabel;
  final String fieldOneLabel;
  final String fieldOneHint;
  final String fieldTwoLabel;
  final String fieldTwoHint;
  final String? fieldThreeLabel;
  final String? fieldThreeHint;
  final List<ContentItem> defaultItems;

  @override
  State<ContentListWorkspace> createState() => _ContentListWorkspaceState();
}

class _ContentListWorkspaceState extends State<ContentListWorkspace> {
  late final List<ContentItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.defaultItems);
  }

  void _openDialog({ContentItem? existing, int? index}) {
    final f1 = TextEditingController(text: existing?.title ?? '');
    final f2 = TextEditingController(text: existing?.body ?? '');
    final f3 = TextEditingController(text: existing?.meta ?? '');
    bool isVisible = existing?.isVisible ?? true;

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
                    existing == null
                        ? 'Add ${widget.itemLabel}'
                        : 'Edit ${widget.itemLabel}',
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
                          controller: f1,
                          label: widget.fieldOneLabel,
                          hint: widget.fieldOneHint,
                        ),
                        const SizedBox(height: 14),
                        DialogField(
                          controller: f2,
                          label: widget.fieldTwoLabel,
                          hint: widget.fieldTwoHint,
                          maxLines: 4,
                        ),
                        if (widget.fieldThreeLabel != null) ...[
                          const SizedBox(height: 14),
                          DialogField(
                            controller: f3,
                            label: widget.fieldThreeLabel!,
                            hint: widget.fieldThreeHint ?? '',
                          ),
                        ],
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
                        final title = f1.text.trim();
                        final body = f2.text.trim();
                        if (title.isEmpty || body.isEmpty) return;
                        final item = ContentItem(
                          title: title,
                          body: body,
                          meta: f3.text.trim().isEmpty ? null : f3.text.trim(),
                          isVisible: isVisible,
                        );
                        setState(() {
                          if (index != null) {
                            _items[index] = item;
                          } else {
                            _items.add(item);
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
    final liveCount = _items.where((i) => i.isVisible).length;

    final itemList = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: widget.eyebrow,
            title: widget.title,
            description: widget.description,
            action: AdminPrimaryButton(
              label: 'Add ${widget.itemLabel.toLowerCase()}',
              icon: Icons.add_rounded,
              onPressed: () => _openDialog(),
            ),
          ),
          const SizedBox(height: 18),
          if (_items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No items yet. Add one above.',
                  style: GoogleFonts.manrope(color: Colors.white38),
                ),
              ),
            )
          else
            ..._items.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ContentItemRow(
                  item: e.value,
                  onEdit: () => _openDialog(existing: e.value, index: e.key),
                  onDelete: () => setState(() => _items.removeAt(e.key)),
                  onToggle:
                      (val) => setState(
                        () => _items[e.key] = e.value.copyWith(isVisible: val),
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
          AdminSectionHeader(
            eyebrow: 'OVERVIEW',
            title: '${widget.itemLabel} stats',
            description: 'Current publish state for this collection.',
          ),
          const SizedBox(height: 18),
          PreviewTile(
            title: 'Total items',
            value: '${_items.length} ${widget.itemLabel.toLowerCase()}s',
            icon: Icons.list_rounded,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Live',
            value: '$liveCount visible publicly',
            icon: Icons.visibility_rounded,
            color: const Color(0xFF5CD6FF),
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Hidden',
            value: '${_items.length - liveCount} in draft',
            icon: Icons.visibility_off_rounded,
            color: const Color(0xFFFF7C7C),
          ),
        ],
      ),
    );

    if (widget.isCompact) {
      return Column(
        children: [itemList, const SizedBox(height: 18), statsPanel],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: itemList),
        const SizedBox(width: 18),
        Expanded(flex: 4, child: statsPanel),
      ],
    );
  }
}

class ContentItemRow extends StatelessWidget {
  const ContentItemRow({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  final ContentItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (item.meta != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          item.meta!,
                          style: GoogleFonts.manrope(
                            color: AppColors.primaryGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 8),
                    AdminStateChip(
                      state:
                          item.isVisible
                              ? AdminItemState.live
                              : AdminItemState.hidden,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    color: Colors.white60,
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Transform.scale(
                scale: 0.82,
                child: Switch(
                  value: item.isVisible,
                  onChanged: onToggle,
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
        ],
      ),
    );
  }
}

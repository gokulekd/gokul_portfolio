import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/content_list_workspace.dart';

/// Firestore-backed editor for the Resume page's highlight cards
/// (Core Skills / Working Style / Value I Bring). `ResumeHighlightGroup` has
/// a title + `List<String> items` — items are edited as one line per bullet
/// in the body field and split on `\n`, same trick used for Freelance
/// Process's sub-steps, so this still fits `ContentListWorkspace`'s flat
/// 2-field mode instead of needing a bespoke form.
class ResumeHighlightsWorkspace extends ConsumerWidget {
  const ResumeHighlightsWorkspace({super.key, required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(
      portfolioProvider.select((s) => s.resumeHighlights),
    );
    final liveItems = groups
        .map(
          (g) => ContentItem(
            id: g.id,
            title: g.title,
            body: g.items.join('\n'),
            isVisible: g.isVisible,
          ),
        )
        .toList(growable: false);

    return ContentListWorkspace(
      module: AdminModule.resumeHighlights,
      isCompact: isCompact,
      eyebrow: 'RESUME HIGHLIGHTS',
      title: 'Skills & strengths snapshot',
      description:
          'Manage the highlight cards on the Resume page. One bullet per line — each line becomes a list item on the card.',
      itemLabel: 'Highlight group',
      fieldOneLabel: 'Card title',
      fieldOneHint: 'e.g. Core Skills',
      fieldTwoLabel: 'Bullets (one per line)',
      fieldTwoHint: 'Flutter and Dart development\nResponsive web and mobile UI\n…',
      defaultItems: liveItems,
      liveItems: liveItems,
      onSave: (item, index) {
        final group = ResumeHighlightGroup(
          id: item.id,
          title: item.title,
          items: item.body
              .split('\n')
              .map((line) => line.trim())
              .where((line) => line.isNotEmpty)
              .toList(),
          displayOrder: index + 1,
          isVisible: item.isVisible,
        );
        return ref
            .read(adminPortalProvider.notifier)
            .saveResumeHighlight(group);
      },
      onDelete: (id) =>
          ref.read(adminPortalProvider.notifier).deleteResumeHighlight(id),
    );
  }
}

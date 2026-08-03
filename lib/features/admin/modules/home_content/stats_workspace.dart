import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/content_list_workspace.dart';

/// Firestore-backed editor for the scrolling stats strips (top + bottom of
/// the homepage). Same reference pattern as [FaqWorkspace].
class StatsWorkspace extends ConsumerWidget {
  const StatsWorkspace({super.key, required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(portfolioProvider.select((s) => s.stats));
    final liveItems = stats
        .map(
          (s) => ContentItem(
            id: s.id,
            title: s.value,
            body: s.label,
            meta: s.placement,
            isVisible: s.isVisible,
          ),
        )
        .toList(growable: false);

    return ContentListWorkspace(
      module: AdminModule.homeStats,
      isCompact: isCompact,
      eyebrow: 'STATS MARQUEE',
      title: 'Scrolling trust numbers',
      description:
          'Value/label pairs shown in the marquee strips above and below the fold. Placement controls which strip(s) an item appears in.',
      itemLabel: 'Stat',
      fieldOneLabel: 'Value',
      fieldOneHint: 'e.g. 20+',
      fieldTwoLabel: 'Label',
      fieldTwoHint: 'e.g. Projects Completed',
      fieldThreeLabel: 'Placement (top / bottom / both)',
      fieldThreeHint: 'both',
      defaultItems: liveItems,
      liveItems: liveItems,
      onSave: (item, index) {
        final placement = switch (item.meta?.trim().toLowerCase()) {
          StatItemPlacement.top => StatItemPlacement.top,
          StatItemPlacement.bottom => StatItemPlacement.bottom,
          _ => StatItemPlacement.both,
        };
        final stat = StatItem(
          id: item.id,
          value: item.title,
          label: item.body,
          placement: placement,
          displayOrder: index + 1,
          isVisible: item.isVisible,
        );
        return ref.read(adminPortalProvider.notifier).saveStat(stat);
      },
      onDelete: (id) => ref.read(adminPortalProvider.notifier).deleteStat(id),
    );
  }
}

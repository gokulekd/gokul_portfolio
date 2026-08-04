import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/content_list_workspace.dart';

/// Firestore-backed editor for the "Proud Achievements" cards. The real
/// public card only shows a number + description — icon and card colors
/// rotate by list position instead of being admin-picked (decided Day 1,
/// confirmed Day 5: 3 colors + an icon key is too much picker UI for a flat
/// form, and the visual rhythm of the 3-card row matters more than per-item
/// customization). So this uses `ContentListWorkspace`'s 2-field mode with
/// labels that match the real shape, instead of the old generic registry
/// entry which had mismatched "Headline/Detail/Metric" labels.
class AchievementsWorkspace extends ConsumerWidget {
  const AchievementsWorkspace({super.key, required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(
      portfolioProvider.select((s) => s.achievements),
    );
    final liveItems = achievements
        .map(
          (a) => ContentItem(
            id: a.id,
            title: a.number,
            body: a.description,
            isVisible: a.isVisible,
          ),
        )
        .toList(growable: false);

    return ContentListWorkspace(
      module: AdminModule.achievements,
      isCompact: isCompact,
      eyebrow: 'ACHIEVEMENTS',
      title: 'Proud achievements',
      description:
          'Manage the metric cards shown in the "Proud Achievements" section. Icon and card '
          'color rotate automatically based on position — not editable per item.',
      itemLabel: 'Achievement',
      fieldOneLabel: 'Number',
      fieldOneHint: 'e.g. 95+',
      fieldTwoLabel: 'Description',
      fieldTwoHint: 'e.g. Percent customer satisfaction',
      defaultItems: liveItems,
      liveItems: liveItems,
      onSave: (item, index) {
        // `iconKey` is stored but intentionally unused by the public widget —
        // rendering rotates by position instead (see class doc). Kept as a
        // fixed placeholder so the field stays populated for a future pass.
        final achievement = AchievementItem(
          id: item.id,
          number: item.title,
          description: item.body,
          iconKey: 'trophy',
          displayOrder: index + 1,
          isVisible: item.isVisible,
        );
        return ref
            .read(adminPortalProvider.notifier)
            .saveAchievement(achievement);
      },
      onDelete: (id) =>
          ref.read(adminPortalProvider.notifier).deleteAchievement(id),
    );
  }
}

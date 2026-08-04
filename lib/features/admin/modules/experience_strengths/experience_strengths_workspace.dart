import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/content_list_workspace.dart';

/// Firestore-backed editor for the Experience page's "What I Bring" strength
/// cards. `ExperienceStrengthItem` has just title + description, so this is
/// the same flat 2-field `ContentListWorkspace` mode as FAQ.
class ExperienceStrengthsWorkspace extends ConsumerWidget {
  const ExperienceStrengthsWorkspace({super.key, required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strengths = ref.watch(
      portfolioProvider.select((s) => s.experienceStrengths),
    );
    final liveItems = strengths
        .map(
          (s) => ContentItem(
            id: s.id,
            title: s.title,
            body: s.description,
            isVisible: s.isVisible,
          ),
        )
        .toList(growable: false);

    return ContentListWorkspace(
      module: AdminModule.experienceStrengths,
      isCompact: isCompact,
      eyebrow: 'EXPERIENCE STRENGTHS',
      title: 'What I bring',
      description:
          'Manage the strength cards shown on the Experience page, beyond job titles.',
      itemLabel: 'Strength',
      fieldOneLabel: 'Title',
      fieldOneHint: 'e.g. Cross-Platform Thinking',
      fieldTwoLabel: 'Description',
      fieldTwoHint: 'What this strength means in practice…',
      defaultItems: liveItems,
      liveItems: liveItems,
      onSave: (item, index) {
        final strength = ExperienceStrengthItem(
          id: item.id,
          title: item.title,
          description: item.body,
          displayOrder: index + 1,
          isVisible: item.isVisible,
        );
        return ref
            .read(adminPortalProvider.notifier)
            .saveExperienceStrength(strength);
      },
      onDelete: (id) =>
          ref.read(adminPortalProvider.notifier).deleteExperienceStrength(id),
    );
  }
}

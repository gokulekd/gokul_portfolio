import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/content_list_workspace.dart';

/// Firestore-backed editor for the "Development Areas" scrolling marquee.
/// The real model only has a `label` — no description — so this is the
/// single-field mode of `ContentListWorkspace`.
class DevAreasWorkspace extends ConsumerWidget {
  const DevAreasWorkspace({super.key, required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devAreas = ref.watch(portfolioProvider.select((s) => s.devAreas));
    final liveItems = devAreas
        .map(
          (d) => ContentItem(id: d.id, title: d.label, body: '', isVisible: d.isVisible),
        )
        .toList(growable: false);

    return ContentListWorkspace(
      module: AdminModule.developmentAreas,
      isCompact: isCompact,
      eyebrow: 'DEVELOPMENT AREAS',
      title: 'Specialisations',
      description:
          'Keep the scrolling service and specialisation content aligned with current offerings.',
      itemLabel: 'Area',
      fieldOneLabel: 'Area title',
      fieldOneHint: 'e.g. Flutter Mobile Apps',
      defaultItems: liveItems,
      liveItems: liveItems,
      onSave: (item, index) {
        final area = DevAreaItem(
          id: item.id,
          label: item.title,
          displayOrder: index + 1,
          isVisible: item.isVisible,
        );
        return ref.read(adminPortalProvider.notifier).saveDevArea(area);
      },
      onDelete: (id) => ref.read(adminPortalProvider.notifier).deleteDevArea(id),
    );
  }
}

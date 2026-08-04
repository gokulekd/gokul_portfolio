import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/content_list_workspace.dart';

/// Firestore-backed editor for the About page's "Formal Education" panel.
/// `EducationItem`'s three fields (title/period/description) map cleanly onto
/// `ContentListWorkspace`'s flat fields — period doubles as the short meta
/// badge, same trick FAQ/DevAreas use for their own shapes.
class EducationWorkspace extends ConsumerWidget {
  const EducationWorkspace({super.key, required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final education = ref.watch(portfolioProvider.select((s) => s.education));
    final liveItems = education
        .map(
          (e) => ContentItem(
            id: e.id,
            title: e.title,
            body: e.description,
            meta: e.period,
            isVisible: e.isVisible,
          ),
        )
        .toList(growable: false);

    return ContentListWorkspace(
      module: AdminModule.education,
      isCompact: isCompact,
      eyebrow: 'EDUCATION',
      title: 'Formal education & self-learning',
      description:
          'Manage the education timeline shown on the About page — degrees, schooling, internships, and ongoing self-study.',
      itemLabel: 'Education entry',
      fieldOneLabel: 'Title',
      fieldOneHint: 'e.g. BSc Mathematics',
      fieldTwoLabel: 'Description',
      fieldTwoHint: 'e.g. Institution and what it built toward…',
      fieldThreeLabel: 'Period',
      fieldThreeHint: 'e.g. Jun 2013 – Jun 2016',
      defaultItems: liveItems,
      liveItems: liveItems,
      onSave: (item, index) {
        final entry = EducationItem(
          id: item.id,
          title: item.title,
          description: item.body,
          period: item.meta ?? '',
          displayOrder: index + 1,
          isVisible: item.isVisible,
        );
        return ref.read(adminPortalProvider.notifier).saveEducation(entry);
      },
      onDelete: (id) =>
          ref.read(adminPortalProvider.notifier).deleteEducation(id),
    );
  }
}

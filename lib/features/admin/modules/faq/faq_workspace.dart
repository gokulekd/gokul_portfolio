import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/content_list_workspace.dart';

/// Firestore-backed FAQ editor. This is the reference implementation for
/// wiring `ContentListWorkspace` to a real collection — question/answer map
/// cleanly onto the shared widget's two flat fields, so no bespoke form was
/// needed. Achievements/Testimonials/Freelance Process have richer shapes
/// and get dedicated forms on their own pass.
class FaqWorkspace extends ConsumerWidget {
  const FaqWorkspace({super.key, required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqItems = ref.watch(portfolioProvider.select((s) => s.faqItems));
    final liveItems = faqItems
        .map(
          (f) => ContentItem(
            id: f.id,
            title: f.question,
            body: f.answer,
            isVisible: f.isVisible,
          ),
        )
        .toList(growable: false);

    return ContentListWorkspace(
      module: AdminModule.faq,
      isCompact: isCompact,
      eyebrow: 'FAQ',
      title: 'Frequently asked questions',
      description:
          'Manage questions and answers shown on the portfolio contact section.',
      itemLabel: 'FAQ item',
      fieldOneLabel: 'Question',
      fieldOneHint: 'e.g. What is your tech stack?',
      fieldTwoLabel: 'Answer',
      fieldTwoHint: 'Clear, concise answer…',
      defaultItems: liveItems,
      liveItems: liveItems,
      onSave: (item, index) {
        final faqItem = FaqItem(
          id: item.id,
          number: (index + 1).toString().padLeft(2, '0'),
          question: item.title,
          answer: item.body,
          displayOrder: index + 1,
          isVisible: item.isVisible,
        );
        return ref.read(adminPortalProvider.notifier).saveFaqItem(faqItem);
      },
      onDelete: (id) =>
          ref.read(adminPortalProvider.notifier).deleteFaqItem(id),
    );
  }
}

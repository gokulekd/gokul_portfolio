import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../providers/admin_portal_provider.dart';
import '../../../shared/preview_tile.dart';
import '../../../widgets/admin_buttons.dart';
import '../../../widgets/admin_section_header.dart';
import '../../../widgets/admin_surface_card.dart';
import 'collection_row.dart';

class FallbackModuleWorkspace extends ConsumerWidget {
  const FallbackModuleWorkspace({
    super.key,
    required this.isCompact,
  });

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adminPortalProvider.notifier);

    final editorPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'COLLECTION EDITOR',
            title: notifier.pageTitle,
            description:
                'This pattern is intentionally reusable so all future Firebase-backed modules share the same editing rhythm.',
            action: AdminPrimaryButton(label: 'New entry', onPressed: () {}),
          ),
          const SizedBox(height: 18),
          ...notifier.activeCollections.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CollectionRow(item: item),
            ),
          ),
        ],
      ),
    );

    const previewPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'LIVE PREVIEW PANEL',
            title: 'Module context',
            description:
                'A dedicated side panel makes review faster when sections eventually sync to Firestore and the live portfolio.',
          ),
          SizedBox(height: 18),
          PreviewTile(
            title: 'Publishing state',
            value: 'Ready for structured data binding',
            icon: Icons.cloud_sync_rounded,
            color: Color(0xFF50FA7B),
          ),
          SizedBox(height: 12),
          PreviewTile(
            title: 'Primary data source',
            value: 'Firestore collection placeholder',
            icon: Icons.storage_rounded,
            color: Color(0xFF5CD6FF),
          ),
          SizedBox(height: 12),
          PreviewTile(
            title: 'Editor mode',
            value: 'Split collection + preview workflow',
            icon: Icons.splitscreen_rounded,
            color: Color(0xFFFFB44C),
          ),
        ],
      ),
    );

    if (isCompact) {
      return Column(
        children: [editorPanel, const SizedBox(height: 18), previewPanel],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: editorPanel),
        const SizedBox(width: 18),
        const Expanded(flex: 4, child: previewPanel),
      ],
    );
  }
}

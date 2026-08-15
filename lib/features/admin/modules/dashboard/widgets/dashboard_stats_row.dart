import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/admin_portal_provider.dart';
import '../../../widgets/admin_metric_card.dart';

/// The dashboard's top stat-card row — New Visitors / Resume Downloads /
/// Freelance Enquiries / Blog Viewers. Mirrors the classic admin-template
/// "Sales / Earnings / Visitors / Orders" layout: one row of four cards,
/// two per row on compact widths.
class DashboardStatsRow extends ConsumerWidget {
  const DashboardStatsRow({super.key, required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state so the row rebuilds when submissions/content change;
    // dashboardMetrics itself is a computed getter on the notifier.
    ref.watch(adminPortalProvider);
    final metrics = ref.read(adminPortalProvider.notifier).dashboardMetrics;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isCompact ? 2 : 4,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        mainAxisExtent: 200,
      ),
      itemBuilder: (context, index) => AdminMetricCard(item: metrics[index]),
    );
  }
}

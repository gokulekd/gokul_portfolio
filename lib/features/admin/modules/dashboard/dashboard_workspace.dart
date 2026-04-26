import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../controllers/admin_portal_controller.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/preview_tile.dart';

class DashboardWorkspace extends StatelessWidget {
  const DashboardWorkspace({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainActionGrid(controller: controller, isCompact: isCompact),
        const SizedBox(height: 18),
        const _DashboardOverviewHeader(),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.dashboardMetrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isCompact ? 1 : 4,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            mainAxisExtent: 138,
          ),
          itemBuilder:
              (context, index) =>
                  _CompactMetricCard(item: controller.dashboardMetrics[index]),
        ),
      ],
    );
  }
}

class _DashboardOverviewHeader extends StatelessWidget {
  const _DashboardOverviewHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Quick counts for published posts, live pages, featured projects, and new leads.',
          style: GoogleFonts.manrope(
            color: Colors.white60,
            fontSize: 13,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _CompactMetricCard extends StatelessWidget {
  const _CompactMetricCard({required this.item});

  final AdminMetricItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF15171A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, size: 20, color: item.color),
              ),
              const Spacer(),
              Text(
                item.value,
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.label,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.change,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              color: Colors.white38,
              fontSize: 11.5,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class CollectionRow extends StatelessWidget {
  const CollectionRow({super.key, required this.item});

  final AdminCollectionItem item;

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
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    AdminStateChip(state: item.state),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.subtitle,
                  style: GoogleFonts.manrope(
                    color: Colors.white60,
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (item.highlight != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.highlight!,
                    style: GoogleFonts.manrope(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                item.lastEdited,
                style: GoogleFonts.manrope(
                  color: Colors.white54,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MainActionGrid extends StatelessWidget {
  const MainActionGrid({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final tiles = <_ActionTile>[
      _ActionTile(
        icon: Icons.add_circle_rounded,
        label: 'Create a Post',
        description: 'Write & publish content to your portfolio feed',
        accentColor: AppColors.primaryGreen,
        onTap: () => controller.selectModule(AdminModule.createPost),
        showPlus: true,
      ),
      _ActionTile(
        icon: Icons.web_rounded,
        label: 'Manage Pages',
        description:
            'Open the page manager and control blog or post visibility on your website',
        accentColor: const Color(0xFF5CD6FF),
        onTap: () => controller.selectModule(AdminModule.managePages),
      ),
      _ActionTile(
        icon: Icons.description_rounded,
        label: 'Resume',
        description:
            'Upload and manage the resume that visitors can view on your website',
        accentColor: const Color(0xFFFFB44C),
        onTap: () => controller.selectModule(AdminModule.resumeManagement),
      ),
      _ActionTile(
        icon: Icons.inbox_rounded,
        label: 'Leads',
        description:
            'Open all visitor communications and requirement requests from your contact form',
        accentColor: const Color(0xFFFF7C7C),
        onTap: () => controller.selectModule(AdminModule.submissions),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Main Actions',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Use these four cards as the primary admin shortcuts.',
          style: GoogleFonts.manrope(
            color: Colors.white60,
            fontSize: 13,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tiles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isCompact ? 1 : 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            mainAxisExtent: isCompact ? 220 : 230,
          ),
          itemBuilder: (context, index) => tiles[index],
        ),
      ],
    );
  }
}

class _ActionTile extends StatefulWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.accentColor,
    required this.onTap,
    this.showPlus = false,
  });

  final IconData icon;
  final String label;
  final String description;
  final Color accentColor;
  final VoidCallback onTap;
  final bool showPlus;

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color:
                _hovered
                    ? widget.accentColor.withValues(alpha: 0.10)
                    : const Color(0xFF15171A),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color:
                  _hovered
                      ? widget.accentColor.withValues(alpha: 0.35)
                      : Colors.white.withValues(alpha: 0.06),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    _hovered
                        ? widget.accentColor.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.14),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.accentColor,
                      size: 26,
                    ),
                  ),
                  const Spacer(),
                  if (widget.showPlus)
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: widget.accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                widget.label,
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: GoogleFonts.manrope(
                  color: Colors.white60,
                  fontSize: 13,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Open',
                    style: GoogleFonts.manrope(
                      color: widget.accentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: widget.accentColor,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FallbackModuleWorkspace extends StatelessWidget {
  const FallbackModuleWorkspace({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final editorPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'COLLECTION EDITOR',
            title: controller.pageTitle,
            description:
                'This pattern is intentionally reusable so all future Firebase-backed modules share the same editing rhythm.',
            action: AdminPrimaryButton(label: 'New entry', onPressed: () {}),
          ),
          const SizedBox(height: 18),
          ...controller.activeCollections.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CollectionRow(item: item),
            ),
          ),
        ],
      ),
    );

    final previewPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
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
            color: AppColors.primaryGreen,
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
        Expanded(flex: 4, child: previewPanel),
      ],
    );
  }
}

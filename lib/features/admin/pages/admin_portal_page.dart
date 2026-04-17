import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../../../models/firebase_content_models.dart';
import '../../../models/portfolio_models.dart';
import '../../../utils/responsive_helper.dart';
import '../controllers/admin_portal_controller.dart';
import '../models/admin_portal_models.dart';
import '../widgets/admin_portal_components.dart';
import '../widgets/admin_portal_navigation.dart';

class AdminPortalPage extends StatelessWidget {
  AdminPortalPage({super.key});

  final AdminPortalController controller = Get.put(AdminPortalController());

  @override
  Widget build(BuildContext context) {
    final isCompact = ResponsiveHelper.isMobileOrTablet(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0E),
      drawer:
          isCompact
              ? Drawer(
                backgroundColor: const Color(0xFF101113),
                child: AdminPortalNavigation(
                  controller: controller,
                  isDrawer: true,
                ),
              )
              : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF090A0C), Color(0xFF111316)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isCompact) AdminPortalNavigation(controller: controller),
              Expanded(
                child: Obx(
                  () => CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          isCompact ? 18 : 28,
                          isCompact ? 18 : 24,
                          isCompact ? 18 : 28,
                          28,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate.fixed([
                            _PortalTopBar(
                              controller: controller,
                              isCompact: isCompact,
                            ),
                            const SizedBox(height: 24),
                            _HeroHeader(controller: controller),
                            const SizedBox(height: 24),
                            if (controller.selectedModule.value ==
                                AdminModule.dashboard) ...[
                              _DashboardBody(
                                controller: controller,
                                isCompact: isCompact,
                              ),
                            ] else if (controller.selectedModule.value ==
                                AdminModule.submissions) ...[
                              _SubmissionsWorkspace(isCompact: isCompact),
                            ] else if (controller.selectedModule.value ==
                                AdminModule.projects) ...[
                              _ProjectsWorkspace(
                                controller: controller,
                                isCompact: isCompact,
                              ),
                            ] else ...[
                              _ModuleWorkspace(
                                controller: controller,
                                isCompact: isCompact,
                              ),
                            ],
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PortalTopBar extends StatelessWidget {
  const _PortalTopBar({required this.controller, required this.isCompact});

  final AdminPortalController controller;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final actions = Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: isCompact ? double.infinity : 280,
          child: const AdminSearchField(),
        ),
        const _TopBarPill(
          icon: Icons.notifications_active_rounded,
          label: '3 new leads',
          isHighlighted: true,
        ),
        const _TopBarPill(icon: Icons.cloud_done_rounded, label: 'Sync ready'),
      ],
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Builder(
                builder:
                    (context) => IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(Icons.menu_rounded, color: Colors.white),
                    ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.activeModule.title,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          actions,
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            'Admin Workspace',
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        actions,
      ],
    );
  }
}

class _TopBarPill extends StatelessWidget {
  const _TopBarPill({
    required this.icon,
    required this.label,
    this.isHighlighted = false,
  });

  final IconData icon;
  final String label;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color:
            isHighlighted
                ? AppColors.primaryGreen.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              isHighlighted
                  ? AppColors.primaryGreen.withValues(alpha: 0.22)
                  : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isHighlighted ? AppColors.primaryGreen : Colors.white70,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.manrope(
              color: isHighlighted ? AppColors.primaryGreen : Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.controller});

  final AdminPortalController controller;

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      padding: const EdgeInsets.all(28),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              AppColors.primaryGreen.withValues(alpha: 0.12),
              const Color(0xFF57D4FF).withValues(alpha: 0.10),
              Colors.white.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        controller.activeModule.subtitle.toUpperCase(),
                        style: GoogleFonts.manrope(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      controller.pageTitle,
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        height: 1.05,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      controller.pageDescription,
                      style: GoogleFonts.manrope(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.65,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        AdminPrimaryButton(
                          label:
                              controller.selectedModule.value ==
                                      AdminModule.dashboard
                                  ? 'Open Site Structure'
                                  : 'Create New Entry',
                          icon:
                              controller.selectedModule.value ==
                                      AdminModule.dashboard
                                  ? Icons.view_agenda_rounded
                                  : Icons.add_rounded,
                          onPressed: () {
                            if (controller.selectedModule.value ==
                                AdminModule.dashboard) {
                              controller.selectModule(
                                AdminModule.siteStructure,
                              );
                            }
                          },
                        ),
                        AdminGhostButton(
                          label: 'Preview Live Site',
                          icon: Icons.open_in_new_rounded,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 270),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.24),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.circle,
                            size: 10,
                            color: AppColors.primaryGreen,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Live sync architecture',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Ready for Firebase wiring',
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'This shell is structured so visibility rules, content collections, and notifications can plug into real data without replacing the UI.',
                        style: GoogleFonts.manrope(
                          color: Colors.white60,
                          height: 1.6,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.controller, required this.isCompact});

  final AdminPortalController controller;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.dashboardMetrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isCompact ? 1 : 2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: isCompact ? 2.1 : 1.85,
          ),
          itemBuilder: (context, index) {
            return AdminMetricCard(item: controller.dashboardMetrics[index]);
          },
        ),
        const SizedBox(height: 18),
        if (isCompact)
          Column(
            children: [
              _StructurePanel(controller: controller),
              const SizedBox(height: 18),
              _CollectionsPanel(controller: controller),
              const SizedBox(height: 18),
              _ActivityPanel(controller: controller),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    _StructurePanel(controller: controller),
                    const SizedBox(height: 18),
                    _CollectionsPanel(controller: controller),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(flex: 4, child: _ActivityPanel(controller: controller)),
            ],
          ),
      ],
    );
  }
}

class _StructurePanel extends StatelessWidget {
  const _StructurePanel({required this.controller});

  final AdminPortalController controller;

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'SITE STRUCTURE',
            title: 'Homepage sections and visibility',
            description:
                'The public portfolio should become completely section-driven. This workspace previews that operating model.',
            action: AdminGhostButton(
              label: 'Reorder',
              icon: Icons.swap_vert_rounded,
              onPressed:
                  () => controller.selectModule(AdminModule.siteStructure),
            ),
          ),
          const SizedBox(height: 18),
          ...controller.sectionConfigs.map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SectionRow(
                section: section,
                onChanged:
                    (value) =>
                        controller.updateSectionVisibility(section, value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.section, required this.onChanged});

  final SiteSectionConfig section;
  final ValueChanged<bool> onChanged;

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
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              section.displayOrder.toString().padLeft(2, '0'),
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  section.description,
                  style: GoogleFonts.manrope(
                    color: Colors.white60,
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AdminStateChip(
                state:
                    section.isVisible
                        ? AdminItemState.live
                        : AdminItemState.hidden,
              ),
              const SizedBox(height: 10),
              Text(
                section.updatedAt == null
                    ? 'Synced document'
                    : 'Firestore linked',
                style: GoogleFonts.manrope(
                  color: Colors.white54,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Switch(
            value: section.isVisible,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }
}

class _CollectionsPanel extends StatelessWidget {
  const _CollectionsPanel({required this.controller});

  final AdminPortalController controller;

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'CONTENT MODULES',
            title: 'High-value collections',
            description:
                'A shared collection pattern keeps projects, testimonials, blog, and social data manageable from one consistent editing system.',
            action: AdminPrimaryButton(label: 'New content', onPressed: () {}),
          ),
          const SizedBox(height: 18),
          ...controller.fallbackCollections.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CollectionRow(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionRow extends StatelessWidget {
  const _CollectionRow({required this.item});

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

class _ActivityPanel extends StatelessWidget {
  const _ActivityPanel({required this.controller});

  final AdminPortalController controller;

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'OPERATIONS',
            title: 'Lead inbox priority',
            description:
                'Visitor requirements should feel like an inbox, not a raw database table.',
          ),
          const SizedBox(height: 18),
          ...controller.recentLeads.map(
            (lead) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _LeadCard(lead: lead),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeadCard extends StatelessWidget {
  const _LeadCard({required this.lead});

  final AdminLeadItem lead;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            lead.unread
                ? AppColors.primaryGreen.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color:
              lead.unread
                  ? AppColors.primaryGreen.withValues(alpha: 0.16)
                  : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  lead.name,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (lead.unread)
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            lead.company,
            style: GoogleFonts.manrope(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            lead.summary,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  lead.status,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                lead.receivedAt,
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

class _ProjectsWorkspace extends StatelessWidget {
  const _ProjectsWorkspace({required this.controller, required this.isCompact});

  final AdminPortalController controller;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final listPanel = AdminSurfaceCard(
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionHeader(
              eyebrow: 'PROJECT COLLECTION',
              title: 'Featured projects from Firestore',
              description:
                  'This module now reads and writes the real `projects` collection. Featured and published state control what the public portfolio shows.',
              action: AdminPrimaryButton(
                label: 'Add project',
                onPressed:
                    () => _showProjectEditorDialog(
                      context,
                      controller: controller,
                    ),
              ),
            ),
            const SizedBox(height: 18),
            ...controller.projects.map(
              (project) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ProjectEditorRow(
                  project: project,
                  onEdit:
                      () => _showProjectEditorDialog(
                        context,
                        controller: controller,
                        project: project,
                      ),
                  onDelete: () async {
                    await controller.deleteProject(project);
                    Get.snackbar(
                      'Project removed',
                      '${project.title} was deleted from Firestore.',
                      backgroundColor: const Color(
                        0xFFFF7C7C,
                      ).withValues(alpha: 0.16),
                      colorText: Colors.white,
                    );
                  },
                  onFeatureToggle:
                      (value) =>
                          controller.toggleProjectFeatured(project, value),
                  onPublishToggle:
                      (value) =>
                          controller.toggleProjectPublished(project, value),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final sidePanel = AdminSurfaceCard(
      child: Obx(() {
        final featuredCount =
            controller.projects.where((project) => project.isFeatured).length;
        final publishedCount =
            controller.projects.where((project) => project.isPublished).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminSectionHeader(
              eyebrow: 'PROJECT STATUS',
              title: 'Public portfolio output',
              description:
                  'These counts reflect the same project collection now used by the public site.',
            ),
            const SizedBox(height: 18),
            _PreviewTile(
              title: 'Featured on homepage',
              value: '$featuredCount project(s)',
              icon: Icons.folder_special_rounded,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 12),
            _PreviewTile(
              title: 'Published to projects page',
              value: '$publishedCount project(s)',
              icon: Icons.public_rounded,
              color: const Color(0xFF5CD6FF),
            ),
            const SizedBox(height: 12),
            const _PreviewTile(
              title: 'Collection mode',
              value: 'Live Firestore CRUD enabled',
              icon: Icons.cloud_done_rounded,
              color: Color(0xFFFFB44C),
            ),
          ],
        );
      }),
    );

    if (isCompact) {
      return Column(
        children: [listPanel, const SizedBox(height: 18), sidePanel],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: listPanel),
        const SizedBox(width: 18),
        Expanded(flex: 4, child: sidePanel),
      ],
    );
  }
}

class _ProjectEditorRow extends StatelessWidget {
  const _ProjectEditorRow({
    required this.project,
    required this.onEdit,
    required this.onDelete,
    required this.onFeatureToggle,
    required this.onPublishToggle,
  });

  final Project project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onFeatureToggle;
  final ValueChanged<bool> onPublishToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Text(
                          project.title,
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        AdminStateChip(
                          state:
                              project.isPublished
                                  ? AdminItemState.live
                                  : AdminItemState.draft,
                        ),
                        if (project.isFeatured)
                          const AdminStateChip(
                            state: AdminItemState.live,
                            label: 'Featured',
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.description,
                      style: GoogleFonts.manrope(
                        color: Colors.white60,
                        fontSize: 12.5,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded, color: Colors.white70),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ProjectMetaPill(
                label: project.category,
                icon: Icons.category_rounded,
              ),
              _ProjectMetaPill(
                label: 'Order ${project.displayOrder}',
                icon: Icons.swap_vert_rounded,
              ),
              _ProjectMetaPill(
                label: '${project.technologies.length} stack item(s)',
                icon: Icons.code_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Featured',
                style: GoogleFonts.manrope(color: Colors.white70),
              ),
              const SizedBox(width: 8),
              Switch(
                value: project.isFeatured,
                onChanged: onFeatureToggle,
                activeThumbColor: AppColors.primaryGreen,
              ),
              const SizedBox(width: 18),
              Text(
                'Published',
                style: GoogleFonts.manrope(color: Colors.white70),
              ),
              const SizedBox(width: 8),
              Switch(
                value: project.isPublished,
                onChanged: onPublishToggle,
                activeThumbColor: AppColors.primaryGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectMetaPill extends StatelessWidget {
  const _ProjectMetaPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showProjectEditorDialog(
  BuildContext context, {
  required AdminPortalController controller,
  Project? project,
}) async {
  final titleController = TextEditingController(text: project?.title ?? '');
  final descriptionController = TextEditingController(
    text: project?.description ?? '',
  );
  final imageUrlController = TextEditingController(
    text: project?.imageUrl ?? '',
  );
  final githubController = TextEditingController(
    text: project?.githubUrl ?? '',
  );
  final liveUrlController = TextEditingController(text: project?.liveUrl ?? '');
  final technologiesController = TextEditingController(
    text: project?.technologies.join(', ') ?? '',
  );
  final categoryController = TextEditingController(
    text: project?.category ?? 'Mobile App',
  );
  final orderController = TextEditingController(
    text:
        (project?.displayOrder ?? (controller.projects.length + 1)).toString(),
  );

  var isFeatured = project?.isFeatured ?? false;
  var isPublished = project?.isPublished ?? true;

  await showDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: const Color(0xFF14171A),
            insetPadding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        project == null ? 'Add Project' : 'Edit Project',
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This writes directly to the Firestore `projects` collection.',
                        style: GoogleFonts.manrope(
                          color: Colors.white60,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _ProjectFormField(
                        label: 'Title',
                        controller: titleController,
                      ),
                      const SizedBox(height: 14),
                      _ProjectFormField(
                        label: 'Description',
                        controller: descriptionController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 14),
                      _ProjectFormField(
                        label: 'Image URL',
                        controller: imageUrlController,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _ProjectFormField(
                              label: 'GitHub URL',
                              controller: githubController,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _ProjectFormField(
                              label: 'Live URL',
                              controller: liveUrlController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _ProjectFormField(
                              label: 'Category',
                              controller: categoryController,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _ProjectFormField(
                              label: 'Display Order',
                              controller: orderController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _ProjectFormField(
                        label: 'Technologies (comma separated)',
                        controller: technologiesController,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Text(
                            'Featured',
                            style: GoogleFonts.manrope(color: Colors.white70),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: isFeatured,
                            onChanged: (value) {
                              setState(() => isFeatured = value);
                            },
                            activeThumbColor: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 18),
                          Text(
                            'Published',
                            style: GoogleFonts.manrope(color: Colors.white70),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: isPublished,
                            onChanged: (value) {
                              setState(() => isPublished = value);
                            },
                            activeThumbColor: AppColors.primaryGreen,
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: AdminGhostButton(
                              label: 'Cancel',
                              icon: Icons.close_rounded,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: AdminPrimaryButton(
                              label: project == null ? 'Create' : 'Save',
                              icon: Icons.check_rounded,
                              onPressed: () async {
                                if (titleController.text.trim().isEmpty ||
                                    descriptionController.text.trim().isEmpty) {
                                  Get.snackbar(
                                    'Missing fields',
                                    'Title and description are required.',
                                    backgroundColor: const Color(
                                      0xFFFFB44C,
                                    ).withValues(alpha: 0.16),
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                final savedProject = Project(
                                  id: project?.id ?? '',
                                  title: titleController.text.trim(),
                                  description:
                                      descriptionController.text.trim(),
                                  imageUrl: imageUrlController.text.trim(),
                                  technologies: technologiesController.text
                                      .split(',')
                                      .map((item) => item.trim())
                                      .where((item) => item.isNotEmpty)
                                      .toList(growable: false),
                                  githubUrl:
                                      githubController.text.trim().isEmpty
                                          ? null
                                          : githubController.text.trim(),
                                  liveUrl:
                                      liveUrlController.text.trim().isEmpty
                                          ? null
                                          : liveUrlController.text.trim(),
                                  category:
                                      categoryController.text.trim().isEmpty
                                          ? 'Mobile App'
                                          : categoryController.text.trim(),
                                  isFeatured: isFeatured,
                                  isPublished: isPublished,
                                  displayOrder:
                                      int.tryParse(
                                        orderController.text.trim(),
                                      ) ??
                                      (project?.displayOrder ??
                                          controller.projects.length + 1),
                                  stars: project?.stars ?? 0,
                                  forks: project?.forks ?? 0,
                                );

                                await controller.saveProject(savedProject);
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }

                                Get.snackbar(
                                  project == null
                                      ? 'Project created'
                                      : 'Project updated',
                                  '${savedProject.title} was saved to Firestore.',
                                  backgroundColor: AppColors.primaryGreen
                                      .withValues(alpha: 0.16),
                                  colorText: Colors.white,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class _ProjectFormField extends StatelessWidget {
  const _ProjectFormField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            color: Colors.white70,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.manrope(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.04),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            hintStyle: GoogleFonts.manrope(color: Colors.white38),
          ),
        ),
      ],
    );
  }
}

class _ModuleWorkspace extends StatelessWidget {
  const _ModuleWorkspace({required this.controller, required this.isCompact});

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
              child: _CollectionRow(item: item),
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
          _PreviewTile(
            title: 'Publishing state',
            value: 'Ready for structured data binding',
            icon: Icons.cloud_sync_rounded,
            color: AppColors.primaryGreen,
          ),
          SizedBox(height: 12),
          _PreviewTile(
            title: 'Primary data source',
            value: 'Firestore collection placeholder',
            icon: Icons.storage_rounded,
            color: Color(0xFF5CD6FF),
          ),
          SizedBox(height: 12),
          _PreviewTile(
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

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    color: Colors.white54,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmissionsWorkspace extends StatelessWidget {
  const _SubmissionsWorkspace({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final inbox = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AdminSectionHeader(
            eyebrow: 'SUBMISSION INBOX',
            title: 'Incoming visitor requirements',
            description:
                'This screen is designed as an inbox-first experience so the admin can read, prioritise, and respond quickly.',
          ),
          SizedBox(height: 18),
          _LeadCard(
            lead: AdminLeadItem(
              name: 'Aarav Studios',
              company: 'aarav.design',
              summary:
                  'Need a Flutter product site and admin dashboard in 3 weeks.',
              status: 'Unread',
              receivedAt: '6 min ago',
              unread: true,
            ),
          ),
          SizedBox(height: 12),
          _LeadCard(
            lead: AdminLeadItem(
              name: 'Mira Health',
              company: 'mirahealth.io',
              summary:
                  'Asked for mobile app redesign, Firebase workflow, and support.',
              status: 'Reviewing',
              receivedAt: '48 min ago',
            ),
          ),
          SizedBox(height: 12),
          _LeadCard(
            lead: AdminLeadItem(
              name: 'Northbound Labs',
              company: 'northboundlabs.com',
              summary:
                  'Requested portfolio-style case study site with blog migration.',
              status: 'Replied',
              receivedAt: '2 hrs ago',
            ),
          ),
        ],
      ),
    );

    final detail = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'DETAIL VIEW',
            title: 'Selected requirement',
            description:
                'The right pane is reserved for notes, status changes, and full requirement details once Firestore is connected.',
          ),
          const SizedBox(height: 18),
          const _PreviewTile(
            title: 'Contact',
            value: 'aarav@aarav.design',
            icon: Icons.mail_rounded,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 12),
          const _PreviewTile(
            title: 'Budget intent',
            value: 'Premium build with dashboard scope',
            icon: Icons.payments_rounded,
            color: Color(0xFFFFB44C),
          ),
          const SizedBox(height: 12),
          const _PreviewTile(
            title: 'Timeline',
            value: '3 weeks, kickoff expected immediately',
            icon: Icons.schedule_rounded,
            color: Color(0xFF5CD6FF),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AdminPrimaryButton(
                label: 'Mark in progress',
                icon: Icons.done_all_rounded,
                onPressed: () {},
              ),
              AdminGhostButton(
                label: 'Add note',
                icon: Icons.sticky_note_2_rounded,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );

    if (isCompact) {
      return Column(children: [inbox, const SizedBox(height: 18), detail]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: inbox),
        const SizedBox(width: 18),
        Expanded(flex: 5, child: detail),
      ],
    );
  }
}

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
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
                            ] else if (controller.selectedModule.value ==
                                AdminModule.createPost) ...[
                              _CreatePostWorkspace(isCompact: isCompact),
                            ] else if (controller.selectedModule.value ==
                                AdminModule.managePages) ...[
                              _ManagePagesWorkspace(isCompact: isCompact),
                            ] else if (controller.selectedModule.value ==
                                AdminModule.resumeManagement) ...[
                              _ResumeManagementWorkspace(isCompact: isCompact),
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
        _MainActionGrid(controller: controller, isCompact: isCompact),
        const SizedBox(height: 18),
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

// ─────────────────────────────────────────────────────────────────────────────
// MAIN ACTION GRID
// ─────────────────────────────────────────────────────────────────────────────

class _MainActionGrid extends StatelessWidget {
  const _MainActionGrid({
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final tiles = [
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
        description: 'View and control all pages across your portfolio',
        accentColor: const Color(0xFF5CD6FF),
        onTap: () => controller.selectModule(AdminModule.managePages),
      ),
      _ActionTile(
        icon: Icons.description_rounded,
        label: 'Resume',
        description: 'Upload, replace, and manage your resume versions',
        accentColor: const Color(0xFFFFB44C),
        onTap: () => controller.selectModule(AdminModule.resumeManagement),
      ),
    ];

    if (isCompact) {
      return Column(
        children: tiles
            .map((tile) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: tile,
                ))
            .toList(),
      );
    }

    return Row(
      children: tiles
          .expand(
            (tile) => [Expanded(child: tile), const SizedBox(width: 14)],
          )
          .toList()
        ..removeLast(),
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
            color: _hovered
                ? widget.accentColor.withValues(alpha: 0.10)
                : const Color(0xFF15171A),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: _hovered
                  ? widget.accentColor.withValues(alpha: 0.35)
                  : Colors.white.withValues(alpha: 0.06),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
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
                    child: Icon(widget.icon, color: widget.accentColor, size: 26),
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

// ─────────────────────────────────────────────────────────────────────────────
// CREATE POST WORKSPACE
// ─────────────────────────────────────────────────────────────────────────────

class _CreatePostWorkspace extends StatefulWidget {
  const _CreatePostWorkspace({required this.isCompact});

  final bool isCompact;

  @override
  State<_CreatePostWorkspace> createState() => _CreatePostWorkspaceState();
}

class _CreatePostWorkspaceState extends State<_CreatePostWorkspace> {
  final _textController = TextEditingController();
  final _hashtagController = TextEditingController();
  String _visibility = 'Public';
  final List<String> _hashtags = [];
  final List<Uint8List> _selectedImages = [];
  bool _isPosting = false;

  static const int _maxChars = 3000;

  final _visibilityOptions = ['Public', 'Portfolio Only', 'Draft'];

  @override
  void dispose() {
    _textController.dispose();
    _hashtagController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );
    if (result != null) {
      setState(() {
        for (final file in result.files) {
          if (file.bytes != null && _selectedImages.length < 4) {
            _selectedImages.add(file.bytes!);
          }
        }
      });
    }
  }

  void _addHashtag() {
    final tag = _hashtagController.text.trim().replaceAll('#', '');
    if (tag.isNotEmpty && !_hashtags.contains(tag) && _hashtags.length < 10) {
      setState(() {
        _hashtags.add(tag);
        _hashtagController.clear();
      });
    }
  }

  Future<void> _submitPost() async {
    if (_textController.text.trim().isEmpty && _selectedImages.isEmpty) return;
    setState(() => _isPosting = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isPosting = false;
      _textController.clear();
      _selectedImages.clear();
      _hashtags.clear();
      _visibility = 'Public';
    });
    Get.snackbar(
      'Post published',
      'Your post is now live.',
      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.16),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool get _canPost =>
      (_textController.text.trim().isNotEmpty || _selectedImages.isNotEmpty) &&
      !_isPosting;

  @override
  Widget build(BuildContext context) {
    final editor = AdminSurfaceCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primaryGreen, Color(0xFF57D4FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'GK',
                  style: GoogleFonts.manrope(
                    color: Colors.black,
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
                      'Gokul K S',
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _visibility,
                          isDense: true,
                          dropdownColor: const Color(0xFF1C1F23),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white70,
                            size: 16,
                          ),
                          style: GoogleFonts.manrope(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          items: _visibilityOptions
                              .map(
                                (opt) => DropdownMenuItem(
                                  value: opt,
                                  child: Text(opt),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _visibility = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Text area
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _textController,
            builder: (context, value, _) {
              final remaining = _maxChars - value.text.length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: 7,
                    maxLength: _maxChars,
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.65,
                    ),
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: GoogleFonts.manrope(
                        color: Colors.white38,
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.03),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$remaining characters remaining',
                    style: GoogleFonts.manrope(
                      color: remaining < 100 ? const Color(0xFFFFB44C) : Colors.white38,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              );
            },
          ),
          // Image previews
          if (_selectedImages.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.memory(
                            _selectedImages[index],
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => setState(
                              () => _selectedImages.removeAt(index),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 16),
          // Action bar
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _PostActionButton(
                  icon: Icons.image_rounded,
                  label: 'Photo',
                  color: AppColors.primaryGreen,
                  onTap: _pickImages,
                  badge: _selectedImages.isNotEmpty
                      ? '${_selectedImages.length}'
                      : null,
                ),
                _PostActionButton(
                  icon: Icons.videocam_rounded,
                  label: 'Video',
                  color: const Color(0xFF5CD6FF),
                  onTap: () {},
                ),
                _PostActionButton(
                  icon: Icons.attach_file_rounded,
                  label: 'Document',
                  color: const Color(0xFFFFB44C),
                  onTap: () async {
                    await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'doc', 'docx'],
                    );
                  },
                ),
                _PostActionButton(
                  icon: Icons.tag_rounded,
                  label: 'Hashtag',
                  color: const Color(0xFFFF7C7C),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => _HashtagDialog(
                        controller: _hashtagController,
                        onAdd: _addHashtag,
                      ),
                    );
                  },
                ),
                _PostActionButton(
                  icon: Icons.emoji_emotions_rounded,
                  label: 'Emoji',
                  color: const Color(0xFFFFD700),
                  onTap: () {},
                ),
                _PostActionButton(
                  icon: Icons.alternate_email_rounded,
                  label: 'Mention',
                  color: const Color(0xFFB57AFF),
                  onTap: () {},
                ),
              ],
            ),
          ),
          // Hashtag chips
          if (_hashtags.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _hashtags
                  .map(
                    (tag) => Chip(
                      label: Text(
                        '#$tag',
                        style: GoogleFonts.manrope(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor:
                          AppColors.primaryGreen.withValues(alpha: 0.12),
                      deleteIconColor: AppColors.primaryGreen.withValues(alpha: 0.6),
                      side: BorderSide(
                        color: AppColors.primaryGreen.withValues(alpha: 0.22),
                      ),
                      onDeleted: () =>
                          setState(() => _hashtags.remove(tag)),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 24),
          // Bottom buttons
          Row(
            children: [
              Expanded(
                child: AdminGhostButton(
                  label: 'Save Draft',
                  icon: Icons.save_rounded,
                  onPressed: () {
                    Get.snackbar(
                      'Draft saved',
                      'Your draft has been saved.',
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _isPosting
                    ? Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      )
                    : AdminPrimaryButton(
                        label: 'Post',
                        icon: Icons.send_rounded,
                        onPressed: _canPost ? _submitPost : null,
                      ),
              ),
            ],
          ),
        ],
      ),
    );

    final previewPanel = AdminSurfaceCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'POST PREVIEW',
            title: 'How it will look',
            description:
                'A live preview of your post card as it appears on the portfolio feed.',
          ),
          const SizedBox(height: 18),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _textController,
            builder: (context, value, _) {
              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.primaryGreen, Color(0xFF57D4FF)],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'GK',
                            style: GoogleFonts.manrope(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gokul K S',
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _visibility,
                              style: GoogleFonts.manrope(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      value.text.isEmpty
                          ? 'Your post text will appear here...'
                          : value.text,
                      style: GoogleFonts.manrope(
                        color:
                            value.text.isEmpty ? Colors.white38 : Colors.white,
                        fontSize: 13,
                        height: 1.6,
                      ),
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (_selectedImages.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _selectedImages.first,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (_selectedImages.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '+${_selectedImages.length - 1} more image(s)',
                            style: GoogleFonts.manrope(
                              color: Colors.white54,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                    ],
                    if (_hashtags.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        children: _hashtags
                            .map(
                              (tag) => Text(
                                '#$tag',
                                style: GoogleFonts.manrope(
                                  color: AppColors.primaryGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    if (widget.isCompact) {
      return Column(children: [editor, const SizedBox(height: 18), previewPanel]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: editor),
        const SizedBox(width: 18),
        Expanded(flex: 5, child: previewPanel),
      ],
    );
  }
}

class _PostActionButton extends StatelessWidget {
  const _PostActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 17),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge!,
                  style: GoogleFonts.manrope(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HashtagDialog extends StatelessWidget {
  const _HashtagDialog({required this.controller, required this.onAdd});

  final TextEditingController controller;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF14171A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Hashtag',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: GoogleFonts.manrope(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'e.g. flutter',
                hintStyle: GoogleFonts.manrope(color: Colors.white38),
                prefixText: '# ',
                prefixStyle: GoogleFonts.manrope(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w700,
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) {
                onAdd();
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AdminGhostButton(
                    label: 'Cancel',
                    icon: Icons.close_rounded,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AdminPrimaryButton(
                    label: 'Add',
                    icon: Icons.add_rounded,
                    onPressed: () {
                      onAdd();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MANAGE PAGES WORKSPACE
// ─────────────────────────────────────────────────────────────────────────────

class _ManagePagesWorkspace extends StatelessWidget {
  const _ManagePagesWorkspace({required this.isCompact});

  final bool isCompact;

  static const _pages = [
    _PageEntry(
      icon: Icons.home_rounded,
      name: 'Home Page',
      route: '/',
      description: 'Hero section, intro, and CTA',
      isLive: true,
      color: AppColors.primaryGreen,
    ),
    _PageEntry(
      icon: Icons.person_rounded,
      name: 'About / Skills',
      route: '/#about',
      description: 'Skills, experience timeline, and stack',
      isLive: true,
      color: Color(0xFF5CD6FF),
    ),
    _PageEntry(
      icon: Icons.workspaces_rounded,
      name: 'Projects',
      route: '/#projects',
      description: 'Featured work and portfolio items',
      isLive: true,
      color: Color(0xFFFFB44C),
    ),
    _PageEntry(
      icon: Icons.workspace_premium_rounded,
      name: 'Achievements',
      route: '/#achievements',
      description: 'Milestones, metrics, and proof points',
      isLive: true,
      color: Color(0xFFFF7C7C),
    ),
    _PageEntry(
      icon: Icons.auto_awesome_rounded,
      name: 'Guiding Principles',
      route: '/#principles',
      description: 'Values and creative operating philosophy',
      isLive: true,
      color: Color(0xFFB57AFF),
    ),
    _PageEntry(
      icon: Icons.route_rounded,
      name: 'Freelance Process',
      route: '/#process',
      description: 'Client journey and collaboration flow',
      isLive: true,
      color: Color(0xFF57D4FF),
    ),
    _PageEntry(
      icon: Icons.record_voice_over_rounded,
      name: 'Testimonials',
      route: '/#testimonials',
      description: 'Client feedback and social proof',
      isLive: false,
      color: Color(0xFFFFD700),
    ),
    _PageEntry(
      icon: Icons.quiz_rounded,
      name: 'FAQ',
      route: '/#faq',
      description: 'Frequently asked questions',
      isLive: false,
      color: Color(0xFF5CD6FF),
    ),
    _PageEntry(
      icon: Icons.mail_rounded,
      name: 'Contact Us',
      route: '/#contact',
      description: 'Contact form and social links',
      isLive: true,
      color: AppColors.primaryGreen,
    ),
    _PageEntry(
      icon: Icons.edit_note_rounded,
      name: 'Blog',
      route: '/blog',
      description: 'Editorial posts and articles',
      isLive: false,
      color: Color(0xFFFFB44C),
    ),
    _PageEntry(
      icon: Icons.admin_panel_settings_rounded,
      name: 'Admin Portal',
      route: '/admin',
      description: 'Backend management workspace',
      isLive: true,
      color: Color(0xFFFF7C7C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final liveCount = _pages.where((p) => p.isLive).length;

    final pageList = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'PORTFOLIO PAGES',
            title: 'All pages across your site',
            description:
                '$liveCount of ${_pages.length} pages are currently live. Toggle visibility or edit content directly from here.',
          ),
          const SizedBox(height: 18),
          ..._pages.map(
            (page) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PageRow(page: page),
            ),
          ),
        ],
      ),
    );

    final statsPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'PAGE STATS',
            title: 'Site overview',
            description: 'Summary of all pages and their current publish status.',
          ),
          const SizedBox(height: 18),
          _PreviewTile(
            title: 'Total pages',
            value: '${_pages.length} pages configured',
            icon: Icons.web_rounded,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 12),
          _PreviewTile(
            title: 'Live pages',
            value: '$liveCount pages published',
            icon: Icons.visibility_rounded,
            color: const Color(0xFF5CD6FF),
          ),
          const SizedBox(height: 12),
          _PreviewTile(
            title: 'Draft pages',
            value: '${_pages.length - liveCount} hidden from public',
            icon: Icons.visibility_off_rounded,
            color: const Color(0xFFFF7C7C),
          ),
        ],
      ),
    );

    if (isCompact) {
      return Column(
        children: [pageList, const SizedBox(height: 18), statsPanel],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: pageList),
        const SizedBox(width: 18),
        Expanded(flex: 4, child: statsPanel),
      ],
    );
  }
}

class _PageEntry {
  const _PageEntry({
    required this.icon,
    required this.name,
    required this.route,
    required this.description,
    required this.isLive,
    required this.color,
  });

  final IconData icon;
  final String name;
  final String route;
  final String description;
  final bool isLive;
  final Color color;
}

class _PageRow extends StatefulWidget {
  const _PageRow({required this.page});

  final _PageEntry page;

  @override
  State<_PageRow> createState() => _PageRowState();
}

class _PageRowState extends State<_PageRow> {
  late bool _isLive;

  @override
  void initState() {
    super.initState();
    _isLive = widget.page.isLive;
  }

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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: widget.page.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(widget.page.icon, color: widget.page.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.page.name,
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        widget.page.route,
                        style: GoogleFonts.manrope(
                          color: Colors.white54,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.page.description,
                  style: GoogleFonts.manrope(
                    color: Colors.white60,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminStateChip(
                state: _isLive ? AdminItemState.live : AdminItemState.hidden,
              ),
              const SizedBox(width: 8),
              Switch(
                value: _isLive,
                onChanged: (val) => setState(() => _isLive = val),
                activeThumbColor: AppColors.primaryGreen,
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.open_in_new_rounded,
                  color: Colors.white54,
                  size: 18,
                ),
                tooltip: 'Preview',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RESUME MANAGEMENT WORKSPACE
// ─────────────────────────────────────────────────────────────────────────────

class _ResumeManagementWorkspace extends StatefulWidget {
  const _ResumeManagementWorkspace({required this.isCompact});

  final bool isCompact;

  @override
  State<_ResumeManagementWorkspace> createState() =>
      _ResumeManagementWorkspaceState();
}

class _ResumeManagementWorkspaceState
    extends State<_ResumeManagementWorkspace> {
  bool _isDragTarget = false;
  String? _uploadedFileName;
  String? _uploadedFileSize;
  String? _uploadedDate;
  bool _isUploading = false;

  final _versions = <_ResumeVersion>[
    _ResumeVersion(
      name: 'gokul_resume_v2.pdf',
      date: 'Mar 2025',
      size: '1.8 MB',
      isCurrent: false,
    ),
    _ResumeVersion(
      name: 'gokul_resume_v1.pdf',
      date: 'Jan 2025',
      size: '1.5 MB',
      isCurrent: false,
    ),
  ];

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: false,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() => _isUploading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isUploading = false;
        if (_uploadedFileName != null) {
          _versions.insert(
            0,
            _ResumeVersion(
              name: _uploadedFileName!,
              date: 'Previous',
              size: _uploadedFileSize ?? '--',
              isCurrent: false,
            ),
          );
        }
        _uploadedFileName = file.name;
        _uploadedFileSize = file.size != 0
            ? '${(file.size / 1024 / 1024).toStringAsFixed(1)} MB'
            : 'Unknown size';
        _uploadedDate = 'Just now';
      });
      Get.snackbar(
        'Resume uploaded',
        '${file.name} is now your active resume.',
        backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.16),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'RESUME MANAGEMENT',
            title: 'Upload & manage your CV',
            description:
                'Keep your resume up to date. The latest version will be linked across your portfolio.',
            action: _uploadedFileName != null
                ? AdminGhostButton(
                    label: 'Replace',
                    icon: Icons.swap_horiz_rounded,
                    onPressed: _pickResume,
                  )
                : null,
          ),
          const SizedBox(height: 20),
          if (_uploadedFileName != null) ...[
            _ActiveResumeCard(
              fileName: _uploadedFileName!,
              fileSize: _uploadedFileSize ?? '--',
              uploadedDate: _uploadedDate ?? '--',
              onReplace: _pickResume,
              onDelete: () {
                setState(() {
                  _uploadedFileName = null;
                  _uploadedFileSize = null;
                  _uploadedDate = null;
                });
              },
            ),
            const SizedBox(height: 20),
          ],
          // Drop zone
          DragTarget<Object>(
            onWillAcceptWithDetails: (_) {
              setState(() => _isDragTarget = true);
              return true;
            },
            onLeave: (_) => setState(() => _isDragTarget = false),
            onAcceptWithDetails: (_) {
              setState(() => _isDragTarget = false);
              _pickResume();
            },
            builder: (context, candidates, rejected) {
              return GestureDetector(
                onTap: _pickResume,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: _isDragTarget
                        ? AppColors.primaryGreen.withValues(alpha: 0.10)
                        : Colors.white.withValues(alpha: 0.02),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: _isDragTarget
                          ? AppColors.primaryGreen.withValues(alpha: 0.45)
                          : Colors.white.withValues(alpha: 0.08),
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  child: _isUploading
                      ? Column(
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryGreen,
                              ),
                              strokeWidth: 2.5,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Uploading...',
                              style: GoogleFonts.manrope(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withValues(
                                  alpha: 0.12,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.upload_rounded,
                                color: AppColors.primaryGreen,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Click to upload or drag & drop',
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Supported formats: PDF, DOC, DOCX · Max 10 MB',
                              style: GoogleFonts.manrope(
                                color: Colors.white54,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );

    final historyPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'VERSION HISTORY',
            title: 'Previous resume versions',
            description:
                'Older versions are kept for reference. You can restore any previous version.',
          ),
          const SizedBox(height: 18),
          if (_versions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No previous versions yet.',
                  style: GoogleFonts.manrope(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            ..._versions.map(
              (v) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _VersionRow(version: v),
              ),
            ),
        ],
      ),
    );

    if (widget.isCompact) {
      return Column(
        children: [uploadPanel, const SizedBox(height: 18), historyPanel],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: uploadPanel),
        const SizedBox(width: 18),
        Expanded(flex: 5, child: historyPanel),
      ],
    );
  }
}

class _ActiveResumeCard extends StatelessWidget {
  const _ActiveResumeCard({
    required this.fileName,
    required this.fileSize,
    required this.uploadedDate,
    required this.onReplace,
    required this.onDelete,
  });

  final String fileName;
  final String fileSize;
  final String uploadedDate;
  final VoidCallback onReplace;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            fileName,
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'ACTIVE',
                            style: GoogleFonts.manrope(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$fileSize · Uploaded $uploadedDate',
                      style: GoogleFonts.manrope(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AdminPrimaryButton(
                label: 'Download',
                icon: Icons.download_rounded,
                onPressed: () {},
              ),
              AdminGhostButton(
                label: 'Replace',
                icon: Icons.swap_horiz_rounded,
                onPressed: onReplace,
              ),
              AdminGhostButton(
                label: 'Delete',
                icon: Icons.delete_outline_rounded,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResumeVersion {
  _ResumeVersion({
    required this.name,
    required this.date,
    required this.size,
    required this.isCurrent,
  });

  final String name;
  final String date;
  final String size;
  final bool isCurrent;
}

class _VersionRow extends StatelessWidget {
  const _VersionRow({required this.version});

  final _ResumeVersion version;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          const Icon(Icons.history_rounded, color: Colors.white38, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  version.name,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${version.date} · ${version.size}',
                  style: GoogleFonts.manrope(
                    color: Colors.white54,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              foregroundColor: AppColors.primaryGreen,
            ),
            child: Text(
              'Restore',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

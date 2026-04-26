import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../controllers/admin_auth_controller.dart';
import '../controllers/admin_portal_controller.dart';
import '../models/admin_portal_models.dart';

class AdminPortalNavigation extends StatelessWidget {
  const AdminPortalNavigation({
    super.key,
    required this.controller,
    this.isDrawer = false,
  });

  final AdminPortalController controller;
  final bool isDrawer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: isDrawer ? null : 296,
      decoration: BoxDecoration(
        color: const Color(0xFF101113),
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            children: [
              _BrandBlock(theme: theme),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.navigationGroups.indexed
                          .expand((entry) {
                            final (index, group) = entry;
                            final items = controller.modulesForGroup(group);

                            return [
                              _GroupLabel(title: group.label),
                              ...items.map(
                                (item) => _NavItem(
                                  item: item,
                                  selected:
                                      controller.selectedModule.value ==
                                      item.module,
                                  onTap: () {
                                    controller.selectModule(item.module);
                                    if (isDrawer) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ),
                              if (index !=
                                  controller.navigationGroups.length - 1)
                                const SizedBox(height: 16),
                            ];
                          })
                          .toList(growable: false),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const _ProfileBlock(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandBlock extends StatelessWidget {
  const _BrandBlock({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: const Color(0xFF17191C),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'ADMIN PORTAL',
              style: GoogleFonts.manrope(
                color: AppColors.primaryGreen,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Portfolio Control Center',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Backstage workspace for content, visibility, publishing, and incoming leads.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
      child: Text(
        title,
        style: GoogleFonts.manrope(
          color: Colors.white38,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AdminModuleItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color:
                selected
                    ? const Color(0xFF1B2220)
                    : Colors.white.withValues(alpha: 0.02),
            border: Border.all(
              color:
                  selected
                      ? AppColors.primaryGreen.withValues(alpha: 0.30)
                      : Colors.white.withValues(alpha: 0.04),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color:
                      selected
                          ? AppColors.primaryGreen.withValues(alpha: 0.18)
                          : Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  color: selected ? AppColors.primaryGreen : Colors.white70,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: GoogleFonts.manrope(
                        color: Colors.white54,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.badgeCount != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color:
                        selected
                            ? AppColors.primaryGreen
                            : const Color(0xFF23282D),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.badgeCount.toString(),
                    style: GoogleFonts.manrope(
                      color: selected ? Colors.black : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
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

class _ProfileBlock extends StatelessWidget {
  const _ProfileBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF17191C),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
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
                const SizedBox(height: 3),
                Text(
                  'Owner access active',
                  style: GoogleFonts.manrope(
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Get.find<AdminAuthController>().signOut(),
            icon: const Icon(Icons.logout_rounded, color: Colors.white54),
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }
}

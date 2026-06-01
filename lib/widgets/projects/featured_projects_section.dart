import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/portfolio_controller.dart';
import '../../features/admin/modules/projects/models/app_project.dart';
import '../../routes/app_routes.dart';
import '../../utils/responsive_helper.dart';

class FeaturedProjectsSection extends StatelessWidget {
  const FeaturedProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical:
            isMobile
                ? 40
                : isTablet
                ? 60
                : 80,
        horizontal:
            isMobile
                ? 16
                : isTablet
                ? 24
                : 40,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Responsive layout: Column on mobile, Row on desktop
          isMobile
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Selected Work",
                    style: GoogleFonts.manrope(
                      fontSize: isMobile ? 28 : 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.changePage(5);
                        Get.offNamed(AppRoutes.contact);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : 24,
                          vertical: isMobile ? 14 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Become a client",
                        style: GoogleFonts.manrope(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "Selected Work",
                      style: GoogleFonts.manrope(
                        fontSize: isTablet ? 40 : 48,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.changePage(5);
                      Get.offNamed(AppRoutes.contact);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 20 : 24,
                        vertical: isTablet ? 14 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Become a client",
                      style: GoogleFonts.manrope(
                        fontSize: isTablet ? 14 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
          SizedBox(
            height:
                isMobile
                    ? 32
                    : isTablet
                    ? 48
                    : 60,
          ),

          // Featured AppProjects from Supabase
          Obx(() {
            final featured = controller.featuredAppProjects;
            if (featured.isEmpty) {
              return const SizedBox.shrink();
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: featured.length,
              separatorBuilder: (_, __) => const SizedBox(height: 32),
              itemBuilder: (context, index) =>
                  AppProjectCard(project: featured[index]),
            );
          }),

          SizedBox(height: isMobile ? 24 : 40),

          Center(
            child: OutlinedButton(
              onPressed: () {
                controller.changePage(3);
                Get.offNamed(AppRoutes.projects);
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 32,
                  vertical: isMobile ? 14 : 16,
                ),
                side: const BorderSide(color: Colors.black87),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "View All Projects",
                style: GoogleFonts.manrope(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AppProject Card for public portfolio ──────────────────────────────────

class AppProjectCard extends StatelessWidget {
  const AppProjectCard({super.key, required this.project});
  final AppProject project;

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          if (project.appBannerUrl.isNotEmpty)
            Image.network(
              project.appBannerUrl,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey.shade900,
              ),
            )
          else
            Container(
              height: 200,
              color: Colors.grey.shade900,
            ),

          // Icon + Name + description
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App icon
                    if (project.appIconUrl.isNotEmpty)
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          project.appIconUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox(),
                        ),
                      ),
                    if (project.appIconUrl.isNotEmpty) const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        project.appName,
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                if (project.appDescription.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    project.appDescription,
                    style: GoogleFonts.manrope(
                      color: Colors.white60,
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                // Store / link buttons
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (project.playStoreUrl != null &&
                        project.playStoreUrl!.isNotEmpty)
                      _StoreButton(
                        label: 'Play Store',
                        icon: Icons.shop_rounded,
                        color: const Color(0xFF34A853),
                        onTap: () => _launch(project.playStoreUrl!),
                      ),
                    if (project.appStoreUrl != null &&
                        project.appStoreUrl!.isNotEmpty)
                      _StoreButton(
                        label: 'App Store',
                        icon: Icons.apple_rounded,
                        color: Colors.white,
                        onTap: () => _launch(project.appStoreUrl!),
                      ),
                    if (project.appWebsiteUrl.isNotEmpty)
                      _StoreButton(
                        label: 'Website',
                        icon: Icons.language_rounded,
                        color: Colors.white70,
                        onTap: () => _launch(project.appWebsiteUrl),
                      ),
                    if (project.githubUrl != null &&
                        project.githubUrl!.isNotEmpty)
                      _StoreButton(
                        label: 'GitHub',
                        icon: Icons.code_rounded,
                        color: Colors.white70,
                        onTap: () => _launch(project.githubUrl!),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreButton extends StatelessWidget {
  const _StoreButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.manrope(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

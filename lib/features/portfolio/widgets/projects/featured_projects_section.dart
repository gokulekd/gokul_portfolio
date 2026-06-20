import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'featured_projects_components.dart';

export 'featured_projects_components.dart' show AppProjectCard;

class FeaturedProjectsSection extends ConsumerWidget {
  const FeaturedProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : isTablet ? 60 : 80,
        horizontal: isMobile ? 16 : isTablet ? 24 : 40,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SectionHeader(isMobile: isMobile, isTablet: isTablet),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ClientButton(isMobile: isMobile, isTablet: isTablet),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: SectionHeader(isMobile: isMobile, isTablet: isTablet)),
                    const SizedBox(width: 16),
                    ClientButton(isMobile: isMobile, isTablet: isTablet),
                  ],
                ),

          SizedBox(height: isMobile ? 32 : isTablet ? 48 : 60),

          Builder(builder: (context) {
            final featured = state.featuredAppProjects;
            if (featured.isEmpty) return const SizedBox.shrink();
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: featured.length,
              separatorBuilder: (_, __) => const SizedBox(height: 28),
              itemBuilder: (context, index) => AppProjectCard(
                project: featured[index],
                index: index,
              ),
            );
          }),

          SizedBox(height: isMobile ? 24 : 40),

          Center(
            child: OutlinedButton(
              onPressed: () {
                ref.read(portfolioProvider.notifier).changePage(3);
                context.go(AppRoutes.projects);
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

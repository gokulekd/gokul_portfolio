import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/firebase_content_models.dart';
import '../../../../providers/portfolio_provider.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';

void _navigateToPage(Map<String, dynamic> item) {
  final index = item['index'] as int;
  final route = AppRoutes.indexToRoute[index];
  if (route != null) {
    appRouter.go(route);
  }
}

void _handleHomeNav() {
  appRouter.go(AppRoutes.home);
}

void _handleResumeNav() {
  appRouter.go(AppRoutes.resume);
}

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);

    final menuItems = [
      {'title': 'Home', 'index': 0, 'icon': Icons.home, 'pageKey': SitePageKeys.home},
      {'title': 'About me', 'index': 1, 'icon': Icons.person, 'pageKey': SitePageKeys.about},
      {'title': 'My Work', 'index': 3, 'icon': Icons.folder, 'pageKey': SitePageKeys.myWork},
      {'title': 'Resume', 'action': 'resume', 'icon': Icons.description, 'pageKey': SitePageKeys.resume},
      {'title': 'Blog', 'index': 4, 'icon': Icons.article, 'pageKey': SitePageKeys.blog},
      {'title': 'Contact me', 'index': 5, 'icon': Icons.contact_mail},
    ];

    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                ref.read(portfolioProvider.notifier).changePage(0);
                context.go(AppRoutes.home);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage(
                      'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
                    ),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Fallback
                    },
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: Text(
                      state.personalInfo.name,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      state.personalInfo.title,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: Builder(builder: (context) {
              final visible = menuItems.where((item) {
                final key = item['pageKey'] as String?;
                return key == null || state.isPageVisible(key);
              }).toList();
              return ListView(
                padding: EdgeInsets.zero,
                children: visible.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'] as IconData),
                    title: Text(
                      item['title'] as String,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (item['action'] == 'resume') {
                        _handleResumeNav();
                      } else if (item['title'] == 'Home') {
                        _handleHomeNav();
                      } else {
                        _navigateToPage(item);
                      }
                    },
                  );
                }).toList(),
              );
            }),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Text(
              '© 2025 Portfolio',
              style: GoogleFonts.manrope(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

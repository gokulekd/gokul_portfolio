import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/firebase_content_models.dart';
import '../../../../providers/portfolio_provider.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/utils/responsive_helper.dart';

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

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);
    final isMobileOrTablet = ResponsiveHelper.isMobileOrTablet(context);

    final menuItems = [
      {'title': 'Home', 'index': 0, 'pageKey': SitePageKeys.home},
      {'title': 'About me', 'index': 1, 'pageKey': SitePageKeys.about},
      {'title': 'My Work', 'index': 3, 'pageKey': SitePageKeys.myWork},
      {'title': 'Resume', 'action': 'resume', 'pageKey': SitePageKeys.resume},
      {'title': 'Blog', 'index': 4, 'pageKey': SitePageKeys.blog},
      {'title': 'Contact me', 'index': 5},
    ];

    return AppBar(
      elevation: 1,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,

      toolbarHeight: 80.0,

      leading:
          isMobileOrTablet
              ? Builder(
                builder:
                    (context) => Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
              )
              : null,
      title: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: InkWell(
            onTap: () {
              ref.read(portfolioProvider.notifier).changePage(0);
              context.go(AppRoutes.home);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: const AssetImage(
                          'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
                        ),
                        onBackgroundImageError: (exception, stackTrace) {
                          // Fallback
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.personalInfo.name,
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      actions:
          isMobileOrTablet
              ? [
                // Theme toggle on mobile
                _buildThemeToggle(ref),
                const SizedBox(width: 8),
              ]
              : [
                _buildThemeToggle(ref),
                const SizedBox(width: 8),
Builder(builder: (context) {
                  final visible = menuItems.where((item) {
                    final key = item['pageKey'] as String?;
                    return key == null || state.isPageVisible(key);
                  }).toList();
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...visible.map((item) {
                        final isContactMe = item['title'] == 'Contact me';
                        final isHome = item['title'] == 'Home';
                        return Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isContactMe ? 8 : 4,
                            ),
                            child:
                                isContactMe
                                    ? ElevatedButton(
                                      onPressed: () {
                                        _navigateToPage(item);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black87,
                                        foregroundColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.black
                                                : Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Text(
                                        item['title'] as String,
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Colors.black
                                                  : Colors.white,
                                        ),
                                      ),
                                    )
                                    : TextButton(
                                      onPressed: () {
                                        if (isHome) {
                                          _handleHomeNav();
                                        } else if (item['action'] ==
                                            'resume') {
                                          _handleResumeNav();
                                        } else {
                                          _navigateToPage(item);
                                        }
                                      },
                                      child: Text(
                                        item['title'] as String,
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                          ),
                        );
                      }),
                      const SizedBox(width: 16),
                    ],
                  );
                }),
              ],
    );
  }

  Widget _buildThemeToggle(WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider.notifier);
    final isDark = themeNotifier.isDarkMode;
    return Tooltip(
      message: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      child: IconButton(
        onPressed: () => themeNotifier.toggleTheme(),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey(isDark),
            color: isDark ? Colors.amber : Colors.black54,
            size: 22,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../models/firebase_content_models.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/routes/app_routes.dart';
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

  /// Theme icon with an on/off switch beside it; tapping either toggles
  /// between light and dark mode.
  Widget _buildThemeToggle(WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final themeNotifier = ref.read(themeProvider.notifier);

    return Tooltip(
      message: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      child: Semantics(
        button: true,
        toggled: isDark,
        label: 'Dark mode',
        child: InkWell(
          onTap: themeNotifier.toggleTheme,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    key: ValueKey(isDark),
                    color: isDark ? Colors.amber : Colors.black54,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 8),
                _ThemeSwitch(isOn: isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

/// Compact switch drawn in the theme toggle: a grey track in light mode, a
/// green track in dark mode, with the white knob sliding across.
class _ThemeSwitch extends StatelessWidget {
  const _ThemeSwitch({required this.isOn});

  final bool isOn;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: 40,
      height: 22,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isOn ? AppColors.primaryGreen : Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

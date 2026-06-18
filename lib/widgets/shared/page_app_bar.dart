import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/portfolio_provider.dart';
import '../../routes/app_routes.dart';

class PageAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const PageAppBar({super.key, required this.title, this.onBackPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        title,
        style: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed:
            onBackPressed ??
            () {
              try {
                ref.read(portfolioProvider.notifier).changePage(0);
                context.go(AppRoutes.home);
              } catch (_) {
                context.pop();
              }
            },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/config/app_colors.dart';
import '../../../../../core/providers/admin_portal_provider.dart';
import '../../../models/admin_portal_models.dart';
import 'action_tile.dart';

class MainActionGrid extends ConsumerWidget {
  const MainActionGrid({
    super.key,
    required this.isCompact,
  });

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adminPortalProvider.notifier);

    final tiles = <AdminActionTile>[
      AdminActionTile(
        icon: Icons.add_circle_rounded,
        label: 'Create a Post',
        description: 'Write & publish content to your portfolio feed',
        accentColor: AppColors.primaryGreen,
        onTap: () => notifier.selectModule(AdminModule.createPost),
        showPlus: true,
      ),
      AdminActionTile(
        icon: Icons.web_rounded,
        label: 'Manage Pages',
        description:
            'Open the page manager and control blog or post visibility on your website',
        accentColor: const Color(0xFF5CD6FF),
        onTap: () => notifier.selectModule(AdminModule.managePages),
      ),
      AdminActionTile(
        icon: Icons.description_rounded,
        label: 'Resume',
        description:
            'Upload and manage the resume that visitors can view on your website',
        accentColor: const Color(0xFFFFB44C),
        onTap: () => notifier.selectModule(AdminModule.resumeManagement),
      ),
      AdminActionTile(
        icon: Icons.inbox_rounded,
        label: 'Leads',
        description:
            'Open all visitor communications and requirement requests from your contact form',
        accentColor: const Color(0xFFFF7C7C),
        onTap: () => notifier.selectModule(AdminModule.submissions),
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

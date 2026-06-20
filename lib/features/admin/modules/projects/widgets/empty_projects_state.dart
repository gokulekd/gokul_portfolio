import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyProjectsState extends StatelessWidget {
  const EmptyProjectsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.apps_rounded,
              size: 40,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 14),
            Text(
              'No projects yet',
              style: GoogleFonts.manrope(
                color: Colors.white60,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add your first app project to show it on the portfolio.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

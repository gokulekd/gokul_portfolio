import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/app_colors.dart';

/// Save button with loading and success states.
class AdminSaveButton extends StatelessWidget {
  const AdminSaveButton({
    super.key,
    required this.isSaving,
    required this.saved,
    required this.onPressed,
    this.label = 'Save changes',
    this.savedLabel = 'Saved',
  });

  final bool isSaving;
  final bool saved;
  final VoidCallback onPressed;
  final String label;
  final String savedLabel;

  @override
  Widget build(BuildContext context) {
    if (saved) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primaryGreen.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_rounded, color: AppColors.primaryGreen, size: 18),
            const SizedBox(width: 8),
            Text(
              savedLabel,
              style: GoogleFonts.manrope(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
    }

    return FilledButton.icon(
      onPressed: isSaving ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.black,
        disabledBackgroundColor: AppColors.primaryGreen.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      icon: isSaving
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black54,
              ),
            )
          : const Icon(Icons.save_rounded, size: 18),
      label: Text(
        isSaving ? 'Saving…' : label,
        style: GoogleFonts.manrope(fontWeight: FontWeight.w800),
      ),
    );
  }
}

/// Footer row with a hint and save button.
class AdminSaveFooter extends StatelessWidget {
  const AdminSaveFooter({
    super.key,
    required this.isSaving,
    required this.saved,
    required this.onPressed,
    this.hint = 'Changes are saved to Firestore and take effect everywhere immediately.',
  });

  final bool isSaving;
  final bool saved;
  final VoidCallback onPressed;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.info_outline_rounded, color: Colors.white38, size: 14),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            hint,
            style: GoogleFonts.manrope(color: Colors.white38, fontSize: 11.5),
          ),
        ),
        const SizedBox(width: 16),
        AdminSaveButton(isSaving: isSaving, saved: saved, onPressed: onPressed),
      ],
    );
  }
}

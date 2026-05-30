import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminSearchField extends StatelessWidget {
  const AdminSearchField({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: GoogleFonts.manrope(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.04),
        prefixIcon: const Icon(Icons.search_rounded, color: Colors.white54),
        hintText: 'Search modules, items, or labels',
        hintStyle: GoogleFonts.manrope(color: Colors.white38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

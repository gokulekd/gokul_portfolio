import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/config/app_colors.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.manrope(
            color: Colors.white30,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Divider(
            color: Colors.white.withValues(alpha: 0.07),
            height: 1,
          ),
        ),
      ],
    );
  }
}

class AppProjectFormField extends StatelessWidget {
  const AppProjectFormField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.hint,
    this.prefixIcon,
    this.prefixColor = Colors.white38,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? hint;
  final IconData? prefixIcon;
  final Color prefixColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            color: enabled ? Colors.white54 : Colors.white24,
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          enabled: enabled,
          style: GoogleFonts.manrope(
            color: enabled ? Colors.white : Colors.white24,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.02),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.primaryGreen.withValues(alpha: 0.5),
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
            hintText: hint,
            hintStyle: GoogleFonts.manrope(
              color: enabled ? Colors.white24 : Colors.white12,
              fontSize: 13,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    size: 16,
                    color: enabled ? prefixColor : Colors.white12,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class TechStackInput extends StatelessWidget {
  const TechStackInput({
    super.key,
    required this.tags,
    required this.inputController,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> tags;
  final TextEditingController inputController;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  void _submit() {
    final tag = inputController.text.trim();
    if (tag.isEmpty || tags.contains(tag)) return;
    onAdd(tag);
    inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: inputController,
                style: GoogleFonts.manrope(color: Colors.white, fontSize: 14),
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.primaryGreen.withValues(alpha: 0.5),
                    ),
                  ),
                  hintText: 'e.g. Flutter, Firebase, Riverpod…',
                  hintStyle:
                      GoogleFonts.manrope(color: Colors.white24, fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _submit,
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.primaryGreen.withValues(alpha: 0.35)),
                ),
                child: Icon(Icons.add_rounded,
                    color: AppColors.primaryGreen, size: 20),
              ),
            ),
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color:
                              AppColors.primaryGreen.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tag,
                          style: GoogleFonts.manrope(
                            color: AppColors.primaryGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => onRemove(tag),
                          child: Icon(
                            Icons.close_rounded,
                            size: 12,
                            color:
                                AppColors.primaryGreen.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

class ProjectTypeToggle extends StatelessWidget {
  const ProjectTypeToggle({
    super.key,
    required this.isPersonal,
    required this.onChanged,
  });

  final bool isPersonal;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TypeChip(
            label: 'Personal',
            icon: Icons.person_rounded,
            selected: isPersonal,
            onTap: () => onChanged(true),
          ),
          TypeChip(
            label: 'Company',
            icon: Icons.business_rounded,
            selected: !isPersonal,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class TypeChip extends StatelessWidget {
  const TypeChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryGreen.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.primaryGreen.withValues(alpha: 0.45)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: selected ? AppColors.primaryGreen : Colors.white38,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                color: selected ? AppColors.primaryGreen : Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

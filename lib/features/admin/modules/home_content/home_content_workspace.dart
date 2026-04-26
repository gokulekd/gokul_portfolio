import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/dialog_widgets.dart';
import '../../shared/preview_tile.dart';

class HomeContentWorkspace extends StatefulWidget {
  const HomeContentWorkspace({super.key, required this.isCompact});
  final bool isCompact;

  @override
  State<HomeContentWorkspace> createState() => _HomeContentWorkspaceState();
}

class _HomeContentWorkspaceState extends State<HomeContentWorkspace> {
  final _nameCtrl = TextEditingController(text: 'Gokul K S');
  final _titleCtrl = TextEditingController(
    text: 'Mobile App Designer & Flutter Developer',
  );
  final _taglineCtrl = TextEditingController(
    text: 'turning your ideas into pixel-perfect realities',
  );
  final _bioCtrl = TextEditingController(
    text:
        "I'm dedicated to crafting apps that bring your ideas to life, combining design and development to deliver fast, impactful results.",
  );
  final _ctaPrimaryCtrl = TextEditingController(text: 'View my work');
  final _ctaSecondaryCtrl = TextEditingController(text: 'Get in touch');
  bool _isAvailable = true;
  bool _saved = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _taglineCtrl.dispose();
    _bioCtrl.dispose();
    _ctaPrimaryCtrl.dispose();
    _ctaSecondaryCtrl.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => _saved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final editor = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'HOME CONTENT',
            title: 'Hero & headline copy',
            description:
                'Edit the name, title, tagline, and bio shown in the hero section. Changes will sync to the live portfolio.',
            action: AdminPrimaryButton(
              label: _saved ? 'Saved!' : 'Save changes',
              icon: _saved ? Icons.check_rounded : Icons.save_rounded,
              onPressed: _save,
            ),
          ),
          const SizedBox(height: 24),
          SectionLabel(label: 'IDENTITY'),
          const SizedBox(height: 12),
          LimitedField(
            controller: _nameCtrl,
            label: 'Display name',
            hint: 'e.g. Gokul K S',
            maxLength: 40,
          ),
          const SizedBox(height: 14),
          LimitedField(
            controller: _titleCtrl,
            label: 'Professional title',
            hint: 'e.g. Flutter Developer & UI Designer',
            maxLength: 70,
          ),
          const SizedBox(height: 22),
          SectionLabel(label: 'HERO COPY'),
          const SizedBox(height: 12),
          LimitedField(
            controller: _taglineCtrl,
            label: 'Animated tagline',
            hint: 'The typewriter text shown below your title',
            maxLength: 100,
          ),
          const SizedBox(height: 14),
          LimitedField(
            controller: _bioCtrl,
            label: 'Bio paragraph',
            hint: 'Short bio shown in the hero section',
            maxLength: 220,
            maxLines: 4,
          ),
          const SizedBox(height: 22),
          SectionLabel(label: 'CALL TO ACTION'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LimitedField(
                  controller: _ctaPrimaryCtrl,
                  label: 'Primary CTA',
                  hint: 'e.g. View my work',
                  maxLength: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: LimitedField(
                  controller: _ctaSecondaryCtrl,
                  label: 'Secondary CTA',
                  hint: 'e.g. Get in touch',
                  maxLength: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SectionLabel(label: 'AVAILABILITY'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color:
                        _isAvailable ? AppColors.primaryGreen : Colors.white38,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isAvailable
                        ? 'Available for new projects'
                        : 'Not currently available',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                Switch(
                  value: _isAvailable,
                  onChanged: (v) => setState(() => _isAvailable = v),
                  activeThumbColor: AppColors.primaryGreen,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final preview = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'LIVE PREVIEW',
            title: 'Hero snapshot',
            description:
                'Reflects your current field values. Save to push to the live site.',
          ),
          const SizedBox(height: 18),
          ValueListenableBuilder(
            valueListenable: _nameCtrl,
            builder:
                (_, __, ___) => ValueListenableBuilder(
                  valueListenable: _titleCtrl,
                  builder:
                      (_, __, ___) => ValueListenableBuilder(
                        valueListenable: _taglineCtrl,
                        builder:
                            (_, __, ___) => ValueListenableBuilder(
                              valueListenable: _bioCtrl,
                              builder:
                                  (_, __, ___) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      PreviewTile(
                                        title: 'Name',
                                        value:
                                            _nameCtrl.text.isEmpty
                                                ? '—'
                                                : _nameCtrl.text,
                                        icon: Icons.person_rounded,
                                        color: AppColors.primaryGreen,
                                      ),
                                      const SizedBox(height: 10),
                                      PreviewTile(
                                        title: 'Title',
                                        value:
                                            _titleCtrl.text.isEmpty
                                                ? '—'
                                                : _titleCtrl.text,
                                        icon: Icons.work_rounded,
                                        color: const Color(0xFF5CD6FF),
                                      ),
                                      const SizedBox(height: 10),
                                      PreviewTile(
                                        title: 'Tagline',
                                        value:
                                            _taglineCtrl.text.isEmpty
                                                ? '—'
                                                : _taglineCtrl.text,
                                        icon: Icons.format_quote_rounded,
                                        color: const Color(0xFFFFB44C),
                                      ),
                                      const SizedBox(height: 10),
                                      PreviewTile(
                                        title: 'Availability',
                                        value:
                                            _isAvailable
                                                ? 'Open for projects'
                                                : 'Not available',
                                        icon: Icons.circle,
                                        color:
                                            _isAvailable
                                                ? AppColors.primaryGreen
                                                : Colors.white38,
                                      ),
                                    ],
                                  ),
                            ),
                      ),
                ),
          ),
        ],
      ),
    );

    if (widget.isCompact) {
      return Column(children: [editor, const SizedBox(height: 18), preview]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: editor),
        const SizedBox(width: 18),
        Expanded(flex: 5, child: preview),
      ],
    );
  }
}

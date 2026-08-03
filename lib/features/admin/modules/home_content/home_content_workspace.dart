import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/dialog_widgets.dart';
import '../../shared/preview_tile.dart';

class HomeContentWorkspace extends ConsumerStatefulWidget {
  const HomeContentWorkspace({super.key, required this.isCompact});
  final bool isCompact;

  @override
  ConsumerState<HomeContentWorkspace> createState() =>
      _HomeContentWorkspaceState();
}

class _HomeContentWorkspaceState extends ConsumerState<HomeContentWorkspace> {
  late final TextEditingController _taglineCtrl;
  late final TextEditingController _ctaPrimaryCtrl;
  late bool _isAvailable;

  bool _isSaving = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(portfolioProvider);
    _taglineCtrl = TextEditingController(text: state.heroTagline);
    _ctaPrimaryCtrl = TextEditingController(text: state.ctaPrimaryLabel);
    _isAvailable = state.isAvailableForWork;
  }

  @override
  void dispose() {
    _taglineCtrl.dispose();
    _ctaPrimaryCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final content = HomeHeroContent(
      tagline: _taglineCtrl.text.trim(),
      ctaPrimaryLabel: _ctaPrimaryCtrl.text.trim(),
      isAvailableForWork: _isAvailable,
    );
    await ref.read(adminPortalProvider.notifier).saveHomeHero(content);
    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _saved = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _saved = false);
  }

  @override
  Widget build(BuildContext context) {
    final editor = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'HOME CONTENT',
            title: 'Hero copy',
            description:
                'Name, title, and bio live in Basic Details (they\'re shared across every page). This is just the hero-specific copy: the '
                'animated tagline, the call-to-action button, and availability status.',
            action: AdminPrimaryButton(
              label:
                  _isSaving
                      ? 'Saving…'
                      : _saved
                      ? 'Saved!'
                      : 'Save changes',
              icon: _saved ? Icons.check_rounded : Icons.save_rounded,
              onPressed: _isSaving ? null : _save,
            ),
          ),
          const SizedBox(height: 22),
          SectionLabel(label: 'HERO COPY'),
          const SizedBox(height: 12),
          LimitedField(
            controller: _taglineCtrl,
            label: 'Animated tagline',
            hint: 'The large heading shown below your title',
            maxLength: 100,
          ),
          const SizedBox(height: 22),
          SectionLabel(label: 'CALL TO ACTION'),
          const SizedBox(height: 12),
          LimitedField(
            controller: _ctaPrimaryCtrl,
            label: 'CTA button label',
            hint: 'e.g. See what I can do',
            maxLength: 30,
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
            valueListenable: _taglineCtrl,
            builder:
                (_, __, ___) => ValueListenableBuilder(
                  valueListenable: _ctaPrimaryCtrl,
                  builder:
                      (_, __, ___) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            title: 'CTA button',
                            value:
                                _ctaPrimaryCtrl.text.isEmpty
                                    ? '—'
                                    : _ctaPrimaryCtrl.text,
                            icon: Icons.smart_button_rounded,
                            color: const Color(0xFF5CD6FF),
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

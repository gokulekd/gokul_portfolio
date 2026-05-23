import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../../../models/firebase_content_models.dart';
import '../../controllers/admin_portal_controller.dart';
import '../../shared/admin_portal_components.dart';

class BasicDetailsWorkspace extends StatefulWidget {
  const BasicDetailsWorkspace({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  @override
  State<BasicDetailsWorkspace> createState() => _BasicDetailsWorkspaceState();
}

class _BasicDetailsWorkspaceState extends State<BasicDetailsWorkspace> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _designationCtrl;
  late final TextEditingController _linkedinCtrl;
  late final TextEditingController _twitterCtrl;
  late final TextEditingController _githubCtrl;
  late final TextEditingController _mediumCtrl;
  late final TextEditingController _instagramCtrl;
  late final TextEditingController _emailCtrl;

  bool _isSaving = false;
  bool _saved = false;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    final d = widget.controller.basicDetails;
    _nameCtrl = TextEditingController(text: d.name);
    _designationCtrl = TextEditingController(text: d.designation);
    _linkedinCtrl = TextEditingController(text: d.linkedinUrl);
    _twitterCtrl = TextEditingController(text: d.twitterUrl);
    _githubCtrl = TextEditingController(text: d.githubUrl);
    _mediumCtrl = TextEditingController(text: d.mediumUrl);
    _instagramCtrl = TextEditingController(text: d.instagramUrl);
    _emailCtrl = TextEditingController(text: d.email);

    // Re-populate fields when live data first arrives from Firestore
    ever(widget.controller.liveBasicDetails, (details) {
      if (details == null) return;
      if (!_isSaving) _populate(details);
    });
  }

  void _populate(BasicDetails d) {
    _nameCtrl.text = d.name;
    _designationCtrl.text = d.designation;
    _linkedinCtrl.text = d.linkedinUrl;
    _twitterCtrl.text = d.twitterUrl;
    _githubCtrl.text = d.githubUrl;
    _mediumCtrl.text = d.mediumUrl;
    _instagramCtrl.text = d.instagramUrl;
    _emailCtrl.text = d.email;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _designationCtrl.dispose();
    _linkedinCtrl.dispose();
    _twitterCtrl.dispose();
    _githubCtrl.dispose();
    _mediumCtrl.dispose();
    _instagramCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final designation = _designationCtrl.text.trim();
    if (name.isEmpty || designation.isEmpty) return;

    setState(() {
      _isSaving = true;
      _saved = false;
      _saveError = null;
    });

    final details = BasicDetails(
      name: name,
      designation: designation,
      linkedinUrl: _linkedinCtrl.text.trim(),
      twitterUrl: _twitterCtrl.text.trim(),
      githubUrl: _githubCtrl.text.trim(),
      mediumUrl: _mediumCtrl.text.trim(),
      instagramUrl: _instagramCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
    );

    final success = await widget.controller.saveBasicDetails(details);

    if (mounted) {
      if (success) {
        setState(() {
          _isSaving = false;
          _saved = true;
        });
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) setState(() => _saved = false);
      } else {
        setState(() {
          _isSaving = false;
          _saveError =
              widget.controller.firestoreErrorMessage.value ??
              'Save failed. Check Firestore rules for the site_config collection.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'BASIC DETAILS',
            title: 'Identity & profile links',
            description:
                'Your name, designation, and social URLs. This data is the single source of truth used across all pages.',
          ),
          const SizedBox(height: 28),
          _SectionLabel(label: 'Personal Info'),
          const SizedBox(height: 14),
          _FormRow(
            compact: widget.isCompact,
            children: [
              _DetailsField(
                controller: _nameCtrl,
                label: 'Full Name',
                hint: 'e.g. Gokul K S',
                icon: Icons.person_outline_rounded,
              ),
              _DetailsField(
                controller: _designationCtrl,
                label: 'Designation',
                hint: 'e.g. Flutter Developer',
                icon: Icons.work_outline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 28),
          _SectionLabel(label: 'Social Profiles'),
          const SizedBox(height: 14),
          _FormRow(
            compact: widget.isCompact,
            children: [
              _DetailsField(
                controller: _linkedinCtrl,
                label: 'LinkedIn URL',
                hint: 'https://linkedin.com/in/...',
                icon: Icons.work_rounded,
              ),
              _DetailsField(
                controller: _twitterCtrl,
                label: 'Twitter / X URL',
                hint: 'https://twitter.com/...',
                icon: Icons.tag_rounded,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _FormRow(
            compact: widget.isCompact,
            children: [
              _DetailsField(
                controller: _githubCtrl,
                label: 'GitHub URL',
                hint: 'https://github.com/...',
                icon: Icons.code_rounded,
              ),
              _DetailsField(
                controller: _mediumCtrl,
                label: 'Medium URL',
                hint: 'https://medium.com/@...',
                icon: Icons.article_rounded,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _FormRow(
            compact: widget.isCompact,
            children: [
              _DetailsField(
                controller: _instagramCtrl,
                label: 'Instagram URL',
                hint: 'https://instagram.com/...',
                icon: Icons.camera_alt_rounded,
              ),
              _DetailsField(
                controller: _emailCtrl,
                label: 'Official Email',
                hint: 'you@example.com',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          const SizedBox(height: 28),
          if (_saveError != null) ...[
            _ErrorBanner(message: _saveError!),
            const SizedBox(height: 14),
          ],
          _SaveFooter(
            isSaving: _isSaving,
            saved: _saved,
            onPressed: _save,
          ),
        ],
      ),
    );

    return formPanel;
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.manrope(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({required this.children, required this.compact});

  final List<Widget> children;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Column(
        children: children
            .expand((w) => [w, const SizedBox(height: 14)])
            .toList()
          ..removeLast(),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .expand((w) => [Expanded(child: w), const SizedBox(width: 14)])
          .toList()
        ..removeLast(),
    );
  }
}

class _DetailsField extends StatelessWidget {
  const _DetailsField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primaryGreen),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                color: Colors.white54,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.manrope(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.manrope(color: Colors.white24, fontSize: 13),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.04),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primaryGreen),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7C7C).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFF7C7C).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFFF8C8C),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.manrope(
                color: const Color(0xFFFF8C8C),
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.isSaving,
    required this.saved,
    required this.onPressed,
  });

  final bool isSaving;
  final bool saved;
  final VoidCallback onPressed;

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
            const Icon(
              Icons.check_rounded,
              color: AppColors.primaryGreen,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Saved',
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
        isSaving ? 'Saving…' : 'Save changes',
        style: GoogleFonts.manrope(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _SaveFooter extends StatelessWidget {
  const _SaveFooter({
    required this.isSaving,
    required this.saved,
    required this.onPressed,
  });

  final bool isSaving;
  final bool saved;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: Colors.white38,
          size: 14,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Changes are saved to Firestore and take effect everywhere immediately.',
            style: GoogleFonts.manrope(
              color: Colors.white38,
              fontSize: 11.5,
            ),
          ),
        ),
        const SizedBox(width: 16),
        _SaveButton(isSaving: isSaving, saved: saved, onPressed: onPressed),
      ],
    );
  }
}

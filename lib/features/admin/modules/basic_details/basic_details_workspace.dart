import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../portfolio/models/firebase_content_models.dart';
import '../../../../core/providers/admin_portal_provider.dart';
import '../../widgets/admin_error_banner.dart';
import '../../widgets/admin_form_field.dart';
import '../../widgets/admin_form_row.dart';
import '../../widgets/admin_save_footer.dart';
import '../../widgets/admin_section_header.dart';
import '../../widgets/admin_section_label.dart';
import '../../widgets/admin_surface_card.dart';

class BasicDetailsWorkspace extends ConsumerStatefulWidget {
  const BasicDetailsWorkspace({
    super.key,
    required this.isCompact,
  });

  final bool isCompact;

  @override
  ConsumerState<BasicDetailsWorkspace> createState() =>
      _BasicDetailsWorkspaceState();
}

class _BasicDetailsWorkspaceState extends ConsumerState<BasicDetailsWorkspace> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _designationCtrl;
  late final TextEditingController _linkedinCtrl;
  late final TextEditingController _twitterCtrl;
  late final TextEditingController _githubCtrl;
  late final TextEditingController _mediumCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _locationCtrl;

  bool _isSaving = false;
  bool _saved = false;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    final d = ref.read(adminPortalProvider.notifier).basicDetails;
    _nameCtrl = TextEditingController(text: d.name);
    _designationCtrl = TextEditingController(text: d.designation);
    _linkedinCtrl = TextEditingController(text: d.linkedinUrl);
    _twitterCtrl = TextEditingController(text: d.twitterUrl);
    _githubCtrl = TextEditingController(text: d.githubUrl);
    _mediumCtrl = TextEditingController(text: d.mediumUrl);
    _emailCtrl = TextEditingController(text: d.email);
    _bioCtrl = TextEditingController(text: d.bio);
    _locationCtrl = TextEditingController(text: d.location);
  }

  void _populate(BasicDetails d) {
    _nameCtrl.text = d.name;
    _designationCtrl.text = d.designation;
    _linkedinCtrl.text = d.linkedinUrl;
    _twitterCtrl.text = d.twitterUrl;
    _githubCtrl.text = d.githubUrl;
    _mediumCtrl.text = d.mediumUrl;
    _emailCtrl.text = d.email;
    _bioCtrl.text = d.bio;
    _locationCtrl.text = d.location;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _designationCtrl.dispose();
    _linkedinCtrl.dispose();
    _twitterCtrl.dispose();
    _githubCtrl.dispose();
    _mediumCtrl.dispose();
    _emailCtrl.dispose();
    _bioCtrl.dispose();
    _locationCtrl.dispose();
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
      email: _emailCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
    );

    final success =
        await ref.read(adminPortalProvider.notifier).saveBasicDetails(details);

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
          _saveError = ref.read(adminPortalProvider).firestoreErrorMessage ??
              'Save failed. Check Firestore rules for the site_config collection.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for remote updates to liveBasicDetails and repopulate form
    ref.listen(
      adminPortalProvider.select((s) => s.liveBasicDetails),
      (prev, next) {
        if (next != null && !_isSaving) _populate(next);
      },
    );

    return AdminSurfaceCard(
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
          const AdminSectionLabel(label: 'Personal Info'),
          const SizedBox(height: 14),
          AdminFormRow(
            compact: widget.isCompact,
            children: [
              AdminFormField(
                controller: _nameCtrl,
                label: 'Full Name',
                hint: 'e.g. Gokul K S',
                icon: Icons.person_outline_rounded,
              ),
              AdminFormField(
                controller: _designationCtrl,
                label: 'Designation',
                hint: 'e.g. Flutter Developer',
                icon: Icons.work_outline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 14),
          AdminFormRow(
            compact: widget.isCompact,
            children: [
              AdminFormField(
                controller: _locationCtrl,
                label: 'Location',
                hint: 'e.g. India',
                icon: Icons.location_on_outlined,
              ),
            ],
          ),
          const SizedBox(height: 14),
          AdminFormField(
            controller: _bioCtrl,
            label: 'Bio',
            hint: 'Short intro shown on the hero, about, and contact sections.',
            icon: Icons.notes_rounded,
            maxLines: 4,
          ),
          const SizedBox(height: 28),
          const AdminSectionLabel(label: 'Social Profiles'),
          const SizedBox(height: 14),
          AdminFormRow(
            compact: widget.isCompact,
            children: [
              AdminFormField(
                controller: _linkedinCtrl,
                label: 'LinkedIn URL',
                hint: 'https://linkedin.com/in/...',
                icon: Icons.work_rounded,
              ),
              AdminFormField(
                controller: _twitterCtrl,
                label: 'Twitter / X URL',
                hint: 'https://twitter.com/...',
                icon: Icons.tag_rounded,
              ),
            ],
          ),
          const SizedBox(height: 14),
          AdminFormRow(
            compact: widget.isCompact,
            children: [
              AdminFormField(
                controller: _githubCtrl,
                label: 'GitHub URL',
                hint: 'https://github.com/...',
                icon: Icons.code_rounded,
              ),
              AdminFormField(
                controller: _mediumCtrl,
                label: 'Medium URL',
                hint: 'https://medium.com/@...',
                icon: Icons.article_rounded,
              ),
            ],
          ),
          const SizedBox(height: 14),
          AdminFormRow(
            compact: widget.isCompact,
            children: [
              AdminFormField(
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
            AdminErrorBanner(message: _saveError!),
            const SizedBox(height: 14),
          ],
          AdminSaveFooter(
            isSaving: _isSaving,
            saved: _saved,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

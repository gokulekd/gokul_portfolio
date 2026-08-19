import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/supabase_storage_service.dart';
import '../models/testimonial_entry.dart';

/// Public, shareable page (`/leave-a-review`) where friends, coworkers, and
/// clients can submit a testimonial directly: name, role, an optional photo,
/// a star rating, and a comment. Submissions always land as `pending` in
/// Supabase (see `SupabaseTestimonialsService.submit`) — nothing here can
/// publish straight to the live portfolio. The admin portal's Testimonials
/// workspace reviews and approves/hides/edits/deletes from there.
class TestimonialSubmissionPage extends ConsumerStatefulWidget {
  const TestimonialSubmissionPage({super.key});

  @override
  ConsumerState<TestimonialSubmissionPage> createState() =>
      _TestimonialSubmissionPageState();
}

class _TestimonialSubmissionPageState
    extends ConsumerState<TestimonialSubmissionPage> {
  final _nameCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  double _rating = 5;
  Uint8List? _avatarBytes;
  String _avatarUrl = '';
  bool _isUploadingAvatar = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    _companyCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;

    setState(() {
      _avatarBytes = bytes;
      _isUploadingAvatar = true;
    });

    final storage = ref.read(supabaseStorageServiceProvider);
    final uploaded = await storage.uploadFromBytes(
      bucket: SupabaseStorageService.mediaBucket,
      folder: 'media/testimonials',
      fileName: file.name,
      bytes: bytes,
    );

    if (!mounted) return;
    setState(() {
      _isUploadingAvatar = false;
      _avatarUrl = uploaded?.url ?? '';
      if (uploaded == null) {
        _errorMessage = "Couldn't upload that photo — you can still submit without one.";
      }
    });
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final role = _roleCtrl.text.trim();
    final company = _companyCtrl.text.trim();
    final message = _messageCtrl.text.trim();

    if (name.isEmpty || role.isEmpty || message.isEmpty) {
      setState(() => _errorMessage = 'Please fill in your name, role, and a short message.');
      return;
    }
    if (message.length < 15) {
      setState(() => _errorMessage = 'Please write a little more — a sentence or two is perfect.');
      return;
    }

    final service = ref.read(supabaseTestimonialsServiceProvider);
    if (!service.isEnabled) {
      setState(() => _errorMessage = 'Submissions are temporarily unavailable. Please try again later.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final entry = TestimonialEntry(
      rating: _rating,
      text: message,
      authorName: name,
      authorRole: company.isEmpty ? role : '$role, $company',
      avatarUrl: _avatarUrl,
      createdAt: DateTime.now(),
    );

    final saved = await service.submit(entry);
    if (!mounted) return;

    if (saved != null) {
      setState(() {
        _isSubmitting = false;
        _submitted = true;
      });
    } else {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Something went wrong submitting your review. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 24,
            vertical: 32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BackHomeLink(onTap: () => context.go(AppRoutes.home)),
                  const SizedBox(height: 28),
                  _submitted ? _buildSuccess(isMobile) : _buildForm(isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '{06} – Share your experience',
              style: GoogleFonts.manrope(fontSize: 14, color: Colors.grey[400]),
            ),
            const SizedBox(width: 8),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Write me a review',
          style: GoogleFonts.manrope(
            fontSize: isMobile ? 34 : 44,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "If we've worked together, I'd love a few honest words from you. "
          "Add a photo if you like — it goes a long way. Submissions are "
          "reviewed before they appear on the portfolio.",
          style: GoogleFonts.manrope(
            fontSize: 15.5,
            color: Colors.white.withValues(alpha: 0.68),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 20 : 30),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildAvatarPicker()),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: _FieldLabel(
                      label: 'Your name',
                      child: _textField(_nameCtrl, hint: 'e.g. Priya Nair'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _FieldLabel(
                      label: 'Your role',
                      child: _textField(_roleCtrl, hint: 'e.g. Product Designer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _FieldLabel(
                label: 'Company / Team (optional)',
                child: _textField(_companyCtrl, hint: 'e.g. Acme Studio'),
              ),
              const SizedBox(height: 18),
              _FieldLabel(
                label: 'Your rating',
                child: _StarRatingInput(
                  value: _rating,
                  onChanged: (v) => setState(() => _rating = v),
                ),
              ),
              const SizedBox(height: 18),
              _FieldLabel(
                label: 'Your message',
                child: _textField(
                  _messageCtrl,
                  hint: 'What was it like working together?',
                  maxLines: 5,
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7C7C).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFF7C7C).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Color(0xFFFF7C7C), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.manrope(
                            fontSize: 13.5,
                            color: const Color(0xFFFF9C9C),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: AppColors.primaryGreen.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
                        )
                      : Text(
                          'Submit review',
                          style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Your review is sent for a quick check before it goes live — thank you!",
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(fontSize: 12, color: Colors.white.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarPicker() {
    return GestureDetector(
      onTap: _isUploadingAvatar ? null : _pickAvatar,
      child: Stack(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.06),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: _avatarBytes != null
                ? Image.memory(_avatarBytes!, fit: BoxFit.cover)
                : Icon(Icons.person_rounded, size: 40, color: Colors.white.withValues(alpha: 0.25)),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _isUploadingAvatar ? Colors.black54 : AppColors.primaryGreen,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF111111), width: 2.5),
              ),
              child: _isUploadingAvatar
                  ? const Padding(
                      padding: EdgeInsets.all(6),
                      child: CircularProgressIndicator(
                        strokeWidth: 1.8,
                        valueColor: AlwaysStoppedAnimation(AppColors.primaryGreen),
                      ),
                    )
                  : const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(
    TextEditingController controller, {
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.manrope(color: Colors.white, fontSize: 14.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.manrope(color: Colors.white24, fontSize: 14.5),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 16 : 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSuccess(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 40, vertical: isMobile ? 40 : 56),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: Colors.black, size: 36),
          ),
          const SizedBox(height: 28),
          Text(
            'Thank you!',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(fontSize: isMobile ? 28 : 34, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            "Your review has been submitted for a quick review and will "
            "appear on the portfolio once it's approved.",
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.68),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => setState(() {
                  _submitted = false;
                  _nameCtrl.clear();
                  _roleCtrl.clear();
                  _companyCtrl.clear();
                  _messageCtrl.clear();
                  _rating = 5;
                  _avatarBytes = null;
                  _avatarUrl = '';
                }),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: Text('Submit another', style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
              ),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  elevation: 0,
                ),
                child: Text('Back to portfolio', style: GoogleFonts.manrope(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackHomeLink extends StatelessWidget {
  const _BackHomeLink({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_rounded, size: 16, color: Colors.white.withValues(alpha: 0.6)),
          const SizedBox(width: 6),
          Text(
            'Back to portfolio',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _StarRatingInput extends StatelessWidget {
  const _StarRatingInput({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          final starValue = index + 1;
          final isFilled = starValue <= value;
          return GestureDetector(
            onTap: () => onChanged(starValue.toDouble()),
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(
                isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                color: isFilled ? AppColors.primaryGreen : Colors.white24,
                size: 34,
              ),
            ),
          );
        }),
        const SizedBox(width: 10),
        Text(
          '${value.toInt()}/5',
          style: GoogleFonts.manrope(color: Colors.white54, fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ],
    );
  }
}

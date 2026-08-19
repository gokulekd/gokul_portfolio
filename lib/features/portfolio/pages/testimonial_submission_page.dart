import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/supabase_storage_service.dart';
import '../models/preset_avatars.dart';
import '../models/testimonial_entry.dart';
import '../widgets/shared/custom_widgets.dart';

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
  String _uploadedAvatarUrl = '';
  bool _isUploadingAvatar = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  bool _submitted = false;

  // The avatar wheel's first slot ("Upload from device") is index 0; slots
  // 1..N map to `presetAvatars[index - 1]`. Whichever slot is centered in
  // the wheel is the active choice — this decouples "which tile is
  // centered" from "has a photo actually been picked yet", so scrolling
  // past the upload tile never wipes a chosen preset, and vice versa.
  int _activeAvatarIndex = 0;

  String get _effectiveAvatarUrl => _activeAvatarIndex == 0
      ? _uploadedAvatarUrl
      : presetAvatars[_activeAvatarIndex - 1].url;

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
      _activeAvatarIndex = 0;
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
      _uploadedAvatarUrl = uploaded?.url ?? '';
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
      avatarUrl: _effectiveAvatarUrl,
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
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 24,
            vertical: 32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: isMobile ? 38 : 50,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "If we've worked together, I'd love a few honest words from you. "
          "Add a photo if you like — it goes a long way. Submissions are "
          "reviewed before they appear on the portfolio.",
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 17,
            color: Colors.white.withValues(alpha: 0.68),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 36),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 24 : 40),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatarWheel(isMobile),
              const SizedBox(height: 32),
              if (isMobile) ...[
                _FieldLabel(
                  label: 'Your name',
                  child: _textField(_nameCtrl, hint: 'e.g. Priya Nair'),
                ),
                const SizedBox(height: 22),
                _FieldLabel(
                  label: 'Your role',
                  child: _textField(_roleCtrl, hint: 'e.g. Product Designer'),
                ),
                const SizedBox(height: 22),
                _FieldLabel(
                  label: 'Company / Team (optional)',
                  child: _textField(_companyCtrl, hint: 'e.g. Acme Studio'),
                ),
              ] else ...[
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
                const SizedBox(height: 22),
                _FieldLabel(
                  label: 'Company / Team (optional)',
                  child: _textField(_companyCtrl, hint: 'e.g. Acme Studio'),
                ),
              ],
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
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: AppColors.primaryGreen.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
                        )
                      : Text(
                          'Submit review',
                          style: GoogleFonts.manrope(fontSize: 17, fontWeight: FontWeight.w800),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Your review is sent for a quick check before it goes live — thank you!",
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(fontSize: 13, color: Colors.white.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Called when the wheel settles on a new center slot — via a drag, or a
  /// tap on a slot other than the one already centered. Just updates which
  /// slot is "active"; never touches `_avatarBytes`/`_uploadedAvatarUrl`, so
  /// scrolling past the upload tile can never wipe an already-picked photo,
  /// and scrolling past a preset never discards it either.
  void _onAvatarWheelCentered(int index) {
    setState(() {
      _activeAvatarIndex = index;
      _errorMessage = null;
    });
  }

  /// Tapping the slot that's *already* centered activates it. For presets
  /// that's a no-op (already selected); for the upload tile it opens the
  /// file picker.
  void _onAvatarWheelTapCentered(int index) {
    if (index == 0) _pickAvatar();
  }

  Widget _buildAvatarWheel(bool isMobile) {
    return Column(
      children: [
        Text(
          'Choose a photo',
          style: GoogleFonts.manrope(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Scroll left or right — the centered one is selected',
          style: GoogleFonts.manrope(
            color: Colors.white.withValues(alpha: 0.28),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        _AvatarWheelPicker(
          itemCount: presetAvatars.length + 1,
          initialIndex: _activeAvatarIndex,
          viewportFraction: isMobile ? 0.15 : 0.068,
          itemHeight: isMobile ? 122 : 132,
          onCenterChanged: _onAvatarWheelCentered,
          onTapCentered: _onAvatarWheelTapCentered,
          itemBuilder: (index, isSelected) => index == 0
              ? _uploadTileVisual(isSelected)
              : _avatarThumbVisual(presetAvatars[index - 1], isSelected),
        ),
      ],
    );
  }

  /// The wheel's first slot: shows the picked photo (or a placeholder) with
  /// a small camera badge. Tapping it while centered opens the file picker.
  Widget _uploadTileVisual(bool isSelected) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(
          color: isSelected ? AppColors.primaryGreen : Colors.white.withValues(alpha: 0.14),
          width: isSelected ? 2.5 : 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_avatarBytes != null)
            Image.memory(_avatarBytes!, fit: BoxFit.cover, width: 64, height: 64)
          else
            Icon(Icons.add_a_photo_rounded, size: 22, color: Colors.white.withValues(alpha: 0.4)),
          if (_isUploadingAvatar)
            Container(
              color: Colors.black54,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryGreen),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF111111), width: 2),
              ),
              child: const Icon(Icons.camera_alt_rounded, size: 11, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  /// Pure visual for one preset avatar circle — no gesture handling. The
  /// wheel picker owns tap-to-select (it also animates the wheel to center
  /// the tapped item), so this just renders the image + selection ring.
  Widget _avatarThumbVisual(PresetAvatar preset, bool isSelected) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
          width: 2.5,
        ),
      ),
      padding: const EdgeInsets.all(2.5),
      child: ClipOval(
        child: Image.network(
          preset.url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.white.withValues(alpha: 0.06),
            child: Icon(
              Icons.person_rounded,
              size: 24,
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),
        ),
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
      style: GoogleFonts.manrope(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.manrope(color: Colors.white24, fontSize: 16),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: maxLines > 1 ? 18 : 18),
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
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 28 : 48, vertical: isMobile ? 48 : 64),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: Colors.black, size: 42),
          ),
          const SizedBox(height: 32),
          Text(
            'Thank you!',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(fontSize: isMobile ? 30 : 38, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          const SizedBox(height: 14),
          Text(
            "Your review has been submitted for a quick review and will "
            "appear on the portfolio once it's approved.",
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 16.5,
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
                  _uploadedAvatarUrl = '';
                  _activeAvatarIndex = 0;
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
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 9),
        child,
      ],
    );
  }
}

/// Horizontal "wheel" picker: slots scroll left/right and snap so the
/// centered one is the selection. Sizing (via [viewportFraction]) never
/// changes an item's own layout footprint — only its paint scale/opacity —
/// so paging stays cheap and doesn't reflow. Slot content is entirely up to
/// [itemBuilder] (by index), so this has no idea some slots are avatars and
/// one is an "upload from device" tile — it just picks/centers/animates.
class _AvatarWheelPicker extends StatefulWidget {
  const _AvatarWheelPicker({
    required this.itemCount,
    required this.initialIndex,
    required this.viewportFraction,
    required this.itemHeight,
    required this.onCenterChanged,
    required this.itemBuilder,
    this.onTapCentered,
  });

  final int itemCount;
  final int initialIndex;
  final double viewportFraction;
  final double itemHeight;
  final ValueChanged<int> onCenterChanged;
  final ValueChanged<int>? onTapCentered;
  final Widget Function(int index, bool isSelected) itemBuilder;

  @override
  State<_AvatarWheelPicker> createState() => _AvatarWheelPickerState();
}

class _AvatarWheelPickerState extends State<_AvatarWheelPicker>
    with SingleTickerProviderStateMixin {
  // How many slots on either side of center get built. Anything past this
  // (or faded to invisible sooner, see `_opacityFor`) isn't rendered at all.
  static const int _windowRadius = 8;

  late double _page; // continuous, fractional while dragging/animating
  late int _centerRealIndex;
  late final AnimationController _animController;
  Animation<double>? _pageAnimation;

  double _dragStartPage = 0;
  double _dragStartDx = 0;
  double _pitch = 1; // px between adjacent slot centers, set each build
  Timer? _snapTimer;

  int get _count => widget.itemCount;

  @override
  void initState() {
    super.initState();
    _centerRealIndex = widget.initialIndex;
    _page = widget.initialIndex.toDouble();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..addListener(() {
        final anim = _pageAnimation;
        if (anim == null) return;
        setState(() => _page = anim.value);
        _emitCenterIfChanged();
      });
  }

  @override
  void dispose() {
    _snapTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  int _wrap(int rawIndex) {
    final m = rawIndex % _count;
    return m < 0 ? m + _count : m;
  }

  void _emitCenterIfChanged() {
    final real = _wrap(_page.round());
    if (real != _centerRealIndex) {
      _centerRealIndex = real;
      widget.onCenterChanged(real);
    }
  }

  void _animateTo(double target) {
    _pageAnimation = Tween<double>(begin: _page, end: target).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward(from: 0);
  }

  void _goTo(int rawIndex) => _animateTo(rawIndex.toDouble());

  void _snapToNearest() => _animateTo(_page.roundToDouble());

  void _onDragStart(DragStartDetails details) {
    _animController.stop();
    _dragStartPage = _page;
    _dragStartDx = details.globalPosition.dx;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _page = _dragStartPage - (details.globalPosition.dx - _dragStartDx) / _pitch;
    });
    _emitCenterIfChanged();
  }

  void _onDragEnd(DragEndDetails details) => _snapToNearest();

  // Flutter Web only turns a raw mouse wheel into vertical scrolling by
  // default. This wheel scrolls sideways, so translate wheel input
  // (vertical or horizontal — trackpads send either) into horizontal
  // paging, then snap to the nearest slot once the wheel goes quiet.
  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    final delta = event.scrollDelta.dx.abs() > event.scrollDelta.dy.abs()
        ? event.scrollDelta.dx
        : event.scrollDelta.dy;
    if (delta == 0) return;
    _animController.stop();
    setState(() => _page += delta / _pitch);
    _emitCenterIfChanged();
    _snapTimer?.cancel();
    _snapTimer = Timer(const Duration(milliseconds: 140), _snapToNearest);
  }

  double _scaleFor(double delta) => (1.35 - delta * 0.18).clamp(0.5, 1.35);

  double _opacityFor(double delta) => (1.0 - delta * 0.16).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.itemHeight,
      child: Listener(
        onPointerSignal: _handlePointerSignal,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final containerWidth = constraints.maxWidth;
            _pitch = containerWidth * widget.viewportFraction;
            final centerRaw = _page.round();
            final boxSize = widget.itemHeight;

            // Farthest-from-center first, so later (closer) entries paint
            // on top — that's what makes the front avatar sit in front of
            // the ones stacked behind it on *both* sides, not just one.
            final rawIndices = [
              for (var i = centerRaw - _windowRadius; i <= centerRaw + _windowRadius; i++) i,
            ]..sort((a, b) => (b - _page).abs().compareTo((a - _page).abs()));

            return GestureDetector(
              onHorizontalDragStart: _onDragStart,
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  for (final rawIndex in rawIndices)
                    Builder(
                      builder: (context) {
                        final delta = (rawIndex - _page).abs();
                        final opacity = _opacityFor(delta);
                        if (opacity <= 0.02) return const SizedBox.shrink();
                        final realIndex = _wrap(rawIndex);
                        final centerX = containerWidth / 2 + (rawIndex - _page) * _pitch;
                        return Positioned(
                          left: centerX - boxSize / 2,
                          top: 0,
                          width: boxSize,
                          height: widget.itemHeight,
                          child: Opacity(
                            opacity: opacity,
                            child: Center(
                              child: Transform.scale(
                                scale: _scaleFor(delta),
                                child: GestureDetector(
                                  onTap: () {
                                    if (rawIndex == centerRaw) {
                                      widget.onTapCentered?.call(realIndex);
                                    } else {
                                      _goTo(rawIndex);
                                    }
                                  },
                                  child: widget.itemBuilder(realIndex, realIndex == _centerRealIndex),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
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
                size: 40,
              ),
            ),
          );
        }),
        const SizedBox(width: 12),
        Text(
          '${value.toInt()}/5',
          style: GoogleFonts.manrope(color: Colors.white54, fontWeight: FontWeight.w700, fontSize: 14.5),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/routes/app_routes.dart';

IconData _iconForPlatform(String platform) {
  switch (platform.toLowerCase()) {
    case 'twitter':
      return FontAwesomeIcons.xTwitter;
    case 'linkedin':
      return FontAwesomeIcons.linkedinIn;
    case 'github':
      return FontAwesomeIcons.github;
    case 'medium':
      return FontAwesomeIcons.medium;
    case 'instagram':
      return FontAwesomeIcons.instagram;
    case 'facebook':
      return FontAwesomeIcons.facebookF;
    default:
      return FontAwesomeIcons.globe;
  }
}

class ContactFormSection extends ConsumerStatefulWidget {
  const ContactFormSection({super.key});

  @override
  ConsumerState<ContactFormSection> createState() => ContactFormSectionState();
}

class ContactFormSectionState extends ConsumerState<ContactFormSection> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _messageController;
  bool _isSubmitting = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final palette = _FormPalette.of(context);
    final isCompact =
        ResponsiveHelper.isMobile(context) ||
        ResponsiveHelper.isTablet(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: palette.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.panelBorder),
      ),
      child:
          isCompact
              // The copy column already ends with the email, location and
              // socials, so the form just follows it.
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContactCopy(context),
                  const SizedBox(height: 28),
                  _buildContactFormCard(context, colorScheme),
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: _buildContactCopy(context)),
                  const SizedBox(width: 36),
                  Expanded(
                    flex: 5,
                    child: _buildContactFormCard(context, colorScheme),
                  ),
                ],
              ),
    );
  }

  Widget _buildContactCopy(BuildContext context) {
    final palette = _FormPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact me',
          style: GoogleFonts.manrope(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: palette.text,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 14),
        const AccentWaveDivider(),
        const SizedBox(height: 24),
        Text(
          "I'm always interested in new opportunities and meaningful collaborations. If you have a product idea, freelance project, or just want to connect, reach out.",
          style: GoogleFonts.manrope(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: palette.textMuted,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 28),
        _buildContactDetails(
          context,
          ref.watch(portfolioProvider).personalInfo.socialLinks
              .take(4)
              .toList(growable: false),
          Theme.of(context).colorScheme,
        ),
      ],
    );
  }

  Widget _buildContactFormCard(BuildContext context, ColorScheme colorScheme) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final palette = _FormPalette.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 22 : 28),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get in touch",
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 36 : 42,
              fontWeight: FontWeight.w500,
              color: palette.cardText,
              height: 1.05,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 28),
          _buildInquiryField(
            controller: _nameController,
            hintText: 'Name',
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          _buildInquiryField(
            controller: _emailController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          _buildInquiryField(
            controller: _messageController,
            hintText: 'Leave me a message',
            maxLines: 6,
          ),
          if (_hasError) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: palette.errorFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: palette.errorBorder),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline_rounded, color: palette.errorText, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Something went wrong. Please try again or email me directly.',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: palette.errorText,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitInquiry,
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.button,
                foregroundColor: palette.buttonText,
                disabledBackgroundColor: palette.button.withValues(alpha: 0.6),
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: palette.buttonText,
                      ),
                    )
                  : Text(
                      'Send Message',
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: palette.buttonText,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final palette = _FormPalette.of(context);
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: palette.cardText,
      ),
      cursorColor: AppColors.primaryGreen,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: palette.inputHint,
        ),
        filled: true,
        fillColor: palette.inputFill,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: maxLines > 1 ? 24 : 22,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildContactDetails(
    BuildContext context,
    List socialLinks,
    ColorScheme colorScheme,
  ) {
    final palette = _FormPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactDetailRow(
          icon: FontAwesomeIcons.envelope,
          label: 'Email',
          value: ref.watch(portfolioProvider).personalInfo.email,
        ),
        const SizedBox(height: 18),
        _buildContactDetailRow(
          icon: FontAwesomeIcons.locationDot,
          label: 'Location',
          value: ref.watch(portfolioProvider).personalInfo.location,
        ),
        const SizedBox(height: 28),
        Text(
          'Socials',
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: palette.textFaint,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              socialLinks
                  .map<Widget>(
                    (link) => InkWell(
                      onTap: () => ref.read(portfolioProvider.notifier).launchSocialLink(link.url),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: palette.chipFill,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: palette.chipBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _iconForPlatform(link.platform),
                              size: 14,
                              color: palette.chipText,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              link.platform,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: palette.chipText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildContactDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final palette = _FormPalette.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: AppColors.primaryGreen),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: palette.textFaint,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: palette.text,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitInquiry() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in name, email, and message.'),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    setState(() { _isSubmitting = true; _hasError = false; });

    try {
      final success = await ref.read(contactServiceProvider).submitContactForm(
        name: name,
        email: email,
        message: message,
      );

      if (!mounted) return;

      if (success) {
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
        setState(() => _isSubmitting = false);
        await showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black.withValues(alpha: 0.6),
          builder: (_) => SuccessDialog(senderName: name),
        );
        if (!mounted) return;
        context.go(AppRoutes.home);
      } else {
        setState(() { _isSubmitting = false; _hasError = true; });
      }
    } catch (_) {
      if (mounted) setState(() { _isSubmitting = false; _hasError = true; });
    }
  }
}

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({super.key, required this.senderName});
  final String senderName;

  @override
  State<SuccessDialog> createState() => SuccessDialogState();
}

class SuccessDialogState extends State<SuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return FadeTransition(
      opacity: _fadeAnim,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: 40,
        ),
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            padding: EdgeInsets.all(isMobile ? 28 : 40),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 60,
                  offset: const Offset(0, 24),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Green check ring around profile image
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: isMobile ? 100 : 120,
                      height: isMobile ? 100 : 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryGreen,
                          width: 3,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: isMobile ? 44 : 54,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: const AssetImage(
                        'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 24 : 32),
                Text(
                  'Message received!',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 26 : 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Text(
                  'Hey ${widget.senderName}, thanks for reaching out.\nI\'ll get back to you as soon as possible!',
                  style: GoogleFonts.manrope(
                    fontSize: isMobile ? 15 : 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.68),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 28 : 36),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Back to Home',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccentWaveDivider extends StatelessWidget {
  const AccentWaveDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 14,
      child: CustomPaint(painter: WaveLinePainter()),
    );
  }
}

class WaveLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primaryGreen.withValues(alpha: 0.78)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4;

    final path = Path();
    const waveWidth = 12.0;
    final halfHeight = size.height / 2;
    path.moveTo(0, halfHeight);

    for (double x = 0; x < size.width; x += waveWidth) {
      path.quadraticBezierTo(
        x + waveWidth / 4,
        0,
        x + waveWidth / 2,
        halfHeight,
      );
      path.quadraticBezierTo(
        x + 3 * waveWidth / 4,
        size.height,
        x + waveWidth,
        halfHeight,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Colours for the contact form block: a soft light panel with a white form
/// card in light mode, near-black with a dark card in dark mode.
class _FormPalette {
  const _FormPalette({
    required this.panel,
    required this.panelBorder,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.chipFill,
    required this.chipBorder,
    required this.chipText,
    required this.card,
    required this.cardBorder,
    required this.cardText,
    required this.inputFill,
    required this.inputHint,
    required this.button,
    required this.buttonText,
    required this.errorFill,
    required this.errorBorder,
    required this.errorText,
  });

  factory _FormPalette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? _dark : _light;
  }

  static final _light = _FormPalette(
    panel: const Color(0xFFF4F6F2),
    panelBorder: Colors.black.withValues(alpha: 0.08),
    text: const Color(0xFF111111),
    textMuted: Colors.black.withValues(alpha: 0.65),
    textFaint: Colors.black.withValues(alpha: 0.5),
    chipFill: Colors.white,
    chipBorder: Colors.black.withValues(alpha: 0.1),
    chipText: Colors.black.withValues(alpha: 0.75),
    card: Colors.white,
    cardBorder: Colors.black.withValues(alpha: 0.06),
    cardText: const Color(0xFF2F2F2F),
    inputFill: const Color(0xFFF3F4F1),
    inputHint: const Color(0xFF9A9A9A),
    button: const Color(0xFF111111),
    buttonText: Colors.white,
    errorFill: Colors.red.shade50,
    errorBorder: Colors.red.shade200,
    errorText: Colors.red.shade700,
  );

  static final _dark = _FormPalette(
    panel: const Color(0xFF111111),
    panelBorder: Colors.white.withValues(alpha: 0.18),
    text: Colors.white,
    textMuted: Colors.white.withValues(alpha: 0.72),
    textFaint: Colors.white.withValues(alpha: 0.5),
    chipFill: Colors.white.withValues(alpha: 0.06),
    chipBorder: Colors.white.withValues(alpha: 0.12),
    chipText: Colors.white.withValues(alpha: 0.8),
    card: const Color(0xFF1A1C1F),
    cardBorder: Colors.white.withValues(alpha: 0.08),
    cardText: Colors.white,
    inputFill: const Color(0xFF26292C),
    inputHint: Colors.white.withValues(alpha: 0.4),
    button: AppColors.primaryGreen,
    buttonText: Colors.black,
    errorFill: Colors.red.withValues(alpha: 0.12),
    errorBorder: Colors.red.withValues(alpha: 0.4),
    errorText: Colors.red.shade300,
  );

  final Color panel;
  final Color panelBorder;
  final Color text;
  final Color textMuted;
  final Color textFaint;
  final Color chipFill;
  final Color chipBorder;
  final Color chipText;
  final Color card;
  final Color cardBorder;
  final Color cardText;
  final Color inputFill;
  final Color inputHint;
  final Color button;
  final Color buttonText;
  final Color errorFill;
  final Color errorBorder;
  final Color errorText;
}

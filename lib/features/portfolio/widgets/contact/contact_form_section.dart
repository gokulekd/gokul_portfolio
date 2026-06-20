import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../services/contact_service.dart';
import '../../../../providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../routes/app_routes.dart';
import 'contact_closing_section.dart' show AccentWaveDivider;

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
    final isCompact =
        ResponsiveHelper.isMobile(context) ||
        ResponsiveHelper.isTablet(context);
    final socialLinks = ref.watch(portfolioProvider).personalInfo.socialLinks
        .take(4)
        .toList(growable: false);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child:
          isCompact
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContactCopy(context),
                  const SizedBox(height: 28),
                  _buildContactFormCard(context, colorScheme),
                  const SizedBox(height: 24),
                  _buildContactDetails(context, socialLinks, colorScheme),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact me',
          style: GoogleFonts.manrope(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.white,
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
            color: Colors.white.withValues(alpha: 0.72),
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 22 : 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get in touch",
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 36 : 42,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2F2F2F),
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
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline_rounded, color: Colors.red.shade600, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Something went wrong. Please try again or email me directly.',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: Colors.red.shade700,
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
                backgroundColor: const Color(0xFF2F2F2F),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF2F2F2F).withValues(alpha: 0.6),
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Send Message',
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF2F2F2F),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFB5B5B5),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
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
            color: Colors.white.withValues(alpha: 0.5),
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
                          color: colorScheme.surface.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _iconForPlatform(link.platform),
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              link.platform,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.8),
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
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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
      final success = await ContactService().submitContactForm(
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class Testimonial {
  final double rating;
  final String text;

  const Testimonial({
    required this.rating,
    required this.text,
  });
}

class TestimonialsSectionNew extends StatefulWidget {
  const TestimonialsSectionNew({super.key});

  @override
  State<TestimonialsSectionNew> createState() =>
      _TestimonialsSectionNewState();
}

class _TestimonialsSectionNewState extends State<TestimonialsSectionNew>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  static final List<Testimonial> _testimonials = [
    const Testimonial(
      rating: 5.0,
      text:
          "Working with this developer was an absolute pleasure. The attention to detail and creative solutions exceeded all our expectations. Highly recommended!",
    ),
    const Testimonial(
      rating: 4.5,
      text:
          "Professional, responsive, and delivered exactly what we needed. The project was completed on time and the quality was outstanding.",
    ),
    const Testimonial(
      rating: 5.0,
      text:
          "Exceptional work! The design is modern, clean, and perfectly aligned with our brand. Couldn't be happier with the results.",
    ),
    const Testimonial(
      rating: 4.8,
      text:
          "Great communication throughout the project. The developer understood our vision and brought it to life beautifully.",
    ),
    const Testimonial(
      rating: 5.0,
      text:
          "Outstanding service from start to finish. The final product exceeded our expectations and the process was smooth and efficient.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  void _startScrolling() {
    if (!mounted) return;
    _animationController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(_scrollController.offset + 0.5);
        }
      }
    });
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 0,
      ),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section identifier
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "{04} – Testimonials",
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.darkGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Main title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Don't take my word for it",
                    style: GoogleFonts.manrope(
                      fontSize: isMobile ? 40 : 60,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "*",
                    style: GoogleFonts.manrope(
                      fontSize: isMobile ? 40 : 60,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Secondary text
          Text(
            "* Take theirs",
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 60),
          // Testimonials carousel
          SizedBox(
            height: isMobile ? 280 : 320,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: [
                  // Duplicate testimonials for seamless loop
                  ...List.generate(3, (index) {
                    return Row(
                      children: _testimonials
                          .map((testimonial) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: _buildTestimonialCard(
                                  testimonial,
                                  isMobile,
                                ),
                              ))
                          .toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(Testimonial testimonial, bool isMobile) {
    return Container(
      width: isMobile ? 320 : 400,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[600]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating and quote icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating
              Row(
                children: [
                  Text(
                    "${testimonial.rating}/5",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...List.generate(5, (index) {
                    final isFilled = index < testimonial.rating.floor();
                    final isHalf = index == testimonial.rating.floor() &&
                        testimonial.rating % 1 >= 0.5;
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: CustomPaint(
                        size: const Size(12, 12),
                        painter: _DiamondPainter(
                          color: isFilled || isHalf
                              ? AppColors.darkGreen
                              : Colors.grey[600]!,
                          isHalf: isHalf && !isFilled,
                        ),
                      ),
                    );
                  }),
                ],
              ),
              // Quote icon
              Opacity(
                opacity: 0.3,
                child: Text(
                  '"',
                  style: GoogleFonts.manrope(
                    fontSize: 64,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[300],
                    height: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Testimonial text
          Expanded(
            child: Text(
              testimonial.text,
              style: GoogleFonts.manrope(
                fontSize: 16,
                color: Colors.grey[300],
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for diamond shape
class _DiamondPainter extends CustomPainter {
  final Color color;
  final bool isHalf;

  _DiamondPainter({required this.color, this.isHalf = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    if (isHalf) {
      // Draw half diamond (left side filled, right side outline)
      path.moveTo(centerX, 0);
      path.lineTo(size.width, centerY);
      path.lineTo(centerX, size.height);
      path.lineTo(0, centerY);
      path.close();
      canvas.drawPath(path, paint);

      // Draw outline for right half
      final outlinePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      final outlinePath = Path();
      outlinePath.moveTo(centerX, 0);
      outlinePath.lineTo(size.width, centerY);
      outlinePath.lineTo(centerX, size.height);
      canvas.drawPath(outlinePath, outlinePaint);
    } else {
      // Draw full diamond
      path.moveTo(centerX, 0);
      path.lineTo(size.width, centerY);
      path.lineTo(centerX, size.height);
      path.lineTo(0, centerY);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

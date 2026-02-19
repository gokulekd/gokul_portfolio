import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class Testimonial {
  final double rating;
  final String text;
  final String authorName;
  final String authorRole;
  final String avatarUrl;

  const Testimonial({
    required this.rating,
    required this.text,
    required this.authorName,
    required this.authorRole,
    required this.avatarUrl,
  });
}

class TestimonialsSectionNew extends StatefulWidget {
  const TestimonialsSectionNew({super.key});

  @override
  State<TestimonialsSectionNew> createState() => _TestimonialsSectionNewState();
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
      authorName: "David Mitchell",
      authorRole: "CEO, TechFlow",
      avatarUrl: "https://randomuser.me/api/portraits/men/32.jpg",
    ),
    const Testimonial(
      rating: 4.5,
      text:
          "Professional, responsive, and delivered exactly what we needed. The project was completed on time and the quality was outstanding.",
      authorName: "Sarah Lewis",
      authorRole: "Product Manager",
      avatarUrl: "https://randomuser.me/api/portraits/women/44.jpg",
    ),
    const Testimonial(
      rating: 5.0,
      text:
          "Exceptional work! The design is modern, clean, and perfectly aligned with our brand. Couldn't be happier with the results.",
      authorName: "James Reynolds",
      authorRole: "Founder, StartUp",
      avatarUrl: "https://randomuser.me/api/portraits/men/86.jpg",
    ),
    const Testimonial(
      rating: 4.8,
      text:
          "Great communication throughout the project. The developer understood our vision and brought it to life beautifully.",
      authorName: "Emily Wilson",
      authorRole: "Marketing Director",
      avatarUrl: "https://randomuser.me/api/portraits/women/68.jpg",
    ),
    const Testimonial(
      rating: 5.0,
      text:
          "Outstanding service from start to finish. The final product exceeded our expectations and the process was smooth and efficient.",
      authorName: "Michael Brown",
      authorRole: "CTO, DevInc",
      avatarUrl: "https://randomuser.me/api/portraits/men/11.jpg",
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
      child: Stack(
        children: [
          // Background decorative elements
          Positioned.fill(child: CustomPaint(painter: _BackgroundPainter())),
          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section identifier
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "{05} – Testimonials",
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
                      color: AppColors.primaryGreen,
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
                          color: AppColors.primaryGreen,
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
                height: isMobile ? 320 : 360,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Row(
                    children: [
                      // Duplicate testimonials for seamless loop
                      ...List.generate(3, (index) {
                        return Row(
                          children:
                              _testimonials
                                  .map(
                                    (testimonial) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: _buildTestimonialCard(
                                        testimonial,
                                        isMobile,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(Testimonial testimonial, bool isMobile) {
    return Container(
      width: isMobile ? 320 : 400,
      height: isMobile ? 320 : 360,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[600]!, width: 1),
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
                    final isHalf =
                        index == testimonial.rating.floor() &&
                        testimonial.rating % 1 >= 0.5;
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        isFilled
                            ? Icons.star
                            : isHalf
                            ? Icons.star_half
                            : Icons.star,
                        color:
                            isFilled || isHalf
                                ? AppColors.primaryGreen
                                : Colors.grey[600],
                        size: 16,
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
          const SizedBox(height: 24),
          // Author info
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(testimonial.avatarUrl),
                backgroundColor: Colors.grey[800],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testimonial.authorName,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    testimonial.authorRole,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for background decorative elements - Adapted for Dark Background
class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final strokePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    // 1. Cluster (Top Right)
    // Smaller Triangle
    final path1 =
        Path()
          ..moveTo(size.width * 0.88, size.height * 0.15)
          ..lineTo(size.width * 0.94, size.height * 0.22)
          ..lineTo(size.width * 0.82, size.height * 0.25)
          ..close();

    paint.shader = LinearGradient(
      colors: [
        AppColors.primaryGreen.withOpacity(0.1),
        AppColors.primaryGreen.withOpacity(0.3),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path1, paint);

    // Added Shape: Small Circle near triangle
    paint.shader = null;
    paint.color = AppColors.primaryGreen.withOpacity(0.15);
    canvas.drawCircle(Offset(size.width * 0.92, size.height * 0.12), 4, paint);

    // Added Shape: Cross near triangle
    _drawCross(
      canvas,
      Offset(size.width * 0.8, size.height * 0.18),
      8,
      AppColors.primaryGreen.withOpacity(0.2),
    );

    // 2. Hollow Hexagon (Bottom Left)
    final center2 = Offset(size.width * 0.15, size.height * 0.75);

    // Simplifed Polygon (Hexagon-ish)
    final hexPath = Path();
    hexPath.moveTo(center2.dx + 40, center2.dy);
    hexPath.lineTo(center2.dx + 20, center2.dy + 35);
    hexPath.lineTo(center2.dx - 20, center2.dy + 35);
    hexPath.lineTo(center2.dx - 40, center2.dy);
    hexPath.lineTo(center2.dx - 20, center2.dy - 35);
    hexPath.lineTo(center2.dx + 20, center2.dy - 35);
    hexPath.close();

    strokePaint.color = AppColors.primaryGreen.withOpacity(0.2);
    canvas.drawPath(hexPath, strokePaint);

    // 3. Scattered Shapes (Increased Count)

    // Crosses
    _drawCross(
      canvas,
      Offset(size.width * 0.15, size.height * 0.2),
      15,
      AppColors.primaryGreen.withOpacity(0.25),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.9, size.height * 0.6),
      10,
      AppColors.primaryGreen.withOpacity(0.2),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.5, size.height * 0.85),
      12,
      AppColors.primaryGreen.withOpacity(0.2),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.35, size.height * 0.45),
      8,
      AppColors.primaryGreen.withOpacity(0.22),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.75, size.height * 0.15),
      14,
      AppColors.primaryGreen.withOpacity(0.18),
    );

    // Filled Circles
    paint.shader = null;
    paint.color = AppColors.primaryGreen.withOpacity(0.2);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.15), 6, paint);

    paint.color = AppColors.primaryGreen.withOpacity(0.15);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 18, paint);

    paint.color = AppColors.primaryGreen.withOpacity(0.18);
    canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.65), 4, paint);

    // Hollow Circles
    strokePaint.color = AppColors.primaryGreen.withOpacity(0.25);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.8),
      25,
      strokePaint,
    );

    strokePaint.color = AppColors.primaryGreen.withOpacity(0.2);
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.3),
      15,
      strokePaint,
    );

    // Diamond - Moved to Bottom
    _drawDiamond(
      canvas,
      Offset(size.width * 0.5, size.height * 0.9),
      15,
      AppColors.primaryGreen.withOpacity(0.25),
      true,
    );

    // 5. Connecting Lines
    final linePaint =
        Paint()
          ..color = AppColors.primaryGreen.withOpacity(0.15)
          ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.2),
      Offset(size.width * 0.25, size.height * 0.3),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.8),
      Offset(size.width * 0.9, size.height * 0.6),
      linePaint,
    );
    // 6. Additional Scattered Shapes (High Density)

    // More Triangles
    _drawTriangle(
      canvas,
      Offset(size.width * 0.1, size.height * 0.4),
      15,
      AppColors.primaryGreen.withOpacity(0.15),
    );
    _drawTriangle(
      canvas,
      Offset(size.width * 0.7, size.height * 0.9),
      10,
      AppColors.primaryGreen.withOpacity(0.18),
    );
    _drawTriangle(
      canvas,
      Offset(size.width * 0.3, size.height * 0.1),
      8,
      AppColors.primaryGreen.withOpacity(0.16),
    );

    // More Crosses
    _drawCross(
      canvas,
      Offset(size.width * 0.65, size.height * 0.4),
      10,
      AppColors.primaryGreen.withOpacity(0.2),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.25, size.height * 0.85),
      12,
      AppColors.primaryGreen.withOpacity(0.15),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.05, size.height * 0.25),
      8,
      AppColors.primaryGreen.withOpacity(0.2),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.95, size.height * 0.5),
      14,
      AppColors.primaryGreen.withOpacity(0.18),
    );

    // More Dots
    paint.color = AppColors.primaryGreen.withOpacity(0.15);
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.35), 5, paint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.65), 7, paint);
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.95), 4, paint);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.05), 6, paint);

    // More Diamonds
    _drawDiamond(
      canvas,
      Offset(size.width * 0.9, size.height * 0.15),
      12,
      AppColors.primaryGreen.withOpacity(0.18),
      true,
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.2, size.height * 0.55),
      10,
      AppColors.primaryGreen.withOpacity(0.16),
      false,
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.6, size.height * 0.8),
      15,
      AppColors.primaryGreen.withOpacity(0.17),
      true,
    );

    // More connecting lines
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.4),
      Offset(size.width * 0.05, size.height * 0.25),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.9),
      Offset(size.width * 0.6, size.height * 0.8),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.9, size.height * 0.15),
      Offset(size.width * 0.95, size.height * 0.5),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.55, size.height * 0.35),
      Offset(size.width * 0.65, size.height * 0.4),
      linePaint,
    );
  }

  void _drawCross(Canvas canvas, Offset center, double size, Color color) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx - size / 2, center.dy),
      Offset(center.dx + size / 2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - size / 2),
      Offset(center.dx, center.dy + size / 2),
      paint,
    );
  }

  void _drawTriangle(Canvas canvas, Offset center, double size, Color color) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx + size, center.dy + size);
    path.lineTo(center.dx - size, center.dy + size);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawDiamond(
    Canvas canvas,
    Offset center,
    double size,
    Color color,
    bool filled,
  ) {
    final paint =
        Paint()
          ..color = color
          ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = filled ? 0 : 1.5;

    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx + size, center.dy);
    path.lineTo(center.dx, center.dy + size);
    path.lineTo(center.dx - size, center.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

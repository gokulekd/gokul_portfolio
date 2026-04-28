import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class FAQItem {
  final String number;
  final String question;
  final String answer;

  const FAQItem({
    required this.number,
    required this.question,
    required this.answer,
  });
}

class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  int? _expandedIndex;

  static const List<FAQItem> _faqItems = [
    FAQItem(
      number: "01",
      question: "What is your typical project timeline?",
      answer:
          "Project timelines vary depending on the scope and complexity. A typical website project takes 2-4 weeks from discovery to launch. This includes design, development, content integration, and testing phases. I'll provide a detailed timeline during our initial consultation based on your specific requirements.",
    ),
    FAQItem(
      number: "02",
      question: "Do you offer ongoing maintenance and support?",
      answer:
          "Yes, I offer ongoing maintenance and support packages to keep your website running smoothly. This includes regular updates, security patches, content updates, and technical support. We can discuss a maintenance plan that fits your needs and budget.",
    ),
    FAQItem(
      number: "03",
      question: "Can you work with existing brand guidelines?",
      answer:
          "Absolutely! I can work with your existing brand guidelines, including colors, fonts, logos, and design elements. I'll ensure your new website aligns perfectly with your brand identity while bringing fresh, modern design solutions to enhance your online presence.",
    ),
    FAQItem(
      number: "04",
      question: "How do you handle revisions and feedback?",
      answer:
          "I believe in collaborative design and development. During the project, I'll share work-in-progress updates and incorporate your feedback. Each project includes a set number of revision rounds to ensure we get everything just right. Additional revisions can be arranged if needed.",
    ),
  ];

  void _toggleExpansion(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
      child: Stack(
        children: [
          // Background decorative elements
          Positioned.fill(child: CustomPaint(painter: _BackgroundPainter())),
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 80,
              horizontal: isMobile ? 24 : 0,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Section identifier
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "{06} – FAQ",
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              color: colorScheme.onSurface,
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
                      Text(
                        "Got Questions?",
                        style: GoogleFonts.manrope(
                          fontSize: isMobile ? 40 : 60,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 60),
                      // FAQ Items
                      ...List.generate(
                        _faqItems.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildFAQItem(
                            _faqItems[index],
                            index,
                            isMobile,
                          ),
                        ),
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
  }

  Widget _buildFAQItem(FAQItem item, int index, bool isMobile) {
    final isExpanded = _expandedIndex == index;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.surfaceContainerHighest,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Question row
          InkWell(
            onTap: () => _toggleExpansion(index),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Number and question
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "${item.number}/",
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.45,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.question,
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Expand/collapse button
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AnimatedRotation(
                      turns: isExpanded ? 0.125 : 0, // 45 degrees when expanded
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.add,
                        color: colorScheme.surface,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Answer (expandable)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Text(
                item.answer,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.6,
                ),
              ),
            ),
            crossFadeState:
                isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

// Custom painter for background decorative elements - Adapted for White Background
// Custom painter for geometric background elements
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
        AppColors.primaryGreen.withValues(alpha: 0.25),
        AppColors.primaryGreen.withValues(alpha: 0.8),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path1, paint);

    // Added Shape: Small Circle near triangle
    paint.shader = null;
    paint.color = AppColors.primaryGreen.withValues(alpha: 0.3);
    canvas.drawCircle(Offset(size.width * 0.92, size.height * 0.12), 4, paint);

    // Added Shape: Cross near triangle
    _drawCross(
      canvas,
      Offset(size.width * 0.8, size.height * 0.18),
      8,
      AppColors.primaryGreen.withValues(alpha: 0.4),
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

    strokePaint.color = AppColors.primaryGreen.withValues(alpha: 0.35);
    canvas.drawPath(hexPath, strokePaint);

    // 3. Scattered Shapes (Increased Count)

    // Crosses
    _drawCross(
      canvas,
      Offset(size.width * 0.15, size.height * 0.2),
      15,
      AppColors.primaryGreen.withValues(alpha: 0.6),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.9, size.height * 0.6),
      10,
      AppColors.primaryGreen.withValues(alpha: 0.5),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.5, size.height * 0.85),
      12,
      AppColors.primaryGreen.withValues(alpha: 0.5),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.35, size.height * 0.45),
      8,
      AppColors.primaryGreen.withValues(alpha: 0.55),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.75, size.height * 0.15),
      14,
      AppColors.primaryGreen.withValues(alpha: 0.45),
    );

    // Filled Circles
    paint.shader = null;
    paint.color = AppColors.primaryGreen.withValues(alpha: 0.4);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.15), 6, paint);

    paint.color = AppColors.primaryGreen.withValues(alpha: 0.38);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 18, paint);

    paint.color = AppColors.primaryGreen.withValues(alpha: 0.42);
    canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.65), 4, paint);

    // Hollow Circles
    strokePaint.color = AppColors.primaryGreen.withValues(alpha: 0.45);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.8),
      25,
      strokePaint,
    );

    strokePaint.color = AppColors.primaryGreen.withValues(alpha: 0.4);
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
      AppColors.primaryGreen.withValues(alpha: 0.5),
      true,
    );

    // 5. Connecting Lines
    final linePaint =
        Paint()
          ..color = AppColors.primaryGreen.withValues(alpha: 0.3)
          ..strokeWidth = 1.5;

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
      AppColors.primaryGreen.withValues(alpha: 0.4),
    );
    _drawTriangle(
      canvas,
      Offset(size.width * 0.7, size.height * 0.9),
      10,
      AppColors.primaryGreen.withValues(alpha: 0.45),
    );
    _drawTriangle(
      canvas,
      Offset(size.width * 0.3, size.height * 0.1),
      8,
      AppColors.primaryGreen.withValues(alpha: 0.42),
    );

    // More Crosses
    _drawCross(
      canvas,
      Offset(size.width * 0.65, size.height * 0.4),
      10,
      AppColors.primaryGreen.withValues(alpha: 0.48),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.25, size.height * 0.85),
      12,
      AppColors.primaryGreen.withValues(alpha: 0.4),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.05, size.height * 0.25),
      8,
      AppColors.primaryGreen.withValues(alpha: 0.5),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.95, size.height * 0.5),
      14,
      AppColors.primaryGreen.withValues(alpha: 0.45),
    );

    // More Dots
    paint.color = AppColors.primaryGreen.withValues(alpha: 0.38);
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.35), 5, paint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.65), 7, paint);
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.95), 4, paint);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.05), 6, paint);

    // More Diamonds
    _drawDiamond(
      canvas,
      Offset(size.width * 0.9, size.height * 0.15),
      12,
      AppColors.primaryGreen.withValues(alpha: 0.45),
      true,
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.2, size.height * 0.55),
      10,
      AppColors.primaryGreen.withValues(alpha: 0.4),
      false,
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.6, size.height * 0.8),
      15,
      AppColors.primaryGreen.withValues(alpha: 0.42),
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

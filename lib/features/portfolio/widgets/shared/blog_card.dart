import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogCard extends StatelessWidget {
  final String title;
  final String excerpt;
  final String imageUrl;
  final DateTime publishDate;
  final List<String> tags;

  const BlogCard({
    super.key,
    required this.title,
    required this.excerpt,
    required this.imageUrl,
    required this.publishDate,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  excerpt,
                  style: GoogleFonts.manrope(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${publishDate.day}/${publishDate.month}/${publishDate.year}',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children:
                          tags
                              .take(2)
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    tag,
                                    style: GoogleFonts.manrope(fontSize: 12),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.withValues(alpha: 0.1)
          ..style = PaintingStyle.fill;

    // Create floating particles
    for (int i = 0; i < 20; i++) {
      final x = (i * 50.0) % size.width;
      final y = (i * 30.0) % size.height;
      final radius = 2.0 + (i % 3);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Add some connecting lines
    final linePaint =
        Paint()
          ..color = Colors.grey.withValues(alpha: 0.05)
          ..strokeWidth = 1.0;

    for (int i = 0; i < 10; i++) {
      final startX = (i * 80.0) % size.width;
      final startY = (i * 60.0) % size.height;
      final endX = ((i + 1) * 80.0) % size.width;
      final endY = ((i + 1) * 60.0) % size.height;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

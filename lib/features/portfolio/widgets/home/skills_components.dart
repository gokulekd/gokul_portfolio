import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';

class SkillsBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final strokePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    // 1. Cluster (Top Right)
    // Replaced Triangle with Code Syntax Shape < /> and Hollow Hexagon

    // Code Syntax < />
    final codeSlashPaint =
        Paint()
          ..color = AppColors.primaryGreen.withValues(alpha: 0.78)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final codeSlashPath = Path();
    // <
    codeSlashPath.moveTo(size.width * 0.88, size.height * 0.18);
    codeSlashPath.lineTo(size.width * 0.87, size.height * 0.20);
    codeSlashPath.lineTo(size.width * 0.88, size.height * 0.22);
    // /
    codeSlashPath.moveTo(size.width * 0.89, size.height * 0.22);
    codeSlashPath.lineTo(size.width * 0.91, size.height * 0.18);
    // >
    codeSlashPath.moveTo(size.width * 0.92, size.height * 0.18);
    codeSlashPath.lineTo(size.width * 0.93, size.height * 0.20);
    codeSlashPath.lineTo(size.width * 0.92, size.height * 0.22);

    canvas.drawPath(codeSlashPath, codeSlashPaint);

    // Small Hollow Pentagon
    _drawPolygon(
      canvas,
      Offset(size.width * 0.94, size.height * 0.15),
      12,
      5, // Pentagon
      AppColors.primaryGreen.withValues(alpha: 0.67),
      false,
    );

    // Added Shape: Small Circle near triangle
    paint.shader = null;
    paint.color = AppColors.primaryGreen.withValues(alpha: 0.49);
    canvas.drawCircle(Offset(size.width * 0.92, size.height * 0.12), 4, paint);

    // Added Shape: Cross near triangle
    _drawCross(
      canvas,
      Offset(size.width * 0.8, size.height * 0.18),
      8,
      AppColors.primaryGreen.withValues(alpha: 0.40),
    );

    // 2. Hollow Hexagon (Bottom Left)
    final center2 = Offset(size.width * 0.1, size.height * 0.92);

    // Simplifed Polygon (Hexagon-ish)
    final hexPath = Path();
    hexPath.moveTo(center2.dx + 40, center2.dy);
    hexPath.lineTo(center2.dx + 20, center2.dy + 35);
    hexPath.lineTo(center2.dx - 20, center2.dy + 35);
    hexPath.lineTo(center2.dx - 40, center2.dy);
    hexPath.lineTo(center2.dx - 20, center2.dy - 35);
    hexPath.lineTo(center2.dx + 20, center2.dy - 35);
    hexPath.close();

    strokePaint.color = AppColors.primaryGreen.withValues(alpha: 0.5);
    canvas.drawPath(hexPath, strokePaint);

    // 3. Scattered Shapes (Significantly Increased Count & Distribution)

    // --- LEFT SIDE ---
    _drawCross(
      canvas,
      Offset(size.width * 0.05, size.height * 0.2),
      12,
      AppColors.primaryGreen.withValues(alpha: 0.3),
    );
    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.25),
      4,
      paint..color = AppColors.primaryGreen.withValues(alpha: 0.4),
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.12, size.height * 0.4),
      8,
      AppColors.primaryGreen.withValues(alpha: 0.25),
      false,
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.04, size.height * 0.6),
      10,
      AppColors.primaryGreen.withValues(alpha: 0.35),
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.8),
      6,
      paint..color = AppColors.primaryGreen.withValues(alpha: 0.2),
    );

    // --- RIGHT SIDE ---
    _drawCross(
      canvas,
      Offset(size.width * 0.95, size.height * 0.3),
      14,
      AppColors.primaryGreen.withValues(alpha: 0.3),
    );
    canvas.drawCircle(
      Offset(size.width * 0.92, size.height * 0.45),
      8,
      paint..color = AppColors.primaryGreen.withValues(alpha: 0.25),
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.96, size.height * 0.65),
      10,
      AppColors.primaryGreen.withValues(alpha: 0.3),
      true,
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.9, size.height * 0.85),
      12,
      AppColors.primaryGreen.withValues(alpha: 0.4),
    );

    // --- TOP AREA ---
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.05),
      5,
      paint..color = AppColors.primaryGreen.withValues(alpha: 0.3),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.5, size.height * 0.08),
      10,
      AppColors.primaryGreen.withValues(alpha: 0.25),
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.7, size.height * 0.06),
      6,
      AppColors.primaryGreen.withValues(alpha: 0.35),
      false,
    );

    // --- BOTTOM AREA ---
    _drawCross(
      canvas,
      Offset(size.width * 0.2, size.height * 0.95),
      10,
      AppColors.primaryGreen.withValues(alpha: 0.3),
    );
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.92),
      7,
      paint..color = AppColors.primaryGreen.withValues(alpha: 0.2),
    );
    _drawDiamond(
      canvas,
      Offset(size.width * 0.6, size.height * 0.96),
      9,
      AppColors.primaryGreen.withValues(alpha: 0.28),
      true,
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.8, size.height * 0.93),
      12,
      AppColors.primaryGreen.withValues(alpha: 0.32),
    );

    // --- CENTER/RANDOM SCATTER (Existing logic, slightly adjusted) ---
    _drawCross(
      canvas,
      Offset(size.width * 0.15, size.height * 0.2),
      15,
      AppColors.primaryGreen.withValues(alpha: 0.25),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.5, size.height * 0.85),
      12,
      AppColors.primaryGreen.withValues(alpha: 0.6),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.35, size.height * 0.45),
      8,
      AppColors.primaryGreen.withValues(alpha: 0.50),
    );
    _drawCross(
      canvas,
      Offset(size.width * 0.75, size.height * 0.15),
      14,
      AppColors.primaryGreen.withValues(alpha: 0.70),
    );

    // Filled Circles
    paint.shader = null;
    paint.color = AppColors.primaryGreen.withValues(alpha: 0.4);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.15), 6, paint);

    paint.color = AppColors.primaryGreen.withValues(alpha: 0.58);
    canvas.drawCircle(Offset(size.width * 0.05, size.height * 0.5), 18, paint);

    paint.color = AppColors.primaryGreen.withValues(alpha: 0.40);
    canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.65), 4, paint);

    // Hollow Circles
    strokePaint.color = AppColors.primaryGreen.withValues(alpha: 0.69);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.8),
      25,
      strokePaint,
    );

    strokePaint.color = AppColors.primaryGreen.withValues(alpha: 0.78);
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.3),
      15,
      strokePaint,
    );

    // Diamond - Moved to Right of Bottom Center
    _drawDiamond(
      canvas,
      Offset(size.width * 0.7, size.height * 0.92), // Moved from 0.5 to 0.7
      15,
      AppColors.primaryGreen.withValues(alpha: 0.45),
      true,
    );

    // 5. Connecting Lines
    final linePaint =
        Paint()
          ..color = AppColors.primaryGreen.withValues(alpha: 0.3) // Reduced opacity
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
    // New Lines
    canvas.drawLine(
      Offset(size.width * 0.05, size.height * 0.5),
      Offset(size.width * 0.12, size.height * 0.4),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.92, size.height * 0.45),
      Offset(size.width * 0.96, size.height * 0.65),
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

  void _drawPolygon(
    Canvas canvas,
    Offset center,
    double radius,
    int sides,
    Color color,
    bool filled,
  ) {
    if (sides < 3) return;

    final paint =
        Paint()
          ..color = color
          ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = filled ? 0 : 1.5;

    final path = Path();
    final angle = (math.pi * 2) / sides;

    // Start from top (-90 degrees) or right (0 degrees)
    // Using top (-90) for standard orientation
    final startAngle = -math.pi / 2;

    for (int i = 0; i < sides; i++) {
      double currentAngle = startAngle + (angle * i);
      double x = center.dx + radius * math.cos(currentAngle);
      double y = center.dy + radius * math.sin(currentAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';

class SatisfactionPainter extends CustomPainter {
  final Color color;

  SatisfactionPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

    final fillPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Use the shortest side (height in this case as width is usually larger)
    // to maintain aspect ratio
    final sizeRef = size.height;
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Main Face Outline (Abstract Blob or Circle)
    final facePath = Path();
    facePath.addOval(
      Rect.fromCenter(
        center: center,
        width: sizeRef * 0.9,
        height: sizeRef * 0.9,
      ),
    );

    // Draw subtle gradient fill for the face background
    final bgPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.0)],
          ).createShader(
            Rect.fromCircle(center: center, radius: sizeRef * 0.45),
          )
          ..style = PaintingStyle.fill;

    canvas.drawPath(facePath, bgPaint);
    canvas.drawPath(facePath, strokePaint);

    // 2. Left Eye (Solid Circle)
    // Position relative to center
    canvas.drawCircle(
      Offset(center.dx - sizeRef * 0.15, size.height * 0.4),
      6,
      fillPaint,
    );

    // 3. Right Eye (Winking Star/Diamond)
    final starPath = Path();
    final starCenter = Offset(center.dx + sizeRef * 0.15, size.height * 0.4);
    final radius = 10.0;

    starPath.moveTo(starCenter.dx, starCenter.dy - radius); // Top
    starPath.quadraticBezierTo(
      starCenter.dx + 2,
      starCenter.dy - 2,
      starCenter.dx + radius,
      starCenter.dy,
    ); // Right
    starPath.quadraticBezierTo(
      starCenter.dx + 2,
      starCenter.dy + 2,
      starCenter.dx,
      starCenter.dy + radius,
    ); // Bottom
    starPath.quadraticBezierTo(
      starCenter.dx - 2,
      starCenter.dy + 2,
      starCenter.dx - radius,
      starCenter.dy,
    ); // Left
    starPath.quadraticBezierTo(
      starCenter.dx - 2,
      starCenter.dy - 2,
      starCenter.dx,
      starCenter.dy - radius,
    ); // Back to Top

    canvas.drawPath(starPath, fillPaint);

    // 4. Smile (Confident Curve)
    final smilePath = Path();
    smilePath.moveTo(center.dx - sizeRef * 0.2, size.height * 0.65);
    smilePath.quadraticBezierTo(
      center.dx,
      size.height * 0.85,
      center.dx + sizeRef * 0.2,
      size.height * 0.65,
    );
    canvas.drawPath(smilePath, strokePaint..strokeWidth = 4);

    // 5. Orbiting Decoration (Satellite)
    canvas.drawCircle(
      Offset(center.dx + sizeRef * 0.35, size.height * 0.15),
      4,
      fillPaint..color = color.withValues(alpha: 0.6),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GrowthPainter extends CustomPainter {
  final Color color;

  GrowthPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [color.withValues(alpha: 0.4), color.withValues(alpha: 0.0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;

    // Smooth rising curve
    final path = Path();
    path.moveTo(0, size.height * 0.9);
    path.cubicTo(
      size.width * 0.3,
      size.height * 0.9,
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.cubicTo(
      size.width * 0.7,
      size.height * 0.5,
      size.width * 0.7,
      size.height * 0.1,
      size.width,
      size.height * 0.1,
    );

    // Draw the line
    canvas.drawPath(path, strokePaint);

    // Draw fill below the line
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Add nodes/milestones
    final nodePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      5,
      nodePaint,
    );
    canvas.drawCircle(Offset(size.width, size.height * 0.1), 6, nodePaint);

    // Abstract halo around top node
    final haloPaint =
        Paint()
          ..color = color.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    canvas.drawCircle(Offset(size.width, size.height * 0.1), 12, haloPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CheckPainter extends CustomPainter {
  final Color color;

  CheckPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    // Constrain dimensions to maintain aspect ratio
    final ref = size.height;
    final cx = size.width / 2;

    // Draw stacked floating layers (Interfaces)
    // Using simple scalars on 'ref' to keep shapes proportional

    // Layer 3 (Bottom)
    _drawLayer(
      canvas,
      Offset(cx, size.height * 0.75),
      ref * 1.0,
      ref * 0.6,
      fillPaint..color = color.withValues(alpha: 0.1),
      null,
    );

    // Layer 2 (Middle)
    _drawLayer(
      canvas,
      Offset(cx, size.height * 0.6),
      ref * 1.2,
      ref * 0.6,
      fillPaint..color = color.withValues(alpha: 0.2),
      strokePaint..color = color.withValues(alpha: 0.3),
    );

    // Layer 1 (Top - Focus)
    final topLayerCenter = Offset(cx, size.height * 0.45);
    _drawLayer(
      canvas,
      topLayerCenter,
      ref * 1.4,
      ref * 0.7,
      fillPaint..color = color.withValues(alpha: 0.05), // Glassy hook
      strokePaint
        ..color = color
        ..strokeWidth = 3,
    );

    // Content on Top Layer (Project "Hero" Section + Button)
    // Actually, let's draw a symbol ON the top layer
    final symbolPath = Path();
    symbolPath.moveTo(topLayerCenter.dx - 15, topLayerCenter.dy - 10);
    symbolPath.lineTo(topLayerCenter.dx - 5, topLayerCenter.dy + 5);
    symbolPath.lineTo(topLayerCenter.dx + 15, topLayerCenter.dy - 15);

    canvas.drawPath(symbolPath, strokePaint..strokeWidth = 4);

    // A small "circle" dot to the left
    canvas.drawCircle(
      Offset(topLayerCenter.dx - 30, topLayerCenter.dy - 30),
      3,
      fillPaint..color = color,
    );
    canvas.drawCircle(
      Offset(topLayerCenter.dx - 20, topLayerCenter.dy - 30),
      3,
      fillPaint..color = color,
    );
  }

  void _drawLayer(
    Canvas canvas,
    Offset center,
    double width,
    double height,
    Paint fill,
    Paint? stroke,
  ) {
    // Drawing an isometric-like plane
    final path = Path();
    final halfW = width / 2;
    final halfH = height / 2;

    // Slight perspective skew
    path.moveTo(center.dx - halfW, center.dy); // Left
    path.lineTo(center.dx, center.dy - halfH * 0.6); // Top
    path.lineTo(center.dx + halfW, center.dy); // Right
    path.lineTo(center.dx, center.dy + halfH * 0.6); // Bottom
    path.close();

    canvas.drawPath(path, fill);
    if (stroke != null) {
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

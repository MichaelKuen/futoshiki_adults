import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../providers/settings_provider.dart';

/// Which way the symbol's tip points (always toward the smaller cell).
enum PointDir { left, right, up, down }

/// An inequality sign drawn with a painter instead of a font glyph, so it
/// scales with the cell and never needs a fallback font download on web.
class ConstraintSymbol extends StatelessWidget {
  const ConstraintSymbol({
    super.key,
    required this.dir,
    required this.style,
    required this.color,
    required this.size,
  });

  final PointDir dir;
  final ConstraintStyle style;
  final Color color;
  final double size;

  /// Horizontal pair: is the left cell smaller?
  static PointDir horizontal(bool isLessThan) =>
      isLessThan ? PointDir.left : PointDir.right;

  /// Vertical pair: is the top cell smaller?
  static PointDir vertical(bool isLessThan) =>
      isLessThan ? PointDir.up : PointDir.down;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _SymbolPainter(dir, style, color)),
    );
  }
}

class _SymbolPainter extends CustomPainter {
  _SymbolPainter(this.dir, this.style, this.color);

  final PointDir dir;
  final ConstraintStyle style;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, s * 0.13)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    // Shapes are drawn pointing left; rotate (clockwise) to the target.
    canvas.rotate(switch (dir) {
      PointDir.left => 0,
      PointDir.up => math.pi / 2,
      PointDir.right => math.pi,
      PointDir.down => -math.pi / 2,
    });
    Offset p(double x, double y) => Offset((x - 0.5) * s, (y - 0.5) * s);

    final path = Path();
    switch (style) {
      case ConstraintStyle.classic:
        path
          ..moveTo(p(0.70, 0.16).dx, p(0.70, 0.16).dy)
          ..lineTo(p(0.30, 0.50).dx, p(0.30, 0.50).dy)
          ..lineTo(p(0.70, 0.84).dx, p(0.70, 0.84).dy);
      case ConstraintStyle.arrows:
        path
          ..moveTo(p(0.85, 0.50).dx, p(0.85, 0.50).dy)
          ..lineTo(p(0.18, 0.50).dx, p(0.18, 0.50).dy)
          ..moveTo(p(0.46, 0.22).dx, p(0.46, 0.22).dy)
          ..lineTo(p(0.18, 0.50).dx, p(0.18, 0.50).dy)
          ..lineTo(p(0.46, 0.78).dx, p(0.46, 0.78).dy);
      case ConstraintStyle.triangles:
        path
          ..moveTo(p(0.22, 0.50).dx, p(0.22, 0.50).dy)
          ..lineTo(p(0.76, 0.20).dx, p(0.76, 0.20).dy)
          ..lineTo(p(0.76, 0.80).dx, p(0.76, 0.80).dy)
          ..close();
    }
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SymbolPainter old) =>
      old.dir != dir || old.style != style || old.color != color;
}

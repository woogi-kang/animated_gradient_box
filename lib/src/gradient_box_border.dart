part of '../animated_gradient_box.dart';

/// A custom [BoxBorder] that paints a gradient border around a box.
/// This border can be used to create visually appealing UI elements
/// with animated gradient effects.
class GradientBoxBorder extends BoxBorder {
  /// Creates a gradient border with the specified [gradient] and [width].
  const GradientBoxBorder({
    required this.gradient,
    this.width = 1.0,
  });

  /// The gradient to use when painting the border.
  final Gradient gradient;

  /// The width of the border.
  final double width;

  @override
  BorderSide get bottom => BorderSide.none;

  @override
  BorderSide get top => BorderSide.none;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    switch (shape) {
      case BoxShape.circle:
        assert(
          borderRadius == null,
          'A borderRadius can only be given for rectangular boxes.',
        );
        _paintCircle(canvas, rect);
      case BoxShape.rectangle:
        if (borderRadius != null) {
          _paintRRect(canvas, rect, borderRadius);
          return;
        }
        _paintRect(canvas, rect);
    }
  }

  void _paintRect(Canvas canvas, Rect rect) {
    final adjustedRect = rect.deflate(width / 2);
    canvas.drawRect(adjustedRect, _createGradientPaint(rect));
  }

  void _paintRRect(Canvas canvas, Rect rect, BorderRadius borderRadius) {
    final adjustedRect = borderRadius.toRRect(rect).deflate(width / 2);
    canvas.drawRRect(adjustedRect, _createGradientPaint(rect));
  }

  void _paintCircle(Canvas canvas, Rect rect) {
    final paint = _createGradientPaint(rect);
    final radius = (rect.shortestSide - width) / 2.0;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  ShapeBorder scale(double t) => GradientBoxBorder(
        gradient: gradient,
        width: width * t,
      );

  Paint _createGradientPaint(Rect rect) {
    return Paint()
      ..strokeWidth = width
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GradientBoxBorder &&
        other.gradient == gradient &&
        other.width == width;
  }

  @override
  int get hashCode => Object.hash(gradient, width);
} 

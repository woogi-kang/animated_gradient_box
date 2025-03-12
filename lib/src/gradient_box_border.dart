part of '../animated_gradient_box.dart';

/// A custom [BoxBorder] that paints a gradient border around a box.
/// This border can be used to create visually appealing UI elements
/// with animated gradient effects.
class GradientBoxBorder extends BoxBorder {
  /// Creates a gradient border with the specified [gradient] and [width].
  /// 
  /// The [borderProgress] parameter controls where along the border the segment is drawn,
  /// ranging from 0.0 to 1.0 (representing positions along the perimeter).
  /// 
  /// The [segmentLength] parameter controls the length of the visible border segment
  /// as a fraction of the total perimeter (0.0 to 1.0).
  const GradientBoxBorder({
    required this.gradient,
    this.width = 1.0,
    this.borderProgress = 1.0,
    this.segmentLength = 1.0,
  });

  /// The gradient to use when painting the border.
  final Gradient gradient;

  /// The width of the border.
  final double width;

  /// Controls the position of the border segment along the perimeter (0.0 to 1.0).
  /// 
  /// A value of 0.0 positions the segment at the start (top-left).
  /// A value of 0.5 positions the segment halfway around the perimeter.
  /// A value of 1.0 positions the segment back at the start.
  final double borderProgress;

  /// Controls the length of the visible border segment as a fraction of the total perimeter.
  /// 
  /// A value of 0.1 means 10% of the border is visible.
  /// A value of 0.5 means 50% of the border is visible.
  /// A value of 1.0 (default) means the entire border is visible.
  final double segmentLength;

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
    
    // If segmentLength is 1.0 (100%), draw the entire border
    if (segmentLength >= 1.0) {
      canvas.drawRect(adjustedRect, _createGradientPaint(rect));
      return;
    }
    
    // Draw partial border (segment)
    final paint = _createGradientPaint(rect);
    final path = Path();
    
    // Calculate the total perimeter
    final totalLength = adjustedRect.width * 2 + adjustedRect.height * 2;
    final segmentActualLength = totalLength * segmentLength;
    
    // Calculate the start position along the perimeter
    final startDistance = totalLength * borderProgress;
    var currentDistance = 0.0;
    
    // Define the four sides of the rectangle
    final sides = [
      // Top side: left to right
      (
        start: Offset(adjustedRect.left, adjustedRect.top),
        end: Offset(adjustedRect.right, adjustedRect.top),
        length: adjustedRect.width
      ),
      // Right side: top to bottom
      (
        start: Offset(adjustedRect.right, adjustedRect.top),
        end: Offset(adjustedRect.right, adjustedRect.bottom),
        length: adjustedRect.height
      ),
      // Bottom side: right to left
      (
        start: Offset(adjustedRect.right, adjustedRect.bottom),
        end: Offset(adjustedRect.left, adjustedRect.bottom),
        length: adjustedRect.width
      ),
      // Left side: bottom to top
      (
        start: Offset(adjustedRect.left, adjustedRect.bottom),
        end: Offset(adjustedRect.left, adjustedRect.top),
        length: adjustedRect.height
      ),
    ];
    
    // Find the starting side and position
    int startSideIndex = 0;
    double startSideOffset = 0.0;
    double distanceAlong = startDistance;
    
    // Loop to find which side the start position is on
    for (int i = 0; i < sides.length; i++) {
      if (distanceAlong <= sides[i].length) {
        startSideIndex = i;
        startSideOffset = distanceAlong;
        break;
      }
      distanceAlong -= sides[i].length;
    }
    
    // Calculate the start point
    final startSide = sides[startSideIndex];
    final startPoint = Offset.lerp(
      startSide.start, 
      startSide.end, 
      startSideOffset / startSide.length
    )!;
    
    path.moveTo(startPoint.dx, startPoint.dy);
    
    // Draw the segment
    double remainingLength = segmentActualLength;
    int currentSideIndex = startSideIndex;
    double currentSideOffset = startSideOffset;
    
    while (remainingLength > 0 && currentSideIndex < sides.length + startSideIndex) {
      final currentSide = sides[currentSideIndex % sides.length];
      final sideRemainder = currentSide.length - currentSideOffset;
      
      if (remainingLength <= sideRemainder) {
        // The segment ends on this side
        final endPoint = Offset.lerp(
          currentSide.start, 
          currentSide.end, 
          (currentSideOffset + remainingLength) / currentSide.length
        )!;
        path.lineTo(endPoint.dx, endPoint.dy);
        break;
      } else {
        // Move to the end of this side
        path.lineTo(currentSide.end.dx, currentSide.end.dy);
        remainingLength -= sideRemainder;
        currentSideIndex++;
        currentSideOffset = 0.0; // Reset offset for the next side
      }
    }
    
    canvas.drawPath(path, paint);
  }

  void _paintRRect(Canvas canvas, Rect rect, BorderRadius borderRadius) {
    final adjustedRRect = borderRadius.toRRect(rect).deflate(width / 2);
    
    // If segmentLength is 1.0 (100%), draw the entire border
    if (segmentLength >= 1.0) {
      canvas.drawRRect(adjustedRRect, _createGradientPaint(rect));
      return;
    }
    
    // For RRect, use a simplified approach with path construction
    // Note: This is an approximation because accurate segment positioning
    // on an RRect is complex due to the corner radii
    
    // Draw partial RRect (segment)
    final paint = _createGradientPaint(rect);
    final path = Path();
    
    // Approximate the perimeter length
    final straightSides = (adjustedRRect.width - adjustedRRect.tlRadiusX - adjustedRRect.trRadiusX) * 2 +
                         (adjustedRRect.height - adjustedRRect.tlRadiusY - adjustedRRect.blRadiusY) * 2;
    
    final cornerArcs = math.pi * (adjustedRRect.tlRadiusX + adjustedRRect.trRadiusX + 
                                adjustedRRect.brRadiusX + adjustedRRect.blRadiusX) / 2;
    
    final totalLength = straightSides + cornerArcs;
    
    // Calculate the segment angle and position
    final segmentAngle = 2 * math.pi * segmentLength;
    final startAngle = 2 * math.pi * borderProgress - math.pi / 2; // Start from top
    
    // Draw an arc approximating the RRect segment
    final center = adjustedRRect.center;
    final radius = math.min(adjustedRRect.width, adjustedRRect.height) / 2;
    final outerRect = Rect.fromCircle(center: center, radius: radius);
    
    path.addArc(outerRect, startAngle, segmentAngle);
    canvas.drawPath(path, paint);
  }

  void _paintCircle(Canvas canvas, Rect rect) {
    final paint = _createGradientPaint(rect);
    final radius = (rect.shortestSide - width) / 2.0;
    
    // If segmentLength is 1.0 (100%), draw the entire circle
    if (segmentLength >= 1.0) {
      canvas.drawCircle(rect.center, radius, paint);
      return;
    }
    
    // Draw partial circle as an arc
    final circleRect = Rect.fromCircle(center: rect.center, radius: radius);
    final startAngle = 2 * math.pi * borderProgress - math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * segmentLength;
    
    final path = Path()
      ..addArc(circleRect, startAngle, sweepAngle);
    
    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) => GradientBoxBorder(
        gradient: gradient,
        width: width * t,
        borderProgress: borderProgress,
        segmentLength: segmentLength,
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
        other.width == width &&
        other.borderProgress == borderProgress &&
        other.segmentLength == segmentLength;
  }

  @override
  int get hashCode => Object.hash(gradient, width, borderProgress, segmentLength);
}

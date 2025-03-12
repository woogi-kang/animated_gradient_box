part of '../animated_gradient_box.dart';

/// A custom [BoxBorder] that paints a gradient border around a box.
///
/// This border supports both full borders and partial segments that can be animated
/// to create various effects like chasing lights, progress indicators, and more.
///
/// Key features:
/// * Gradient-filled borders using any [Gradient]
/// * Control over border width
/// * Partial border segments with controllable length
/// * Positioning of border segments along the perimeter
/// * Support for rectangles, rounded rectangles, and circles
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
  })  : assert(width >= 0.0, 'Border width must be non-negative'),
        assert(borderProgress >= 0.0 && borderProgress <= 1.0,
            'Border progress must be between 0.0 and 1.0'),
        assert(segmentLength >= 0.0 && segmentLength <= 1.0,
            'Segment length must be between 0.0 and 1.0');

  /// The gradient to use when painting the border.
  final Gradient gradient;

  /// The width of the border in logical pixels.
  ///
  /// Must be non-negative.
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
  BorderSide get left => BorderSide.none;

  @override
  BorderSide get right => BorderSide.none;

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
    if (width <= 0.0) return;

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

  /// Creates a Paint object configured for the gradient border.
  Paint _createGradientPaint(Rect rect) {
    return Paint()
      ..strokeWidth = width
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke;
  }

  /// Paints a rectangle border.
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
    final totalLength = _calculateRectPerimeter(adjustedRect);
    final segmentActualLength = totalLength * segmentLength;

    // Calculate the start position along the perimeter
    final startDistance = totalLength * borderProgress;

    // Define the sides of the rectangle
    final sides = _getRectSides(adjustedRect);

    // Find the starting side and position
    final startInfo = _findStartPositionOnRect(sides, startDistance);
    final startPoint = startInfo.$1;
    final startSideIndex = startInfo.$2;
    final startSideOffset = startInfo.$3;

    path.moveTo(startPoint.dx, startPoint.dy);

    // Draw the segment
    _drawRectSegment(
      path,
      sides,
      startSideIndex,
      startSideOffset,
      segmentActualLength,
    );

    canvas.drawPath(path, paint);
  }

  /// Calculates the perimeter of a rectangle.
  double _calculateRectPerimeter(Rect rect) {
    return rect.width * 2 + rect.height * 2;
  }

  /// Returns the four sides of a rectangle as tuples of (start point, end point, length).
  List<({Offset start, Offset end, double length})> _getRectSides(Rect rect) {
    return [
      // Top side: left to right
      (
        start: Offset(rect.left, rect.top),
        end: Offset(rect.right, rect.top),
        length: rect.width
      ),
      // Right side: top to bottom
      (
        start: Offset(rect.right, rect.top),
        end: Offset(rect.right, rect.bottom),
        length: rect.height
      ),
      // Bottom side: right to left
      (
        start: Offset(rect.right, rect.bottom),
        end: Offset(rect.left, rect.bottom),
        length: rect.width
      ),
      // Left side: bottom to top
      (
        start: Offset(rect.left, rect.bottom),
        end: Offset(rect.left, rect.top),
        length: rect.height
      ),
    ];
  }

  /// Finds the starting position on a rectangle based on the distance along the perimeter.
  /// Returns a tuple of (point, side index, offset along side).
  (Offset, int, double) _findStartPositionOnRect(
      List<({Offset start, Offset end, double length})> sides,
      double distance) {
    int sideIndex = 0;
    double distanceRemaining = distance;

    // Find which side the start position is on
    for (int i = 0; i < sides.length; i++) {
      if (distanceRemaining <= sides[i].length) {
        sideIndex = i;
        break;
      }
      distanceRemaining -= sides[i].length;
    }

    // Calculate the exact point
    final side = sides[sideIndex];
    final t = distanceRemaining / side.length;
    final point = Offset.lerp(side.start, side.end, t)!;

    return (point, sideIndex, distanceRemaining);
  }

  /// Draws a segment of a rectangle border.
  void _drawRectSegment(
    Path path,
    List<({Offset start, Offset end, double length})> sides,
    int startSideIndex,
    double startSideOffset,
    double segmentLength,
  ) {
    double remainingLength = segmentLength;
    int currentSideIndex = startSideIndex;
    double currentSideOffset = startSideOffset;

    while (remainingLength > 0 &&
        currentSideIndex < sides.length + startSideIndex) {
      final currentSide = sides[currentSideIndex % sides.length];
      final sideRemainder = currentSide.length - currentSideOffset;

      if (remainingLength <= sideRemainder) {
        // The segment ends on this side
        final endPoint = Offset.lerp(currentSide.start, currentSide.end,
            (currentSideOffset + remainingLength) / currentSide.length)!;
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
  }

  /// Paints a rounded rectangle border.
  void _paintRRect(Canvas canvas, Rect rect, BorderRadius borderRadius) {
    final adjustedRRect = borderRadius.toRRect(rect).deflate(width / 2);

    // If segmentLength is 1.0 (100%), draw the entire border
    if (segmentLength >= 1.0) {
      canvas.drawRRect(adjustedRRect, _createGradientPaint(rect));
      return;
    }

    // Draw partial border (segment)
    final paint = _createGradientPaint(rect);

    // For RRect, we'll use a simplified approach based on the shape
    if (_isRRectNearlyCircular(adjustedRRect)) {
      _paintCircularRRectSegment(canvas, adjustedRRect, paint);
    } else {
      _paintStandardRRectSegment(canvas, adjustedRRect, paint);
    }
  }

  /// Checks if an RRect is nearly circular (all corners have similar radii).
  bool _isRRectNearlyCircular(RRect rrect) {
    final avgRadius = (rrect.tlRadiusX +
            rrect.trRadiusX +
            rrect.brRadiusX +
            rrect.blRadiusX) /
        4;

    return (rrect.width - rrect.height).abs() < 1.0 &&
        (rrect.tlRadiusX - avgRadius).abs() < 1.0 &&
        (rrect.trRadiusX - avgRadius).abs() < 1.0 &&
        (rrect.brRadiusX - avgRadius).abs() < 1.0 &&
        (rrect.blRadiusX - avgRadius).abs() < 1.0;
  }

  /// Paints a segment of a nearly circular RRect.
  void _paintCircularRRectSegment(Canvas canvas, RRect rrect, Paint paint) {
    final center = rrect.center;
    final radius = math.min(rrect.width, rrect.height) / 2;
    final outerRect = Rect.fromCircle(center: center, radius: radius);

    final startAngle =
        2 * math.pi * borderProgress - math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * segmentLength;

    final path = Path()..addArc(outerRect, startAngle, sweepAngle);

    canvas.drawPath(path, paint);
  }

  /// Paints a segment of a standard (non-circular) RRect.
  void _paintStandardRRectSegment(Canvas canvas, RRect rrect, Paint paint) {
    // Approximate the perimeter length
    final straightSides =
        (rrect.width - rrect.tlRadiusX - rrect.trRadiusX) * 2 +
            (rrect.height - rrect.tlRadiusY - rrect.blRadiusY) * 2;

    final cornerArcs = math.pi *
        (rrect.tlRadiusX +
            rrect.trRadiusX +
            rrect.brRadiusX +
            rrect.blRadiusX) /
        2;

    final path = Path();

    // For standard RRect, use a simplified approach with path construction
    if (borderProgress < 0.25) {
      // Top portion
      _addRRectTopSegment(path, rrect, borderProgress * 4);
    } else if (borderProgress < 0.5) {
      // Top and right portion
      _addRRectTopSegment(path, rrect, 1.0);
      _addRRectRightSegment(path, rrect, (borderProgress - 0.25) * 4);
    } else if (borderProgress < 0.75) {
      // Top, right, and bottom portion
      _addRRectTopSegment(path, rrect, 1.0);
      _addRRectRightSegment(path, rrect, 1.0);
      _addRRectBottomSegment(path, rrect, (borderProgress - 0.5) * 4);
    } else {
      // Top, right, bottom, and left portion
      _addRRectTopSegment(path, rrect, 1.0);
      _addRRectRightSegment(path, rrect, 1.0);
      _addRRectBottomSegment(path, rrect, 1.0);
      _addRRectLeftSegment(path, rrect, (borderProgress - 0.75) * 4);
    }

    canvas.drawPath(path, paint);
  }

  /// Adds the top segment of an RRect to a path.
  void _addRRectTopSegment(Path path, RRect rrect, double progress) {
    final topWidth =
        (rrect.width - rrect.tlRadiusX - rrect.trRadiusX) * progress;
    path
      ..moveTo(rrect.left + rrect.tlRadiusX, rrect.top)
      ..lineTo(rrect.left + rrect.tlRadiusX + topWidth, rrect.top);
  }

  /// Adds the right segment of an RRect to a path.
  void _addRRectRightSegment(Path path, RRect rrect, double progress) {
    final rightHeight =
        (rrect.height - rrect.trRadiusY - rrect.brRadiusY) * progress;
    path
      ..moveTo(rrect.right - rrect.trRadiusX, rrect.top)
      ..lineTo(rrect.right, rrect.top + rrect.trRadiusY)
      ..lineTo(rrect.right, rrect.top + rrect.trRadiusY + rightHeight);
  }

  /// Adds the bottom segment of an RRect to a path.
  void _addRRectBottomSegment(Path path, RRect rrect, double progress) {
    final bottomWidth =
        (rrect.width - rrect.brRadiusX - rrect.blRadiusX) * progress;
    path
      ..moveTo(rrect.right, rrect.bottom - rrect.brRadiusY)
      ..lineTo(rrect.right - rrect.brRadiusX, rrect.bottom)
      ..lineTo(rrect.right - rrect.brRadiusX - bottomWidth, rrect.bottom);
  }

  /// Adds the left segment of an RRect to a path.
  void _addRRectLeftSegment(Path path, RRect rrect, double progress) {
    final leftHeight =
        (rrect.height - rrect.blRadiusY - rrect.tlRadiusY) * progress;
    path
      ..moveTo(rrect.left + rrect.blRadiusX, rrect.bottom)
      ..lineTo(rrect.left, rrect.bottom - rrect.blRadiusY)
      ..lineTo(rrect.left, rrect.bottom - rrect.blRadiusY - leftHeight);
  }

  /// Paints a circle border.
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
    final startAngle =
        2 * math.pi * borderProgress - math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * segmentLength;

    final path = Path()..addArc(circleRect, startAngle, sweepAngle);

    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) => GradientBoxBorder(
        gradient: gradient,
        width: width * t,
        borderProgress: borderProgress,
        segmentLength: segmentLength,
      );

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
  int get hashCode =>
      Object.hash(gradient, width, borderProgress, segmentLength);

  @override
  String toString() {
    return 'GradientBoxBorder(gradient: $gradient, width: ${width.toStringAsFixed(1)}, '
        'borderProgress: ${borderProgress.toStringAsFixed(2)}, '
        'segmentLength: ${segmentLength.toStringAsFixed(2)})';
  }
}

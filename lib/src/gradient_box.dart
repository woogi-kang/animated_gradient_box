part of '../animated_gradient_box.dart';

/// A widget that displays an animated gradient border.
///
/// This widget wraps a [Container] with a [GradientBoxBorder] that can be animated.
/// It provides a convenient way to add beautiful gradient borders to your UI elements
/// with various animation effects.
///
/// Key features:
/// * Gradient-filled animated borders
/// * Control over animation speed, curve, and direction
/// * Support for various shapes (rectangle, rounded rectangle, circle)
/// * Customizable border width
class GradientBox extends StatefulWidget {
  /// Creates a box with an animated gradient border.
  ///
  /// The [width] and [height] arguments specify the dimensions of the box.
  /// The [colors] argument specifies the colors to use in the gradient.
  ///
  /// The [animate] parameter controls whether the gradient animates.
  /// The [clockwise] parameter controls the direction of animation.
  const GradientBox({
    super.key,
    this.width,
    this.height,
    required this.colors,
    this.borderWidth = 2.0,
    this.animate = true,
    this.clockwise = true,
    this.animationDuration = const Duration(seconds: 2),
    this.curve = Curves.linear,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.segmentLength = 1.0,
    this.child,
  })  : assert(colors.length >= 2, 'Gradient requires at least 2 colors'),
        assert(borderWidth > 0, 'Border width must be positive'),
        assert(segmentLength > 0 && segmentLength <= 1.0,
            'Segment length must be between 0 and 1');

  /// The width of the box.
  final double? width;

  /// The height of the box.
  final double? height;

  /// The colors to use in the gradient.
  ///
  /// Must have at least two colors.
  final List<Color> colors;

  /// The width of the border.
  final double borderWidth;

  /// Whether to animate the gradient.
  final bool animate;

  /// Whether the animation should proceed clockwise.
  final bool clockwise;

  /// The duration of a complete animation cycle.
  final Duration animationDuration;

  /// The curve to apply to the animation.
  final Curve curve;

  /// The shape of the box.
  final BoxShape shape;

  /// The border radius of the box, if [shape] is [BoxShape.rectangle].
  final BorderRadius? borderRadius;

  /// The length of the border segment as a fraction of the total perimeter.
  ///
  /// A value of 1.0 means the entire border is drawn.
  /// A value of 0.5 means half of the border is drawn.
  /// This can be used to create partial border effects.
  final double segmentLength;

  /// The widget to place inside the box.
  final Widget? child;

  @override
  State<GradientBox> createState() => _GradientBoxState();
}

class _GradientBoxState extends State<GradientBox>
    with SingleTickerProviderStateMixin {
  /// Controls the gradient animation.
  late AnimationController _controller;

  /// The animation for the gradient rotation.
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  /// Initializes the animation controller and animation.
  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    // Start animation if specified
    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(GradientBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle changes to animation properties
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }

    // Update animation duration if it changed
    if (widget.animationDuration != oldWidget.animationDuration) {
      _controller.duration = widget.animationDuration;
      if (widget.animate) {
        _controller.repeat();
      }
    }

    // Update animation curve if it changed
    if (widget.curve != oldWidget.curve) {
      _animation = CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius:
                widget.shape == BoxShape.rectangle ? widget.borderRadius : null,
            border: _createAnimatedBorder(),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  /// Creates an animated [GradientBoxBorder] based on the current animation value.
  GradientBoxBorder _createAnimatedBorder() {
    // Determine the rotation angle based on animation and direction
    final double rotationValue =
        widget.clockwise ? _animation.value : 1.0 - _animation.value;

    // Create a rotated gradient
    final gradient = _createRotatedGradient(rotationValue);

    // Create the border with the animated gradient
    return GradientBoxBorder(
      gradient: gradient,
      width: widget.borderWidth,
      borderProgress: rotationValue,
      segmentLength: widget.segmentLength,
    );
  }

  /// Creates a rotated gradient based on the animation value.
  Gradient _createRotatedGradient(double rotationValue) {
    // For a SweepGradient, the rotation is handled by the stops and the endAngle
    return SweepGradient(
      center: Alignment.center,
      startAngle: 0.0,
      endAngle: 2 * math.pi,
      colors: widget.colors,
      transform: GradientRotation(2 * math.pi * rotationValue),
    );
  }
}

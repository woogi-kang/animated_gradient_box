part of '../animated_gradient_box.dart';

/// A widget that displays an animated gradient border around its child.
/// This widget allows customization of the gradient colors, animation
/// properties, and border shape.
class GradientBox extends StatefulWidget {
  /// Creates an animated gradient bordered box.
  const GradientBox({
    super.key,
    required this.colors,
    this.child,
    this.animate = true,
    this.animationDuration = const Duration(seconds: 2),
    this.curve = Curves.linear,
    this.borderRadius,
    this.padding,
    this.margin,
    this.borderWidth = 1.5,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.clockwise = true,
    this.duplicateColorsInReverse = true,
  });

  /// The widget to display inside the gradient border.
  /// If null, an empty container will be used.
  final Widget? child;

  /// The list of colors to use in the gradient.
  /// If [duplicateColorsInReverse] is true, the colors will be mirrored
  /// for a smoother transition.
  final List<Color> colors;

  /// The duration of one complete animation cycle.
  final Duration animationDuration;

  /// The curve to use for the animation.
  final Curve curve;

  /// The width of the gradient border.
  final double borderWidth;

  /// The border radius of the container.
  final BorderRadius? borderRadius;

  /// The padding between the border and the child widget.
  final EdgeInsets? padding;

  /// The margin around the entire widget.
  final EdgeInsets? margin;

  /// The width of the container.
  final double? width;

  /// The height of the container.
  final double? height;

  /// The shape of the border.
  final BoxShape shape;

  /// Whether the gradient should animate
  final bool animate;

  /// The direction of the animation.
  /// If true, the animation will rotate clockwise; otherwise, counter-clockwise.
  final bool clockwise;

  /// Whether to duplicate colors in reverse order for smoother gradient.
  final bool duplicateColorsInReverse;

  @override
  State<GradientBox> createState() => _GradientBoxState();
}

class _GradientBoxState extends State<GradientBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _setupAnimation();

    if (widget.animate) {
      _controller.repeat();
    }
  }

  void _setupAnimation() {
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ).drive(
      Tween<double>(
        begin: 0,
        end: widget.clockwise ? 2 * math.pi : -2 * math.pi,
      ),
    );
  }

  @override
  void didUpdateWidget(GradientBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart animation if the animate property changes
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }

    // Update animation duration if it changes
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }

    // Re-setup animation if curve or direction changes
    if (oldWidget.curve != widget.curve ||
        oldWidget.clockwise != widget.clockwise) {
      _setupAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Color> get _gradientColors {
    if (widget.duplicateColorsInReverse) {
      return [
        ...widget.colors,
        ...widget.colors.reversed,
      ];
    }
    return widget.colors;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius:
                widget.shape == BoxShape.rectangle ? widget.borderRadius : null,
            shape: widget.shape,
            border: GradientBoxBorder(
              width: widget.borderWidth,
              gradient: SweepGradient(
                colors: _gradientColors,
                stops: _generateColorStops(_gradientColors.length),
                transform: GradientRotation(_animation.value),
              ),
            ),
          ),
          child: child,
        );
      },
      child: widget.child ?? const SizedBox.shrink(),
    );
  }

  List<double> _generateColorStops(int colorCount) {
    return List.generate(
      colorCount,
      (index) => index / colorCount,
    );
  }
}

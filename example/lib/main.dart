import 'package:flutter/material.dart';
import 'package:animated_gradient_box/animated_gradient_box.dart';
import 'dart:math' as math;

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gradient Border Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  // Grouping color constants for better organization
  static const List<Color> neonColors = [
    Color(0xFF00FF00), // Neon Green
    Color(0xFF00FFFF), // Neon Cyan
    Color(0xFFFF00FF), // Neon Pink
    Color(0xFFFF00FF), // Neon Pink
  ];

  static const List<Color> sunsetColors = [
    Color(0xFFFF0000), // Bright Red
    Color(0xFFFF8C00), // Dark Orange
    Color(0xFFFFD700), // Gold
    Color(0xFFFF8C00), // Dark Orange
  ];

  static const List<Color> oceanColors = [
    Color(0xFF0000FF), // Deep Blue
    Color(0xFF00FFFF), // Cyan
    Color(0xFF00FF00), // Green
    Color(0xFF00FFFF), // Cyan
  ];

  static const List<Color> rainbowColors = [
    Color(0xFFFF0000), // Red
    Color(0xFFFF8C00), // Orange
    Color(0xFFFFFF00), // Yellow
    Color(0xFF00FF00), // Green
    Color(0xFF0000FF), // Blue
    Color(0xFF4B0082), // Indigo
    Color(0xFF9400D3), // Violet
  ];

  static const List<Color> goldColors = [
    Color(0xFFFFD700), // Gold
    Color(0xFFB8860B), // Dark Golden Rod
    Color(0xFFDAA520), // Golden Rod
    Color(0xFFB8860B), // Dark Golden Rod
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradient Border Examples'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Basic Comparisons'),
              _buildComparisonRow(),
              const SizedBox(height: 32),
              const _SectionTitle('Animation Controls'),
              _buildAnimationControlsRow(),
              const SizedBox(height: 32),
              const _SectionTitle('Animation Speeds'),
              _buildAnimationSpeedsRow(),
              const SizedBox(height: 32),
              const _SectionTitle('Animation Curves'),
              _buildAnimationCurvesRow(),
              const SizedBox(height: 32),
              const _SectionTitle('Border Length Control'),
              _buildBorderProgressRow(),
              const SizedBox(height: 32),
              const _SectionTitle('Interactive Border Length'),
              _buildAnimatedBorderProgressExample(),
            ],
          ),
        ),
      ),
    );
  }

  // Extracted method for building comparison row
  Widget _buildComparisonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LabeledBox(
          label: 'Static',
          child: Container(
            width: 150,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: GradientBoxBorder(
                gradient: const LinearGradient(
                  colors: neonColors,
                ),
                width: 2,
              ),
            ),
          ),
        ),
        _LabeledBox(
          label: 'Animated',
          child: GradientBox(
            width: 150,
            height: 100,
            colors: neonColors,
            borderWidth: 2,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  // Extracted method for building animation controls row
  Widget _buildAnimationControlsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LabeledBox(
          label: 'Single Play',
          child: GradientBox(
            width: 100,
            height: 100,
            colors: oceanColors,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        _LabeledBox(
          label: 'Manual Start',
          child: _ControlledGradientBox(
            colors: sunsetColors,
            autoStart: false,
          ),
        ),
        _LabeledBox(
          label: 'Counter-Clockwise',
          child: GradientBox(
            width: 100,
            height: 100,
            colors: rainbowColors,
            clockwise: false,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  // Extracted method for building animation speeds row
  Widget _buildAnimationSpeedsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LabeledBox(
          label: 'Slow (4s)',
          child: GradientBox(
            width: 100,
            height: 100,
            colors: neonColors,
            animationDuration: const Duration(seconds: 4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        _LabeledBox(
          label: 'Default (2s)',
          child: GradientBox(
            width: 100,
            height: 100,
            colors: neonColors,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        _LabeledBox(
          label: 'Fast (1s)',
          child: GradientBox(
            width: 100,
            height: 100,
            colors: neonColors,
            animationDuration: const Duration(seconds: 1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  // Extracted method for building animation curves row
  Widget _buildAnimationCurvesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LabeledBox(
          label: 'Linear',
          child: GradientBox(
            width: 100,
            height: 100,
            colors: goldColors,
            curve: Curves.linear,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        _LabeledBox(
          label: 'Ease',
          child: GradientBox(
            width: 100,
            height: 100,
            colors: goldColors,
            curve: Curves.ease,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        _LabeledBox(
          label: 'Bounce',
          child: GradientBox(
            width: 100,
            height: 100,
            colors: goldColors,
            curve: Curves.bounceInOut,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  // New method for demonstrating different border progress values
  Widget _buildBorderProgressRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LabeledBox(
          label: '25% Length',
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: GradientBoxBorder(
                gradient: const LinearGradient(
                  colors: rainbowColors,
                ),
                width: 3,
                borderProgress: 0.0, // Start position
                segmentLength: 0.25, // 25% of perimeter
              ),
            ),
          ),
        ),
        _LabeledBox(
          label: '50% Length',
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: GradientBoxBorder(
                gradient: const LinearGradient(
                  colors: rainbowColors,
                ),
                width: 3,
                borderProgress: 0.0, // Start position
                segmentLength: 0.5, // 50% of perimeter
              ),
            ),
          ),
        ),
        _LabeledBox(
          label: '75% Length',
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: GradientBoxBorder(
                gradient: const LinearGradient(
                  colors: rainbowColors,
                ),
                width: 3,
                borderProgress: 0.0, // Start position
                segmentLength: 0.75, // 75% of perimeter
              ),
            ),
          ),
        ),
      ],
    );
  }

  // New method for demonstrating interactive border progress control
  Widget _buildAnimatedBorderProgressExample() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LabeledBox(
            label: 'Chasing Light',
            child: _ChasingLightBorderBox(
              colors: neonColors,
              segmentLength: 0.15, // 15% of perimeter
            ),
          ),
          _LabeledBox(
            label: 'Interactive',
            child: _InteractiveBorderProgress(),
          ),
          _LabeledBox(
            label: 'Light Trail',
            child: _ChasingLightBorderBox(
              colors: oceanColors,
              segmentLength: 0.3, // 30% of perimeter
              duration: const Duration(seconds: 3),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class _LabeledBox extends StatelessWidget {
  const _LabeledBox({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

// Controlled example with start/stop button
class _ControlledGradientBox extends StatefulWidget {
  const _ControlledGradientBox({
    required this.colors,
    this.autoStart = false,
  });

  final List<Color> colors;
  final bool autoStart;

  @override
  State<_ControlledGradientBox> createState() => _ControlledGradientBoxState();
}

class _ControlledGradientBoxState extends State<_ControlledGradientBox> {
  bool _isAnimating = false;

  void _toggleAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAnimation,
      child: Stack(
        children: [
          GradientBox(
            width: 100,
            height: 100,
            colors: widget.colors,
            animate: _isAnimating,
            borderRadius: BorderRadius.circular(8),
          ),
          Positioned.fill(
            child: Center(
              child: Icon(
                _isAnimating ? Icons.pause : Icons.play_arrow,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// A widget with a slider to control border progress
class _InteractiveBorderProgress extends StatefulWidget {
  const _InteractiveBorderProgress();

  @override
  State<_InteractiveBorderProgress> createState() => _InteractiveBorderProgressState();
}

class _InteractiveBorderProgressState extends State<_InteractiveBorderProgress> {
  double _borderProgress = 0.5;
  double _segmentLength = 0.2; // Default to 20%

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: GradientBoxBorder(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF0000), // Red
                  Color(0xFFFF8C00), // Orange
                  Color(0xFFFFFF00), // Yellow
                  Color(0xFF00FF00), // Green
                  Color(0xFF0000FF), // Blue
                  Color(0xFF4B0082), // Indigo
                  Color(0xFF9400D3), // Violet
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              width: 3,
              borderProgress: _borderProgress,
              segmentLength: _segmentLength,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Position: ${(_borderProgress * 100).toInt()}%',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(
          width: 120,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: _borderProgress,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  _borderProgress = value;
                });
              },
            ),
          ),
        ),
        Text(
          'Length: ${(_segmentLength * 100).toInt()}%',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(
          width: 120,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: _segmentLength,
              min: 0.1,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  _segmentLength = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

// A widget with an animated chasing light effect
class _ChasingLightBorderBox extends StatefulWidget {
  const _ChasingLightBorderBox({
    required this.colors,
    this.segmentLength = 0.2,
    this.duration = const Duration(seconds: 2),
  });

  final List<Color> colors;
  final double segmentLength;
  final Duration duration;

  @override
  State<_ChasingLightBorderBox> createState() => _ChasingLightBorderBoxState();
}

class _ChasingLightBorderBoxState extends State<_ChasingLightBorderBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animation controller
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Simple linear animation that continuously loops from 0.0 to 1.0
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    
    // Start the animation
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: GradientBoxBorder(
              gradient: LinearGradient(
                colors: widget.colors,
              ),
              width: 3,
              borderProgress: _progressAnimation.value,
              segmentLength: widget.segmentLength,
            ),
          ),
        );
      },
    );
  }
}

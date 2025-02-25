import 'package:flutter/material.dart';
import 'package:animated_gradient_box/animated_gradient_box.dart';

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
            child: Container(),
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
            child: Container(),
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
            child: Container(),
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
            child: Container(),
          ),
        ),
        _LabeledBox(
          label: 'Default (2s)',
          child: GradientBox(
            width: 100,
            height: 100,
            colors: neonColors,
            borderRadius: BorderRadius.circular(8),
            child: Container(),
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
            child: Container(),
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
            child: Container(),
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
            child: Container(),
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
            child: Container(),
          ),
        ),
      ],
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
            child: Container(color: Colors.transparent),
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
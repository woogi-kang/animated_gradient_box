// ignore_for_file: prefer_const_constructors

import 'package:animated_gradient_box/animated_gradient_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GradientBox', () {
    testWidgets('renders correctly with required parameters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientBox(
            colors: const [Colors.blue, Colors.red],
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      expect(find.byType(GradientBox), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('renders correctly without child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientBox(
            colors: const [Colors.blue, Colors.red],
            width: 100,
            height: 100,
          ),
        ),
      );

      expect(find.byType(GradientBox), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('applies custom parameters correctly', (tester) async {
      const borderWidth = 2.0;
      final borderRadius = BorderRadius.circular(20);

      await tester.pumpWidget(
        MaterialApp(
          home: GradientBox(
            colors: const [Colors.blue, Colors.red],
            borderRadius: borderRadius,
            width: 200,
            height: 200,
            animationDuration: const Duration(seconds: 3),
            clockwise: false,
            curve: Curves.easeInOut,
            child: const SizedBox(),
          ),
        ),
      );

      final gradientBox = tester.widget<GradientBox>(find.byType(GradientBox));
      
      expect(gradientBox.borderWidth, borderWidth);
      expect(gradientBox.borderRadius, borderRadius);
      expect(gradientBox.width, 200);
      expect(gradientBox.height, 200);
      expect(gradientBox.animationDuration, const Duration(seconds: 3));
      expect(gradientBox.clockwise, false);
      expect(gradientBox.curve, Curves.easeInOut);
      expect(gradientBox.shape, BoxShape.rectangle);
    });

    testWidgets('animation can be disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientBox(
            colors: const [Colors.blue, Colors.red],
            animate: false,
          ),
        ),
      );

      final gradientBox = tester.widget<GradientBox>(find.byType(GradientBox));
      expect(gradientBox.animate, false);
    });
  });

  group('GradientBoxBorder', () {
    test('creates border with required parameters', () {
      final gradient = LinearGradient(
        colors: [Colors.blue, Colors.red],
      );

      final border = GradientBoxBorder(gradient: gradient);

      expect(border.gradient, gradient);
      expect(border.width, 1.0); // Default width
      expect(border.borderProgress, 1.0); // Default border progress
      expect(border.segmentLength, 1.0); // Default segment length
    });

    test('creates border with custom parameters', () {
      final gradient = LinearGradient(
        colors: [Colors.blue, Colors.red],
      );
      const width = 2.0;
      const borderProgress = 0.5;
      const segmentLength = 0.7;

      final border = GradientBoxBorder(
        gradient: gradient,
        width: width,
        borderProgress: borderProgress,
        segmentLength: segmentLength,
      );

      expect(border.width, width);
      expect(border.borderProgress, borderProgress);
      expect(border.segmentLength, segmentLength);
    });

    test('implements equality correctly', () {
      final gradient = LinearGradient(
        colors: [Colors.blue, Colors.red],
      );

      final border1 = GradientBoxBorder(
        gradient: gradient,
        width: 2,
        borderProgress: 0.5,
        segmentLength: 0.7,
      );
      
      final border2 = GradientBoxBorder(
        gradient: gradient,
        width: 2,
        borderProgress: 0.5,
        segmentLength: 0.7,
      );
      
      final border3 = GradientBoxBorder(
        gradient: gradient,
        width: 2,
        borderProgress: 0.3, // Different progress
        segmentLength: 0.7,
      );

      expect(border1, border2);
      expect(border1, isNot(border3));
      expect(border1.hashCode, border2.hashCode);
      expect(border1.hashCode, isNot(border3.hashCode));
    });

    test('dimensions returns correct EdgeInsets', () {
      final border = GradientBoxBorder(
        gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
        width: 2,
      );

      expect(border.dimensions, const EdgeInsets.all(2));
    });

    test('isUniform returns true', () {
      final border = GradientBoxBorder(
        gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
      );

      expect(border.isUniform, true);
    });

    test('scale returns new instance with scaled width', () {
      final gradient = LinearGradient(colors: [Colors.blue, Colors.red]);
      final border = GradientBoxBorder(
        gradient: gradient,
        width: 2,
        borderProgress: 0.5,
        segmentLength: 0.7,
      );

      final scaled = border.scale(2) as GradientBoxBorder;

      expect(scaled.width, 4);
      expect(scaled.gradient, gradient);
      expect(scaled.borderProgress, 0.5); // Should remain the same
      expect(scaled.segmentLength, 0.7); // Should remain the same
    });

    test('throws assertion error for invalid parameters', () {
      final gradient = LinearGradient(colors: [Colors.blue, Colors.red]);
      
      expect(() => GradientBoxBorder(
        gradient: gradient,
        width: -1, // Negative width
      ), throwsAssertionError);
      
      expect(() => GradientBoxBorder(
        gradient: gradient,
        borderProgress: 1.5, // > 1.0
      ), throwsAssertionError);
      
      expect(() => GradientBoxBorder(
        gradient: gradient,
        segmentLength: -0.1, // Negative segment length
      ), throwsAssertionError);
    });
  });
}

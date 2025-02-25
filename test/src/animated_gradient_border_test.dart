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

    testWidgets('applies custom parameters correctly', (tester) async {
      const borderWidth = 2.0;
      const padding = EdgeInsets.all(8);
      const margin = EdgeInsets.all(16);
      final borderRadius = BorderRadius.circular(20);

      await tester.pumpWidget(
        MaterialApp(
          home: GradientBox(
            colors: const [Colors.blue, Colors.red],
            borderWidth: borderWidth,
            padding: padding,
            margin: margin,
            borderRadius: borderRadius,
            width: 200,
            height: 200,
            child: const SizedBox(),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as GradientBoxBorder;

      expect(container.padding, padding);
      expect(container.margin, margin);
      expect(container.constraints?.maxWidth, 200);
      expect(container.constraints?.maxHeight, 200);
      expect(decoration.borderRadius, borderRadius);
      expect(border.width, borderWidth);
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
    });

    test('creates border with custom width', () {
      final gradient = LinearGradient(
        colors: [Colors.blue, Colors.red],
      );
      const width = 2.0;

      final border = GradientBoxBorder(
        gradient: gradient,
        width: width,
      );

      expect(border.width, width);
    });

    test('implements equality correctly', () {
      final gradient = LinearGradient(
        colors: [Colors.blue, Colors.red],
      );

      final border1 = GradientBoxBorder(gradient: gradient, width: 2);
      final border2 = GradientBoxBorder(gradient: gradient, width: 2);
      final border3 = GradientBoxBorder(gradient: gradient, width: 3);

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
      final border = GradientBoxBorder(gradient: gradient, width: 2);

      final scaled = border.scale(2) as GradientBoxBorder;

      expect(scaled.width, 4);
      expect(scaled.gradient, gradient);
    });
  });
}

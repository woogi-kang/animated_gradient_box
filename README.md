# Animated Gradient Box

A Flutter package that provides animated gradient borders for widgets with customizable colors, shapes, and animation controls.

## Installation 💻

**❗ In order to start using Animated Gradient Box you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Add `animated_gradient_box` to your `pubspec.yaml`:

```yaml
dependencies:
  animated_gradient_box: ^0.1.0
```

Or install it directly from the command line:

```sh
flutter pub add animated_gradient_box
```

## Usage

Import the package in your Dart file:

```dart
import 'package:animated_gradient_box/animated_gradient_box.dart';
```

## Examples

### Basic Usage

Create a simple animated gradient border around any widget:

```dart
GradientBox(
  colors: [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
  ],
  child: Container(
    width: 150,
    height: 100,
    child: Center(child: Text('Hello, Gradient!')),
  ),
)
```

You can also use it without a child:

```dart
GradientBox(
  width: 150,
  height: 100,
  colors: [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
  ],
)
```

![Basic Gradient Box](images/basic_gradient_box.png)

### Static vs Animated

Compare static gradient borders with animated ones:

```dart
// Static gradient border
Container(
  width: 150,
  height: 100,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: GradientBoxBorder(
      gradient: LinearGradient(
        colors: [
          Color(0xFF00FF00), // Neon Green
          Color(0xFF00FFFF), // Neon Cyan
          Color(0xFFFF00FF), // Neon Pink
        ],
      ),
      width: 2,
    ),
  ),
)

// Animated gradient border
GradientBox(
  width: 150,
  height: 100,
  colors: [
    Color(0xFF00FF00), // Neon Green
    Color(0xFF00FFFF), // Neon Cyan
    Color(0xFFFF00FF), // Neon Pink
  ],
  borderWidth: 2,
  borderRadius: BorderRadius.circular(8),
)
```

![Static vs Animated](images/static_vs_animated.png)

### Animation Controls

Control the animation with various parameters:

```dart
// Counter-clockwise animation
GradientBox(
  width: 100,
  height: 100,
  colors: [
    Color(0xFFFF0000), // Red
    Color(0xFFFF8C00), // Orange
    Color(0xFFFFFF00), // Yellow
    Color(0xFF00FF00), // Green
    Color(0xFF0000FF), // Blue
    Color(0xFF4B0082), // Indigo
    Color(0xFF9400D3), // Violet
  ],
  clockwise: false,
  borderRadius: BorderRadius.circular(8),
)
```

![Animation Controls](images/animation_controls.png)

### Animation Speeds

Customize the animation speed:

```dart
// Slow animation (4 seconds)
GradientBox(
  width: 100,
  height: 100,
  colors: neonColors,
  animationDuration: Duration(seconds: 4),
  borderRadius: BorderRadius.circular(8),
)

// Default animation (2 seconds)
GradientBox(
  width: 100,
  height: 100,
  colors: neonColors,
  borderRadius: BorderRadius.circular(8),
)

// Fast animation (1 second)
GradientBox(
  width: 100,
  height: 100,
  colors: neonColors,
  animationDuration: Duration(seconds: 1),
  borderRadius: BorderRadius.circular(8),
)
```

![Animation Speeds](images/animation_speeds.png)

### Animation Curves

Apply different animation curves:

```dart
// Linear curve
GradientBox(
  width: 100,
  height: 100,
  colors: goldColors,
  curve: Curves.linear,
  borderRadius: BorderRadius.circular(8),
)

// Ease curve
GradientBox(
  width: 100,
  height: 100,
  colors: goldColors,
  curve: Curves.ease,
  borderRadius: BorderRadius.circular(8),
)

// Bounce curve
GradientBox(
  width: 100,
  height: 100,
  colors: goldColors,
  curve: Curves.bounceInOut,
  borderRadius: BorderRadius.circular(8),
)
```

![Animation Curves](images/animation_curves.png)

## Customization

The `GradientBox` widget supports various customization options:

| Property | Type | Description |
|----------|------|-------------|
| `colors` | `List<Color>` | The list of colors to use in the gradient |
| `child` | `Widget?` | The widget to display inside the gradient border (optional) |
| `animationDuration` | `Duration` | The duration of one complete animation cycle |
| `curve` | `Curve` | The curve to use for the animation |
| `borderWidth` | `double` | The width of the gradient border |
| `borderRadius` | `BorderRadius?` | The border radius of the container |
| `padding` | `EdgeInsets?` | The padding between the border and the child widget |
| `margin` | `EdgeInsets?` | The margin around the entire widget |
| `width` | `double?` | The width of the container |
| `height` | `double?` | The height of the container |
| `shape` | `BoxShape` | The shape of the border (rectangle or circle) |
| `animate` | `bool` | Whether the gradient should animate |
| `clockwise` | `bool` | The direction of the animation |
| `duplicateColorsInReverse` | `bool` | Whether to duplicate colors in reverse order for smoother gradient |

## Running Tests 🧪

To run all unit tests, use the following command:

```sh
flutter test
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

[flutter_install_link]: https://docs.flutter.dev/get-started/install

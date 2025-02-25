# Animated Gradient Border

A Flutter package that provides animated gradient borders for widgets with customizable colors, shapes, and animation controls.

## Installation 💻

**❗ In order to start using Animated Gradient Border you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

### Clone the Repository

To get started, you can clone the repository from GitHub:

```sh
git clone https://github.com/YOUR_USERNAME/animated_gradient_border.git
cd animated_gradient_border
```

### Download the Package

Alternatively, you can download the package as a ZIP file:

1. Go to the [GitHub repository](https://github.com/YOUR_USERNAME/animated_gradient_border).
2. Click on the "Code" button.
3. Select "Download ZIP".
4. Extract the ZIP file to your desired location.

### Add the Package to Your Project

To use the Animated Gradient Border in your Flutter project, add it as a dependency in your `pubspec.yaml`:

```yaml
dependencies:
  animated_gradient_border:
    path: ../path_to_your_cloned_or_downloaded_package
```

Then, run the following command to get the package:

```sh
flutter pub get
```

### Usage

Import the package in your Dart file:

```dart
import 'package:animated_gradient_box/animated_gradient_box.dart';
```

Use the `GradientBox` widget in your Flutter application:

```dart
GradientBox(
  colors: [Colors.blue, Colors.red],
  child: Text('Hello, Gradient!'),
)
```

---

## Running Tests 🧪

To run all unit tests, use the following command:

```sh
flutter test
```

To view the generated coverage report, you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[flutter_install_link]: https://docs.flutter.dev/get-started/install

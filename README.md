# Circular Selector v2

A circular navigator that spins like a rotary phone dial.

## Use Cases

Circular Selector v2 can be used in various applications as follows:

	•	Watch Faces: Create interactive and visually appealing watch faces for Wearable OS.
	•	Volume Controls: Implement smooth and intuitive volume dials in audio applications.
	•	Menu Navigators: Design rotary-style navigation menus for applications.
	•	Game Controls: Develop engaging game controls that mimic a rotary dial.
	•	Fitness Trackers: Integrate with fitness trackers for selecting workout modes or tracking progress.

## Features

1. **Modular:** The dial-like componenet has children which are customizable for texts, numbers, icons, etc.
2. **Animated:** The dial is animated robustly.
3. **Selecting values:** The API provides a way to give a callback function for ease of use.
4. **Ease of Access:** There are 2 ways of interacting with the dial, by dragging or by tapping.

## Getting Started

In the `pubspec.yaml` of your Flutter project, add the following dependency:

```yaml
dependencies:
  circular_selector_v2: ^0.2.0
```
Run this command with Flutter:

```dart
flutter pub add circular_selector_v2
```

In your library, add the following import:

```dart
import 'package:circular_selector_v2/circular_selector_v2.dart';
```

All done! Now you can use the `CircularSelector` widget.

## Usage

You can refer to a simple example below:

```dart
CircularSelector(
    onSelected: (int index) {
        print('Selected: $index');
    },
    childSize: 30.0,
    radiusDividend: 2.5,
    customOffset: Offset(
        0.0,
        AppBar().preferredSize.height,
    ),
    children: CircularSelector.getTestContainers(20, 30.0),
)
```

For an executable example, refer to the `example` folder.

## FOSS Wear

FOSS Wear is a minimal watch face made using the CircularSelector Widget from the Circular Selector v2 package. Built with Wear OS, it demonstrates the capabilities of the CircularSelector in a practical, user-friendly application.
You can 

For the executable watch face, refer to the `foss_wear` folder.

To test the watch face, you will need Android Studio and the following dependencies in your pubspec.yaml:

```yaml
dependencies:
  audioplayers: ^6.0.0
  wear: flutter_wear_plugin-master
  cupertino_icons: ^1.0.6
  circular_selector_v2: ^0.2.0
```

## Contributing

If you would like to contribute to the package, please refer to the [CONTRIBUTING.md](CONTRIBUTING.md) file.

---

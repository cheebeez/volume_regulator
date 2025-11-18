# Volume Regulator

A Flutter plugin to monitor and adjust device volume from 0 to 100%.

[![flutter platform](https://img.shields.io/badge/Platform-Flutter-yellow.svg)](https://flutter.dev)
[![pub package](https://img.shields.io/pub/v/volume_regulator.svg)](https://pub.dev/packages/volume_regulator)

## Installation

To use this package, add `volume_regulator` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  volume_regulator: ^2.4.2
```

## Usage

```dart
// Import package
import 'package:volume_regulator/volume_regulator.dart';

// Set the new volume, between 0-100.
VolumeRegulator.setVolume(50);

// Get the current volume.
VolumeRegulator.getVolume().then((value) {
  print(value);
});
```

### Volume Event

This event is fired when the volume has changed.

```dart
VolumeRegulator.volumeStream.listen((value) {
  print(value);
});
```

## Requirements 
- iOS: SDK 10.0 (or later)
- Android: API Level 23 (or later)

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate.

/*
 *  volume_regulator.dart
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 16.01.2021.
 */

import 'dart:async';
import 'package:flutter/services.dart';

class VolumeRegulator {
  static const _channel = MethodChannel('volume_regulator');
  static const _events = EventChannel('volume_regulator/volumeEvents');
  static Stream<int>? _volumeStream;

  /// Get the volume value.
  static Future<int> getVolume() async {
    return await _channel.invokeMethod('get');
  }

  /// Set the new volume value.
  static Future<void> setVolume(int value) async {
    await _channel.invokeMethod('set', value);
  }

  /// Get the volume stream.
  static Stream<int> get volumeStream {
    _volumeStream ??=
        _events.receiveBroadcastStream().map<int>((value) => value);

    return _volumeStream!;
  }
}

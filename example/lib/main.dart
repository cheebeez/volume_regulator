/*
 *  main.dart
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 16.01.2021.
 */

import 'package:flutter/material.dart';
import 'package:volume_regulator/volume_regulator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _volume = 0;

  @override
  void initState() {
    super.initState();

    // Init slider.
    VolumeRegulator.getVolume().then((value) {
      setState(() {
        _volume = value.toDouble();
      });
    });

    // Listening to volume change events.
    VolumeRegulator.volumeStream.listen((value) {
      setState(() {
        _volume = value.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Volume Regulator'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Volume: ${_volume.round()}%',
              ),
              Slider(
                value: _volume,
                min: 0,
                max: 100,
                divisions: 100,
                label: _volume.round().toString(),
                onChanged: (double value) {
                  VolumeRegulator.setVolume(value.toInt());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

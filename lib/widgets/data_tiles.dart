import 'package:drive_cycle/model/gps_reading.dart';
import 'package:drive_cycle/model/sensor_reading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class GpsDataTile extends StatelessWidget {
  final GpsReading reading;
  const GpsDataTile({Key? key, required this.reading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle dataStyle = const TextStyle(fontSize: 12);
    return LimitedBox(
      maxWidth: MediaQuery.of(context).size.width / 1.2,
      maxHeight: 68,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "GPS reading",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    reading.time.toString(),
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Speed: ${reading.speed.toStringAsFixed(2)}",
                    style: dataStyle,
                  ),
                  Text(
                    "Uncertainty: ${reading.uncertainty.toStringAsFixed(4)}",
                    style: dataStyle,
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}

class EmptyTile extends StatelessWidget {
  const EmptyTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60.0),
        child: const Card(child: Center(child: Text("Waiting for data..."))),
      ),
    );
  }
}

class SensorDataTile extends StatelessWidget {
  final SensorReading reading;

  const SensorDataTile({Key? key, required this.reading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle dataStyle = const TextStyle(fontSize: 14);
    return LimitedBox(
      maxHeight: 68,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Accelerometer reading",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    reading.time.toString(),
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "x: ${reading.data.x.toStringAsFixed(2)}",
                    style: dataStyle,
                  ),
                  Text(
                    "y: ${reading.data.y.toStringAsFixed(2)}",
                    style: dataStyle,
                  ),
                  Text(
                    "z: ${reading.data.z.toStringAsFixed(2)}",
                    style: dataStyle,
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}

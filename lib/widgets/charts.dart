import 'dart:math';

import 'package:drive_cycle/model/gps_reading.dart';
import 'package:drive_cycle/model/sensor_reading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const numReadings = 100;

class AreaChart extends StatelessWidget {
  final List<GpsReading> readings;
  final String title;
  final bool trim;

  const AreaChart(
      {Key? key, required this.readings, required this.title, required this.trim})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GpsReading> newReadings = readings;
    if (trim) {
      var len = readings.length;
      newReadings = readings.getRange(len - numReadings, len - 1).toList();
    }
    return readings.isNotEmpty
        ? Container(
        child: SfCartesianChart(
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            title: ChartTitle(text: "$title (kmph) vs t (ms)"),
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              LineSeries<GpsReading, int>(
                  color: Colors.red.withOpacity(0.3),
                  dataSource: newReadings,
                  name: 'upper',
                  xValueMapper: (GpsReading reading, _) => reading.time,
                  yValueMapper: (GpsReading reading, _) => reading.speed + reading.uncertainty),
              LineSeries<GpsReading, int>(
                  color: Colors.blue,
                  dataSource: newReadings,
                  name: 'speed',
                  xValueMapper: (GpsReading reading, _) => reading.time,
                  yValueMapper: (GpsReading reading, _) => reading.speed),
              LineSeries<GpsReading, int>(
                  color: Colors.red.withOpacity(0.3),
                  dataSource: newReadings,
                  name: 'lower',
                  xValueMapper: (GpsReading reading, _) => reading.time,
                  yValueMapper: (GpsReading reading, _) => max(-1, reading.speed - reading.uncertainty)),
            ]))
        : Container();
  }
}

class LineChart extends StatelessWidget {
  final List<SensorReading> readings;
  final String title;
  final bool trim;

  const LineChart(
      {Key? key, required this.readings, required this.title, required this.trim})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<SensorReading> newReadings = readings;
    if (trim) {
      var len = readings.length;
      newReadings = readings.getRange(len - numReadings, len - 1).toList();
    }
    return readings.isNotEmpty
        ? Container(
        child: SfCartesianChart(
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            title: ChartTitle(text: "$title (kmph/s) vs t (ms)"),
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              LineSeries<SensorReading, int>(
                  color: Colors.green,
                  dataSource: newReadings,
                  name: 'acceleration',
                  xValueMapper: (SensorReading reading, _) => reading.time,
                  yValueMapper: (SensorReading reading, _) => reading.data.length),
            ]))
        : Container();
  }
}


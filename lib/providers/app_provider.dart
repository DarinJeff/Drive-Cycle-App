import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_cycle/model/gps_reading.dart';
import 'package:drive_cycle/model/sensor_reading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AppProvider extends ChangeNotifier {
  List<GpsReading> gpsData = [];
  List<SensorReading> accelerometerData = [];
  List<SensorReading> magnetometerData = [];
  List<SensorReading> gravityData = [];

  bool hasStart = false;
  late DateTime startTime;

  String city = "Mumbai";
  String vehicleType = "2 wheeler";
  // String name = "null";

  AppProvider() {
    startTime = DateTime.now();
  }

  void addGpsReading(GpsReading reading) async {
    gpsData.add(reading);
    notifyListeners();
    if (reading.time > 600000) {
      stop();
      await Future.delayed(Duration(milliseconds: 5000));
      start();
    }
    return;
  }

  void addAccelerometerReading(SensorReading reading) {
    accelerometerData.add(reading);
    notifyListeners();
  }

  void addMagnetometerReading(SensorReading reading) {
    magnetometerData.add(reading);
  }

  void addGravityReading(SensorReading reading) {
    gravityData.add(reading);
  }

  int getTimeDiff() {
    return DateTime.now().difference(startTime).inMilliseconds;
  }

  void stop() {
    hasStart = false;
    notifyListeners();
    if (gpsData.last.time > 60000){
      saveData();
      Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: "Data saved",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: "Data too short",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  void start() {
    hasStart = true;
    startTime = DateTime.now();
    gpsData.clear();
    accelerometerData.clear();
    magnetometerData.clear();
    gravityData.clear();
    notifyListeners();
  }

  void saveData() async {
    List<double?> gpsSpeeds = [];
    List<double?> gpsErrors = [];
    List<int> gpsTimes = [];
    gpsData.forEach((element) {
      gpsSpeeds.add(element.speed);
      gpsErrors.add(element.uncertainty);
      gpsTimes.add(element.time);
    });

    List<double> accelerationX = [];
    List<double> accelerationY = [];
    List<double> accelerationZ = [];
    List<int> accelTimes = [];
    accelerometerData.forEach((element) {
      accelTimes.add(element.time);
      accelerationX.add(element.data.x);
      accelerationY.add(element.data.y);
      accelerationZ.add(element.data.z);
    });

    List<double> magnetometerX = [];
    List<double> magnetometerY = [];
    List<double> magnetometerZ = [];
    List<int> magnetometerTimes = [];
    magnetometerData.forEach((element) {
      magnetometerTimes.add(element.time);
      magnetometerX.add(element.data.x);
      magnetometerY.add(element.data.y);
      magnetometerZ.add(element.data.z);
    });

    List<double> gravityX = [];
    List<double> gravityY = [];
    List<double> gravityZ = [];
    List<int> gravityTimes = [];
    gravityData.forEach((element) {
      gravityTimes.add(element.time);
      gravityX.add(element.data.x);
      gravityY.add(element.data.y);
      gravityZ.add(element.data.z);
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(DateFormat('yyyy_MM_dd_kk_mm').format(DateTime.now()))
        .set({
      "gpsSpeeds": gpsSpeeds,
      "gpsErrors": gpsErrors,
      "gpsTimes": gpsTimes,
      "accelerationX": accelerationX,
      "accelerationY": accelerationY,
      "accelerationZ": accelerationZ,
      "accelTimes": accelTimes,
      "magnetX": magnetometerX,
      "magnetY": magnetometerY,
      "magnetZ": magnetometerZ,
      "magnetTimes": magnetometerTimes,
      "gravityX": gravityX,
      "gravityY": gravityY,
      "gravityZ": gravityZ,
      "gravityTimes": gravityTimes,
      "vehicleType": vehicleType,
      "city": city
    });
  }
}

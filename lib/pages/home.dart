import 'dart:async';
import 'package:drive_cycle/model/gps_reading.dart';
import 'package:drive_cycle/widgets/charts.dart';
import 'package:drive_cycle/widgets/error_screen.dart';
import 'package:drive_cycle/widgets/data_tiles.dart';
import 'package:drive_cycle/widgets/selectors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:drive_cycle/model/sensor_reading.dart';
import 'package:drive_cycle/providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:motion_sensors/motion_sensors.dart';
import 'package:provider/provider.dart';
import 'package:move_to_background/move_to_background.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late StreamSubscription accelerometerSubscription;
  late StreamSubscription magnetometerSubscription;
  late StreamSubscription gravitySubscription;
  late StreamSubscription gpsSubscription;

  Location location = Location();
  bool _serviceActive = false;
  bool _permissionGranted = false;

  @override
  void initState() {
    motionSensors.userAccelerometerUpdateInterval =
        Duration.microsecondsPerSecond ~/ 1;
    accelerometerSubscription =
        motionSensors.userAccelerometer.listen((UserAccelerometerEvent event) {
      if (Provider.of<AppProvider>(context, listen: false).hasStart) {
        var myProvider = Provider.of<AppProvider>(context, listen: false);
        Vector3 acceleration = Vector3(event.x, event.y, event.z);
        SensorReading reading =
            SensorReading(myProvider.getTimeDiff(), acceleration);
        myProvider.addAccelerometerReading(reading);
      }
    });

    motionSensors.magnetometerUpdateInterval =
        Duration.microsecondsPerSecond ~/ 1;
    magnetometerSubscription =
        motionSensors.magnetometer.listen((MagnetometerEvent event) {
      if (Provider.of<AppProvider>(context, listen: false).hasStart) {
        var myProvider = Provider.of<AppProvider>(context, listen: false);
        Vector3 magnetometer = Vector3(event.x, event.y, event.z);
        SensorReading reading =
            SensorReading(myProvider.getTimeDiff(), magnetometer);
        myProvider.addMagnetometerReading(reading);
      }
    });

    motionSensors.accelerometerUpdateInterval =
        Duration.microsecondsPerSecond ~/ 1;
    gravitySubscription =
        motionSensors.accelerometer.listen((AccelerometerEvent event) {
      if (Provider.of<AppProvider>(context, listen: false).hasStart) {
        var myProvider = Provider.of<AppProvider>(context, listen: false);
        Vector3 gravity = Vector3(event.x, event.y, event.z);
        SensorReading reading =
            SensorReading(myProvider.getTimeDiff(), gravity);
        myProvider.addGravityReading(reading);
      }
    });

    _setService();
    _getPermission();
    location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 200, distanceFilter: 0);

    gpsSubscription =
        location.onLocationChanged.listen((LocationData locationData) {
      if (Provider.of<AppProvider>(context, listen: false).hasStart) {
        var myProvider = Provider.of<AppProvider>(context, listen: false);
        var speed = locationData.speed ?? -1;
        var accuracy = locationData.accuracy ?? 0;
        GpsReading reading =
            GpsReading(myProvider.getTimeDiff(), speed * 3.6, accuracy * 3.6);
        myProvider.addGpsReading(reading);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    gpsSubscription.cancel();
    accelerometerSubscription.cancel();
    magnetometerSubscription.cancel();
    gravitySubscription.cancel();
    gpsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
          body: LimitedBox(
        maxHeight: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
              child: (!_serviceActive)
                  ? const ErrorScreen(
                      error: "Enable location services to continue")
                  : (_serviceActive && !_permissionGranted)
                      ? const ErrorScreen(
                          error: "Accept location permissions to use this app")
                      : Consumer<AppProvider>(
                          builder: (context, myProvider, _) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      Text("Vehicle Type: "),
                                      Spacer(),
                                      WheelSelector(
                                        key: Key("wheels"),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      Text("City: "),
                                      Spacer(),
                                      CitySelector(
                                        key: Key("city"),
                                      )
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                                //   child: TextField(
                                //       textAlign: TextAlign.center,
                                //       style: const TextStyle(fontSize: 25),
                                //       decoration: const InputDecoration(
                                //         hintText: "YOUR NAME",
                                //         hintStyle: TextStyle(fontSize: 15),
                                //         border: InputBorder.none,
                                //         contentPadding: EdgeInsets.all(20),
                                //       )),
                                // ),
                                SizedBox(height: 10,),
                                IconButton(
                                  onPressed: () {
                                    if (myProvider.hasStart) {
                                      myProvider.stop();
                                    } else {
                                      myProvider.start();
                                    }
                                    setState(() {});
                                  },
                                  icon: myProvider.hasStart
                                      ? const Icon(FontAwesomeIcons.pause)
                                      : const Icon(FontAwesomeIcons.play),
                                  iconSize: 30,
                                  color: Colors.orange,
                                ),
                                SizedBox(height: 10,),
                                AreaChart(
                                  title: "GPS data",
                                  readings: myProvider.gpsData,
                                  trim: (myProvider.hasStart &&
                                      (myProvider.gpsData.length >
                                          numReadings)),
                                ),
                                LineChart(
                                  readings: myProvider.accelerometerData,
                                  title: "Accelerometer data",
                                  trim: myProvider.hasStart &&
                                      (myProvider.accelerometerData.length >
                                          numReadings),
                                )
                              ],
                            );
                          },
                        )),
        ),
      )),
    );
  }

  void _setService() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (serviceEnabled) {
        _serviceActive = true;
      }
    }
    _serviceActive = true;
    setState(() {});
  }

  void _getPermission() async {
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.granted) {
        _permissionGranted = true;
      }
    }
    _permissionGranted = true;
  }
}

/*
myProvider.gpsData.isNotEmpty
                                    ? GpsDataTile(
                                        reading: myProvider.gpsData.last,
                                      )
                                    : const EmptyTile(),
                                myProvider.accelerometerData.isNotEmpty
                                    ? SensorDataTile(
                                        reading:
                                            myProvider.accelerometerData.last,
                                      )
                                    : const EmptyTile(),
 */

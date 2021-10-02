import 'package:drive_cycle/pages/home.dart';
import 'package:drive_cycle/providers/app_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(ChangeNotifierProvider(
    create: (context) => AppProvider(),
    child: MaterialApp(home: const Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),),
  ));
}
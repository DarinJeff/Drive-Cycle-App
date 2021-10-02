import 'package:drive_cycle/providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class WheelSelector extends StatefulWidget {
  const WheelSelector({Key? key}) : super(key: key);

  @override
  _WheelSelectorState createState() => _WheelSelectorState();
}

class _WheelSelectorState extends State<WheelSelector> {
  String chosenValue = "2 wheeler";

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: chosenValue,
      items: <String>[
        "2 wheeler",
        "3 wheeler",
        "4 wheeler",
        "6 wheeler",
        "other"
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          child: Text(value),
          value: value,
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          chosenValue = value ?? "2 wheeler";
        });
        AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
        appProvider.vehicleType = chosenValue;
      },
    );
  }
}

class CitySelector extends StatefulWidget {
  const CitySelector({Key? key}) : super(key: key);

  @override
  _CitySelectorState createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  String chosenValue = "Mumbai";

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: chosenValue,
      items: <String>[
        "Mumbai",
        "Pune",
        "Delhi",
        "Hyderabad",
        "Chennai",
        "Bangalore"
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          child: Text(value),
          value: value,
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          chosenValue = value ?? "Mumbai";
        });
        AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
        appProvider.city = chosenValue;
      },
    );
  }
}

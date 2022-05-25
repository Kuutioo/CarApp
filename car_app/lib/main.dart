// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './pages/cars_page.dart';
import './pages/car_location_page.dart';
import 'models/location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Location carLocation = Location(
    latitude: 0,
    longitude: 0,
    address: '',
  );
  final Location houseLocation = Location(
    latitude: 0,
    longitude: 0,
    address: '',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cars App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CarsPage(),
      routes: {
        CarLocationPage.routeName: (context) =>
            CarLocationPage(carLocation, houseLocation),
      },
    );
  }
}

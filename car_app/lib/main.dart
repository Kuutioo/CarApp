// ignore_for_file: use_key_in_widget_constructors

import 'package:car_app/pages/pick_location_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './pages/cars_page.dart';
import './pages/map_page.dart';
import './models/location.dart';
import './models/notification.dart' as noti;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    noti.Notification.initState();
    listenNotifications();
  }

  void listenNotifications() => noti.Notification.onNotifications;

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

  Location initialLocation = Location(
    latitude: -23.569953,
    longitude: -46.635863,
    address: '',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cars App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CarsPage(),
        MapPage.routeName: (context) => MapPage(carLocation, houseLocation),
        PickLocationPage.routeName: (context) =>
            PickLocationPage(initialLocation: initialLocation),
      },
    );
  }
}

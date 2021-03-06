// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, unnecessary_null_comparison

// This whole script is kinda a mess
// Please don't mind
// This is our first flutter app without following a tutorial through the whole app

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import '../helpers/location_helper.dart';
import '../models/location.dart' as loc;
import '../widgets/main_drawer.dart';
import '../widgets/car_item.dart';
import '../models/notification.dart' as noti;
import './pick_location_page.dart';

class CarsPage extends StatefulWidget {
  static const linearGradient = LinearGradient(
    colors: [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple
    ],
    begin: FractionalOffset(-0.1, 0.0),
    end: FractionalOffset(1.1, 0.0),
  );
  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  String? titleInput;
  String? imageInput;
  String? _previewImageUrl;

  CollectionReference cars = FirebaseFirestore.instance.collection('cars');
  late LatLng selectedLocation;

  List<Map<String, dynamic>> carList = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    cars.snapshots().listen(
      (event) {
        for (var element in event.docs) {
          carList.add(
            {
              'name': element['name'],
              'latitude': element['latitude'],
              'longitude': element['longitude'],
              'carAtHome': true,
            },
          );
        }
      },
    );
  }

  // Select location on map when creating car.
  Future<void> _selectOnMap() async {
    selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => PickLocationPage(
          initialLocation: loc.Location(
            latitude: 66.5039,
            longitude: 25.7294,
            address: '',
          ),
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  // Sheet to add new car. Name, Image url, location
  void startAddNewCar(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return Card(
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Car Name'),
                  onChanged: (val) {
                    titleInput = val;
                  },
                ),
                TextField(
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(labelText: 'Image Url'),
                  onChanged: (val) => imageInput = val,
                ),
                SizedBox(
                  height: 150,
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: _previewImageUrl == null
                        ? const Text(
                            'No Location Chosen',
                            textAlign: TextAlign.center,
                          )
                        : Image.network(
                            _previewImageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.map,
                      ),
                      label: const Text('Select on Map'),
                      onPressed: () {
                        _selectOnMap();
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  child: const Text('Add car'),
                  onPressed: () {
                    addCar();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Add car to Firebase
  Future<void> addCar() {
    return cars.add({
      'name': titleInput,
      'imageUrl': imageInput,
      'latitude': selectedLocation.latitude,
      'longitude': selectedLocation.longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: CarsPage.linearGradient,
        title: const Text(
          'Your Cars',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              startAddNewCar(context);
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cars').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamSnapshot.data!.docs;
          //final snapshotDocs = streamSnapshot.data!.docChanges;
          FirebaseFirestore.instance
              .collection('cars')
              .snapshots()
              .listen((event) {
            for (var element in event.docChanges) {
              _sendNotification(element);
            }
          });
          if (streamSnapshot.hasData) {}

          return CarItem(documents);
        },
      ),
    );
  }

  // PLEASE DO NOT EVEN THINK ABOUT READING THIS PART OF THE CODE
  // IT IS A FUCKING MESS
  // JUST COMPLETE NONSENSE AND IT DOENSN'T EVEN WORK CORRECTLY, MAYBE I DON'T KNOW!
  Future<void> _sendNotification(
      DocumentChange<Map<String, dynamic>> element) async {
    String carName = element.doc.get('name');
    var latitude = element.doc.get('latitude');
    var longitude = element.doc.get('longitude');

    for (var i = 0; i < carList.length; i++) {
      if (carName == carList[i]['name']) {
        if (latitude == carList[i]['latitude'] &&
            longitude == carList[i]['longitude']) {
        } else {
          if (latitude != carList[i]['latitude'] ||
              longitude != carList[i]['longitude']) {
            // YAY THIS LATITUDE AND LONGITUDE CALCULATION MAKES SO MUCH SENSE
            // IT ACTUALLY TOOK 2 HOURS TO CALCULATE THIS.
            // AND THIS CALCULATION EXPECTS THAT YOU LIVE AT THE EQUATOR
            if (latitude <= 66.5049 &&
                latitude >= 66.5029 &&
                longitude <= 25.7304 &&
                longitude >= 25.7284) {
              if (!carList[i]['carAtHome']) {
                await noti.Notification.showNotification(
                  title: '$carName at home',
                  body: 'Your car $carName has arrived at your home',
                  payload: '',
                );
                carList[i]['carAtHome'] = true;
                carList[i]['latitude'] = latitude;
                carList[i]['longitude'] = longitude;
              }
            }
            // SAME DUMB LATITUDE ANG LONGITUDE CALCULATION
            // SO MUCH FUN XDDDDDDDDDDDDDD !!!!!!!!!!!!!!!!
            if (latitude >= 66.5049 ||
                latitude <= 66.5029 && longitude >= 25.7304 ||
                longitude <= 25.7284) {
              if (carList[i]['carAtHome']) {
                await noti.Notification.showNotification(
                  title: '$carName left home',
                  body: 'Your car $carName has left your home',
                  payload: '',
                );
                carList[i]['carAtHome'] = false;
                carList[i]['latitude'] = latitude;
                carList[i]['longitude'] = longitude;
              }
            }
          }
        }
      }
    }
  }
}

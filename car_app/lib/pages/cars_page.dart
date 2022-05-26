// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import '../helpers/location_helper.dart';
import '../models/location.dart' as loc;
import '../widgets/main_drawer.dart';
import '../widgets/car_item.dart';
import '../models/notification.dart' as noti;
import 'pick_location_page.dart';

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
    print('added to list');
  }

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
                  decoration: const InputDecoration(labelText: 'Car name'),
                  onChanged: (val) => titleInput = val,
                ),
                TextField(
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(labelText: 'Image url'),
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
        title: const Text('Your Cars'),
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
          final snapshotDocs = streamSnapshot.data!.docChanges;

          _sendNotification(snapshotDocs);
          return CarItem(documents);
        },
      ),
    );
  }

  Future<void> _sendNotification(
      List<DocumentChange<Object?>> snapshotDocs) async {
    for (var element in snapshotDocs) {
      String carName = element.doc.get('name');
      var latitude = element.doc.get('latitude');
      var longitude = element.doc.get('longitude');

      for (var i = 0; i < carList.length; i++) {
        if (carName == carList[i]['name']) {
          if (latitude == carList[i]['latitude'] &&
              longitude == carList[i]['longitude']) {
            print('Car hasn\'t moved since last check');
          } else {
            if (latitude != carList[i]['latitude'] ||
                longitude != carList[i]['longitude']) {
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
                }
              }
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
                }
              }
            }
          }
        }
      }
    }
  }
}

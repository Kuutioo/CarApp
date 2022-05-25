// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../widgets/main_drawer.dart';
import '../widgets/car_item.dart';

class CarsPage extends StatefulWidget {
  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  String? titleInput;

  String? imageInput;

  String? _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: locData.latitude,
      longitude: locData.longitude,
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
                        Icons.location_on,
                      ),
                      label: const Text('Current Location'),
                      onPressed: _getCurrentUserLocation,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.map,
                      ),
                      label: const Text('Select on Map'),
                      onPressed: () {},
                    ),
                  ],
                ),
                ElevatedButton(
                  child: const Text('Add car'),
                  onPressed: () {},
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          return CarItem(documents);
        },
      ),
    );
  }
}

// ignore_for_file: use_key_in_widget_constructors, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/map_page.dart';
import '../models/location.dart';
import '../models/notification.dart' as noti;

class CarItem extends StatelessWidget {
  final documents;
  final Location? carLocation = Location(
    latitude: 0,
    longitude: 0,
    address: '',
  );

  final Location? houseLocation = Location(
    latitude: 0,
    longitude: 0,
    address: '',
  );

  CarItem(this.documents);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: ((context, index) {
        return Stack(
          children: [
            MaterialButton(
              padding: const EdgeInsets.all(10),
              textColor: Theme.of(context).primaryColor,
              elevation: 8.0,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        documents[index]['imageUrl'],
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('home')
                    .snapshots()
                    .listen((event) {
                  event.docs.forEach((element) {
                    houseLocation?.latitude = element['latitude'];
                    houseLocation?.longitude = element['longitude'];
                  });
                });
                carLocation?.latitude = documents[index]['latitude'];
                carLocation?.longitude = documents[index]['longitude'];

                if (carLocation!.latitude <= 66.5049 &&
                    carLocation!.latitude >= 66.5029 &&
                    carLocation!.longitude <= 25.7304 &&
                    carLocation!.longitude >= 25.7284) {
                  print('Car at home');
                }
                noti.Notification.showNotification(
                  title: 'Test',
                  body: 'Test text if work',
                  payload: '',
                );
                Navigator.pushNamed(
                  context,
                  MapPage.routeName,
                  arguments: {
                    'carLocation': carLocation,
                    'houseLocation': houseLocation,
                    'focusCar': true,
                  },
                );
              },
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                child: Text(
                  documents[index]['name'],
                  style: const TextStyle(fontSize: 31, color: Colors.white),
                ),
                color: Colors.black38,
              ),
            ),
          ],
        );
      }),
    );
  }
}

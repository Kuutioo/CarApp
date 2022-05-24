// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/location.dart';
import '../pages/car_location_page.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  final Location houseLocation = Location(
    latitude: 0,
    longitude: 0,
    address: '',
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('home').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamSnapshot.data!.docs;
          return Drawer(
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).primaryColor,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('Cars',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                buildListTile(
                  'Your cars',
                  Icons.car_repair,
                  () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                buildListTile(
                  'Your house',
                  Icons.house,
                  () {
                    FirebaseFirestore.instance
                        .collection('cars')
                        .snapshots()
                        .listen((event) {});
                    houseLocation.latitude = documents[0]['latitude'];
                    houseLocation.longitude = documents[0]['longitude'];
                    Navigator.of(context).pushReplacementNamed(
                        CarLocationPage.routeName,
                        arguments: documents);
                  },
                ),
              ],
            ),
          );
        });
  }
}

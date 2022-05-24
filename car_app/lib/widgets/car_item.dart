// ignore_for_file: use_key_in_widget_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/car_location_page.dart';
import '../models/location.dart';
import '../models/house_location.dart';

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
        return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('home').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final docs = streamSnapshot.data!.docs;
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
                      carLocation?.latitude = documents[index]['latitude'];
                      carLocation?.longitude = documents[index]['longitude'];

                      houseLocation?.latitude = docs[index]['latitude'];
                      houseLocation?.longitude = docs[index]['longitude'];

                      if (carLocation!.latitude <= 66.5049 &&
                          carLocation!.latitude >= 66.5029 &&
                          carLocation!.longitude <= 25.7304 &&
                          carLocation!.longitude >= 25.7284) {
                        print('Car at home');
                      }
                      Navigator.pushNamed(
                        context,
                        CarLocationPage.routeName,
                        arguments: {
                          'carLocation': carLocation,
                          'houseLocation': houseLocation,
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
                        style:
                            const TextStyle(fontSize: 31, color: Colors.white),
                      ),
                      color: Colors.black38,
                    ),
                  ),
                ],
              );
            });
      }),
    );
  }
}

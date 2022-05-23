// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './car_location_page.dart';

class CarsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cars'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('cars').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = streamSnapshot.data!.docs;
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
                        Navigator.pushNamed(
                          context,
                          CarLocationPage.routeName,
                          arguments: {
                            'latitude': documents[index]['latitude'],
                            'longitude': documents[index]['longitude'],
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
                          style: const TextStyle(
                              fontSize: 30, color: Colors.white),
                        ),
                        color: Colors.black38,
                      ),
                    ),
                  ],
                );
              }),
            );
          }),
    );
  }
}

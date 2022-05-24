import 'package:flutter/material.dart';

import '../pages/car_location_page.dart';

class CarItem extends StatelessWidget {
  final documents;

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
                  style: const TextStyle(fontSize: 31, color: Colors.white),
                ),
                color: Colors.black38,
              ),
            ),
          ],
        );
      }),
    );
    ;
  }
}

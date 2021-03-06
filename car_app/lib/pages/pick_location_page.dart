// ignore_for_file: dead_code, use_key_in_widget_constructors, avoid_unnecessary_containers, must_be_immutable

// This script is basically a copy of map_page.dart
// They couldn't be combined easily I guess
// Otherwise it would have been a completely overengireened.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart' as latlng;
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import '../models/location.dart';
import 'cars_page.dart';

class PickLocationPage extends StatefulWidget {
  static const routeName = 'pick-location-page';
  Location initialLocation;
  final bool isSelecting;
  PickLocationPage({required this.initialLocation, this.isSelecting = true});

  @override
  _PickLocationPageState createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  latlng.LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: CarsPage.linearGradient,
        title: const Text('Pick a place'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
              icon: const Icon(Icons.check),
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: latlng.LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude),
          zoom: 13.0,
          onTap: widget.isSelecting
              ? (tapPosition, point) {
                  setState(() {
                    _pickedLocation = point;
                  });
                }
              : null,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/ronanit/cl3bdl44r000l14qo7a0z2rul/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoicm9uYW5pdCIsImEiOiJjbDNiZDdkY2MwNmRpM2NxbmFremxpZGRjIn0.8OROSfi-lqxWNZsgRc2M8w",
            // subdomains: ['a', 'b', 'c'],
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1Ijoicm9uYW5pdCIsImEiOiJjbDNiZDdkY2MwNmRpM2NxbmFremxpZGRjIn0.8OROSfi-lqxWNZsgRc2M8w',
              'id': 'mapbox.mapbox-streets-v8',
            },
          ),
          MarkerLayerOptions(
            markers: _pickedLocation == null
                ? [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: latlng.LatLng(widget.initialLocation.latitude,
                          widget.initialLocation.longitude),
                      builder: (ctx) => Container(
                        child: const Icon(Icons.add_location),
                      ),
                    ),
                  ]
                : [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: latlng.LatLng(_pickedLocation!.latitude,
                          _pickedLocation!.longitude),
                      //point:  latlng.LatLng(-23.5732052, -46.6331934),

                      builder: (ctx) => Container(
                        child: const Icon(Icons.add_location),
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart' as latlng;
import '../models/location.dart';

class PickLocationPage extends StatefulWidget {
  static const routeName = 'pick-location-page';
  Location initialLocation =
      Location(latitude: -23.569953, longitude: -46.635863, address: '');
  final bool isSelecting;
  PickLocationPage({required this.initialLocation, this.isSelecting = true});

  @override
  _PickLocationPageState createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  latlng.LatLng? _pickedLocation;

  void _retPositionMap(dynamic positio, latlng.LatLng direct) {
    setState(() {
      _pickedLocation = direct;
      //print(_pickedLocation!.latitude);
    });
    //print(positio.runtimeType);
    // print(direct.latitude);
    // print(direct.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a place'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
              icon: Icon(Icons.check),
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          //center: latlng.LatLng(-23.569953, -46.635863),
          center: latlng.LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude),
          zoom: 14.0,
          //onTap: _handleTap,
          onTap: true ? _retPositionMap : null,
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
            attributionBuilder: (_) {
              return Text("© Done by demianescobar@gmail.com");
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
                        child: Icon(Icons.add_location),
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
                        child: Icon(Icons.add_location),
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, dead_code

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;

import '../models/car_location.dart';
import '../helpers/location_helper.dart';

class CarLocationPage extends StatefulWidget {
  final CarLocation? initialLocation;
  CarLocationPage({
    this.initialLocation = const CarLocation(
      latitude: -23.569953,
      longitude: -46.635863,
      address: '',
    ),
  });

  @override
  State<CarLocationPage> createState() => _CarLocationPageState();
}

class _CarLocationPageState extends State<CarLocationPage> {
  static const STYLE_KEY =
      'pk.eyJ1IjoiYXBpbmFtZXN0YXJpMTIiLCJhIjoiY2wzYmJ0Ynk3MGM1ZDNjb2lkeTNpbDY5YiJ9.IqeKa6IY3F3Eu-faaPyMrQ';
  String? address;

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  Future<void> _getAddress() async {
    address = await LocationHelper.getPlaceAddress(
      widget.initialLocation!.latitude,
      widget.initialLocation!.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Car Location'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: latlng.LatLng(widget.initialLocation!.latitude,
              widget.initialLocation!.longitude),
          zoom: 15.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/apinamestari12/cl3ime15u000c15qutuskeny3/tiles/256/{z}/{x}/{y}@2x?access_token=$STYLE_KEY',
            additionalOptions: {
              'accessToken': STYLE_KEY,
              'id': 'mapbox.mapbox-streets-v8',
            },
          ),
          MarkerLayerOptions(markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: latlng.LatLng(widget.initialLocation!.latitude,
                  widget.initialLocation!.longitude),
              builder: (ctx) => const Icon(
                Icons.add_location,
                color: Colors.red,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

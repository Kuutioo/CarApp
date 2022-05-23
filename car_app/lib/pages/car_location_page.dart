// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, dead_code

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;

import '../models/car_location.dart';
import '../helpers/location_helper.dart';

class CarLocationPage extends StatefulWidget {
  static const routeName = 'car-location-page';

  final CarLocation? carLocation;
  CarLocationPage({
    this.carLocation = const CarLocation(
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
    final addressString = await LocationHelper.getPlaceAddress(
      widget.carLocation!.latitude,
      widget.carLocation!.longitude,
    );
    setState(() {
      address = addressString;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    print(arguments['latitude']);
    print(arguments['longitude']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Car Location'),
      ),
      body: address == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: latlng.LatLng(widget.carLocation!.latitude,
                        widget.carLocation!.longitude),
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
                        width: 30.0,
                        height: 30.0,
                        point: latlng.LatLng(widget.carLocation!.latitude,
                            widget.carLocation!.longitude),
                        builder: (ctx) => const Icon(
                          Icons.add_location,
                          color: Colors.red,
                        ),
                      ),
                    ]),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black54,
                    child: Text(
                      '$address',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
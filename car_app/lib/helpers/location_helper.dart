// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;

const MAPBOX_API_KEY =
    'pk.eyJ1IjoiYXBpbmFtZXN0YXJpMTIiLCJhIjoiY2wzaWt5NGMzMDAyNjNicXkwMnNocmxlMiJ9.qRmY8u7p2y0bc2ZWnzTrJg';

class LocationHelper {
  static String generateLocationPreviewImage(
      {double? latitude, double? longitude}) {
    return 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-l($longitude,$latitude)/$longitude,$latitude,14.25,0,60/600x300?access_token=$MAPBOX_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?limit=1&access_token=$MAPBOX_API_KEY');
    final response = await http.get(url);
    return json.decode(response.body)['features'][0]['place_name'];
  }
}

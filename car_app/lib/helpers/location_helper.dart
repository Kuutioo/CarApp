import 'dart:convert';

import 'package:http/http.dart' as http;

const MAPBOX_API_KEY =
    'pk.eyJ1IjoiYXBpbmFtZXN0YXJpMTIiLCJhIjoiY2wzaWt5NGMzMDAyNjNicXkwMnNocmxlMiJ9.qRmY8u7p2y0bc2ZWnzTrJg';

class LocationHelper {
  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?limit=1&access_token=$MAPBOX_API_KEY');
    final response = await http.get(url);
    return json.decode(response.body)['features'][0]['place_name'];
  }
}
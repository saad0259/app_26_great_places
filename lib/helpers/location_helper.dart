import 'dart:convert';

import 'package:http/http.dart' as http;
const GOOGLE_API = 'AIzaSyDGVdifKHexYzYZjIF615HPm5e00AzqO4g';

class LocationHelper {
  static String generateLocationPreview(
      {required double latitude, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=14&size=600x300&maptype=roadmap &markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API';
  }


  static Future<String> getPlaceAddress(double lat, double lng) async{
    final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API');
    final response = await http.get(url);
    return jsonDecode(response.body)['results'][0]['formatted_address'];
  }
}

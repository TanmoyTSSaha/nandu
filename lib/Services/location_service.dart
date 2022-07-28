// import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../.env.dart';

class LocationService {
  final String key = googleAPIKey;

  Future<String> getPlaceId(String input) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

      var response = await http.get(Uri.parse(url));
      Map json = jsonDecode(response.body) as Map;

      var placeId = json['candidates'][0]['place_id'] as String;
      log("place id is => $placeId");

      return placeId;
    } catch (error) {
      log(error.toString());
      return '';
    }
  }

  Future<String> getPlace(String input) async {
    try {
      log("get place called");
      log(input.toString());
      String placeId = await getPlaceId(input);
      final String uri =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

      var response = await http.get(Uri.parse(uri));
      // log(response.body.toString());
      Map data = jsonDecode(response.body) as Map;
      log(data.toString());
      String formattedAddress = data["result"]["formatted_address"];
      return formattedAddress;
    } catch (error) {
      log(error.toString());
      return "";
    }
  }
}

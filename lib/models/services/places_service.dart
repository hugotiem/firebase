import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:pts/models/place_search.dart';

class PlacesService {
  final String key = 'AIzaSyCDBAhNu6GKuG36pL0e3VvKUfx4cizUapM';

  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    Uri url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(regions)&components=country:fr&key=$key",
    );

    try {
      http.Response response = await http.get(url);

      var json = convert.jsonDecode(response.body);
      var jsonResult = json['predictions'] as List;

      return jsonResult.map((place) => PlaceSearch.fromJson(place)).toList();
    } catch (e) {
      print(e);
      return [PlaceSearch(description: "Aucune connexion", placeId: "none")];
    }
  }
}

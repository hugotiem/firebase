import 'package:flutter/material.dart';
import 'package:pts/Model/place_search.dart';
import 'package:pts/Model/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {
  final PlacesService placesService = new PlacesService();

  // VARIABLES
  List<PlaceSearch> searchResults = [];

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:pts/Model/place_search.dart';
import 'package:pts/Model/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {
  final PlacesService placesService = new PlacesService();
  String _term = "";

  // VARIABLES
  List<PlaceSearch> searchResults = [];

  searchPlaces(String searchTerm) async {
    String _search = searchTerm.trimLeft();
    if (_search.length != 0 && _term.compareTo(_search) != 0) {
      searchResults = await placesService.getAutocomplete(_search);
      notifyListeners();
    } else {
      searchResults = [];
    }
    _term = _search;
  }
}

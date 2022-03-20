import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pts/pages/search/sliver/items.dart';

class MapViewPage extends StatefulWidget {
  final String result;
  const MapViewPage({Key? key, required this.result}) : super(key: key);

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  GoogleMapController? mapController;
  Completer<GoogleMapController> mapControllerCompleter =
      Completer<GoogleMapController>();

  double longitude = 0;
  double latitude = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition:
                CameraPosition(target: LatLng(latitude, longitude), zoom: 14),
            onMapCreated: (controller) {
              mapController = controller;

              mapControllerCompleter
                  .complete(controller..setMapStyle(mapStyle));
            },
          ),
        ],
      ),
    );
  }

  Future<void> _getCoordinates(String? result) async {
    print("results = $result");
    String? res = result;
    if (res == null) return;
    List<Location> coordinates = await locationFromAddress(res.split(',')[0]);

    Location place = coordinates[0];
    double longitude = place.longitude;
    double latitude = place.latitude;

    setState(() {
      this.longitude = longitude;
      this.latitude = latitude;
      mapController
          ?.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
    });
  }
}

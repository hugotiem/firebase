import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/pages/search/sliver/items.dart';

class MapViewPage extends StatefulWidget {
  final String result;
  final bool hasDate;
  final DateTime? date;
  final List<DateTime>? months;
  MapViewPage(
      {Key? key,
      required this.result,
      this.date,
      this.months,
      this.hasDate = false})
      : assert(
            !hasDate ^
                (hasDate &&
                    (date != null || (months != null && months.isNotEmpty))),
            "date or month must not be null because hasDate != false");

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
  void initState() {
    _getCoordinates(widget.result);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        if (widget.hasDate) {
          if (widget.date != null) {
            return PartiesCubit()
              ..fetchPartiesByDateWithWhereIsEqualTo(
                  "city", widget.result, widget.date!);
          }
          return PartiesCubit()
            ..fetchPartiesByMonthsWithWhereIsEqualTo(
                "city", widget.result, widget.months!);
        }
        return PartiesCubit()
          ..fetchPartiesWithWhereIsEqualTo("city", widget.result);
      },
      child: BlocBuilder<PartiesCubit, PartiesState>(builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 70,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                icon: Image.asset("assets/back-btn.png"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          body: Stack(
            children: [
              GoogleMap(
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude), zoom: 14),
                onMapCreated: (controller) {
                  mapController = controller;

                  mapControllerCompleter
                      .complete(controller..setMapStyle(mapStyle));
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20)
                    .add(EdgeInsets.only(top: 100)),
                color: Colors.white.withOpacity(0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide()),
                      ),
                      child: Text(widget.result),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Text("date"),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
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

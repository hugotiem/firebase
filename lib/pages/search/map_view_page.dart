import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/party_card.dart';
import 'package:pts/const.dart';
import 'package:pts/pages/search/sliver/items.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  final GlobalKey _seachDetailsKey = GlobalKey();

  GoogleMapController? mapController;
  Completer<GoogleMapController> mapControllerCompleter =
      Completer<GoogleMapController>();

  double? longitude;
  double? latitude;

  double? _searchContainerHeight = 0;

  bool _loadingScreen = true;
  bool _hasOpacity = true;

  @override
  void initState() {
    _getCoordinates(widget.result);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        _searchContainerHeight = _seachDetailsKey.currentContext?.size?.height;
      });
    });

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
        var parties = state.parties;
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
              SlidingUpPanel(
                borderRadius: BorderRadius.circular(40),
                snapPoint: 0.5,
                maxHeight: MediaQuery.of(context).size.height -
                    (_searchContainerHeight ?? 0) +
                    20,
                body: Stack(
                  children: [
                    if (longitude != null && latitude != null)
                      GoogleMap(
                        myLocationButtonEnabled: false,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(latitude!, longitude!), zoom: 14),
                        onMapCreated: (controller) {
                          mapController = controller;

                          mapControllerCompleter
                              .complete(controller..setMapStyle(mapStyle));

                          Future.delayed(const Duration(milliseconds: 200))
                              .then((value) =>
                                  setState(() => _hasOpacity = false));
                        },
                      ),
                  ],
                ),
                panelBuilder: (scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 8,
                          width: 50,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: SECONDARY_COLOR,
                          ),
                        ),
                        Builder(builder: (context) {
                          if (parties == null) {
                            return Container();
                          }
                          return Expanded(
                            child: ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return PartyCard(party: parties[index]);
                                }),
                          );
                        })
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                key: _seachDetailsKey,
                top: 100,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.white, width: 2)),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Text(
                          widget.result,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Colors.white, width: 2))),
                              child: Builder(builder: (context) {
                                String _date;
                                if (widget.date != null) {
                                  _date = DateFormat.yMMMEd('fr')
                                      .format(widget.date!);
                                } else {
                                  _date = "";
                                }
                                return Text(
                                  _date,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                );
                              }),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Filtre",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Icon(
                                    Icons.sort,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_loadingScreen)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _hasOpacity ? 1 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          SECONDARY_COLOR,
                          ICONCOLOR,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                  onEnd: () => setState(() {
                    _loadingScreen = false;
                  }),
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

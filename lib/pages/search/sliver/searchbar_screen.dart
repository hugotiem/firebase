import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/blocs/search/search_cubit.dart';
import 'package:pts/const.dart';
import 'package:pts/models/party.dart';
import 'package:pts/pages/search/sliver/searchbar.dart';
import 'package:pts/components/party_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math' as math;

class SearchBarScreen extends StatefulWidget {
  SearchBarScreen({Key? key}) : super(key: key);

  @override
  _SearchBarScreenState createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen>
    with TickerProviderStateMixin {
  PanelController _resultsPanelController = PanelController();
  PanelController _searchPanelController = PanelController();
  late AnimationController _animationController;
  GoogleMapController? mapController;
  Completer<GoogleMapController> mapControllerCompleter =
      Completer<GoogleMapController>();

  bool _hasResults = false;
  bool _isDissmissed = false;

  double _factor = 0;
  double _rotation = 0;

  SystemUiOverlayStyle _systemUiOverlayStyle = SystemUiOverlayStyle.dark;

  // to save panel position
  // ignore: unused_field
  double? _panelPosition;

  // coordinates
  double? longitude;
  double? latitude;

  // Google maps style
  String? mapStyle = '''
  
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#242f3e"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#746855"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#242f3e"
        }
      ]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#d59563"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#d59563"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#263c3f"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#6b9a76"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#38414e"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#212a37"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9ca5b3"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#746855"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#1f2835"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#f3d19c"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#2f3948"
        }
      ]
    },
    {
      "featureType": "transit.station",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#d59563"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#17263c"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#515c6d"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#17263c"
        }
      ]
    }
  ]
  
  ''';

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarkers(List<Party>? parties) {
    return Set.from(
      parties?.map(
            (e) => Marker(
              markerId: MarkerId(e.id),
              infoWindow: InfoWindow(title: e.name, snippet: e.desc),
              position: LatLng(e.coordinates[1], e.coordinates[0]),
            ),
          ) ??
          [],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    // print(_result);
    return Scaffold(
      backgroundColor: SECONDARY_COLOR,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // ignore: deprecated_member_use
        systemOverlayStyle: _systemUiOverlayStyle,
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (_) => SearchCubit(),
        child: BlocProvider(
          create: (_) => PartiesCubit(),
          child: Stack(
            children: [
              BlocBuilder<PartiesCubit, PartiesState>(
                builder: (context, state) {
                  if (longitude == null || latitude == null)
                    return Center(child: CircularProgressIndicator());
                  return GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                      mapControllerCompleter
                          .complete(controller..setMapStyle(mapStyle));
                    },
                    initialCameraPosition: CameraPosition(
                        target: LatLng(latitude!, longitude!), zoom: 14),
                    mapType: MapType.normal,
                    markers: state.parties == null
                        ? const <Marker>{}
                        : _buildMarkers(state.parties),
                  );
                },
              ),
              // afficher la carte soit paris si loc désactivé sinon location actuelle
              Column(
                children: <Widget>[
                  Container(
                    width: _size.width,
                    color: PRIMARY_COLOR.withOpacity(1 - _factor),
                    padding: EdgeInsets.only(top: 50, bottom: 40),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Transform.rotate(
                            angle: _isDissmissed
                                ? (-90 * _rotation) * math.pi / 180
                                : 0,
                            child: IconButton(
                              icon: Icon(
                                Ionicons.arrow_back_outline,
                                color:
                                    _factor == 1 ? ICONCOLOR : SECONDARY_COLOR,
                              ),
                              onPressed: () async {
                                if (!_isDissmissed || _hasResults)
                                  Navigator.of(context).pop();
                                else {
                                  FocusScope.of(context).unfocus();

                                  _searchPanelController
                                      .close()
                                      .whenComplete(() => setState(() {
                                            _hasResults = true;
                                          }));
                                  setState(() {
                                    if (!_resultsPanelController.isPanelOpen) {
                                      _factor = 0;
                                      _systemUiOverlayStyle =
                                          SystemUiOverlayStyle.light;
                                    }
                                  });

                                  _animationController.animateTo(0,
                                      curve: Curves.ease);
                                  _animationController.addListener(() {
                                    setState(() {
                                      _rotation = _animationController.value;
                                    });
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        BlocBuilder<SearchCubit, SearchState>(
                            builder: (context, state) {
                          return Expanded(
                            flex: 8,
                            child: Container(
                              child: SearchBar(
                                onChanged: (value) {
                                  BlocProvider.of<SearchCubit>(context)
                                      .fetchResults(value);
                                },
                                onTap: () {
                                  setState(() {
                                    _hasResults = false;
                                    _systemUiOverlayStyle =
                                        SystemUiOverlayStyle.dark;
                                  });

                                  _searchPanelController.open();
                                  _panelPosition =
                                      _resultsPanelController.panelPosition;
                                  _animationController.animateTo(1,
                                      curve: Curves.ease);

                                  _animationController.addListener(() {
                                    setState(() {
                                      if (!_resultsPanelController.isPanelOpen)
                                        _factor =
                                            1 - _animationController.value;
                                      _rotation = _animationController.value;
                                    });
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: _size.height - 150,
                        child: SlidingUpPanel(
                          isDraggable: _isDissmissed,
                          defaultPanelState: PanelState.OPEN,
                          controller: _resultsPanelController,
                          snapPoint: 0.5,
                          minHeight: 100,
                          maxHeight: _size.height - 150,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36 * _factor),
                            topRight: Radius.circular(36 * _factor),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              blurRadius: 8.0 * _factor,
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                            ),
                          ],
                          panelBuilder: (ScrollController sc) {
                            return _isDissmissed
                                ? Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(36 * _factor),
                                        topRight: Radius.circular(36 * _factor),
                                      ),
                                      color: PRIMARY_COLOR,
                                    ),
                                    child:
                                        BlocBuilder<PartiesCubit, PartiesState>(
                                            builder: (context, state) {
                                      var parties = state.parties;

                                      if (parties == null)
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );

                                      return ListView.builder(
                                        controller: sc,
                                        itemCount: parties.length,
                                        itemBuilder: (context, index) {
                                          return buildPartyCard(
                                            context,
                                            parties[index],
                                          );
                                          // return Container(
                                          //   margin: EdgeInsets.all(20),
                                          //   height: 100,
                                          //   decoration: BoxDecoration(
                                          //     borderRadius: BorderRadius.all(
                                          //       Radius.circular(10),
                                          //     ),
                                          //     color: Colors.white,
                                          //   ),
                                          // );
                                        },
                                      );
                                    }),
                                  )
                                : BlocBuilder<SearchCubit, SearchState>(
                                    builder: (context, state) {
                                      var results = state.results;
                                      if (results == null) return Container();
                                      return Container(
                                        color: PRIMARY_COLOR,
                                        child: ListView.builder(
                                          padding: EdgeInsets.all(0),
                                          itemCount: results.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                results[index].description!,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                String? desc =
                                                    results[index].description;
                                                _getCoordinates(desc);
                                                BlocProvider.of<PartiesCubit>(
                                                        context)
                                                    .fetchPartiesWithWhereIsEqualTo(
                                                        "city",
                                                        desc?.split(",")[0]);
                                                setState(() {
                                                  _hasResults = true;
                                                  _resultsPanelController
                                                      .animatePanelToSnapPoint(
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.ease,
                                                  );
                                                  _isDissmissed = true;
                                                  _animationController
                                                      .animateTo(0,
                                                          curve: Curves.ease);
                                                  _animationController
                                                      .addListener(() {
                                                    setState(() {
                                                      _rotation =
                                                          _animationController
                                                              .value;
                                                    });
                                                  });
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                          },
                          onPanelSlide: (position) {
                            setState(() {
                              if (position >= 0.8) {
                                _factor = 1 - ((position * 5) - 4);
                                _systemUiOverlayStyle =
                                    SystemUiOverlayStyle.dark;
                              } else if (position < 0.8) {
                                _factor = 1;
                                _systemUiOverlayStyle =
                                    SystemUiOverlayStyle.light;
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        height: _hasResults ? 0 : _size.height - 150,
                        child: SlidingUpPanel(
                          minHeight: 0,
                          maxHeight: _size.height - 150,
                          controller: _searchPanelController,
                          boxShadow: [],
                          panelBuilder: (sc) =>
                              BlocBuilder<SearchCubit, SearchState>(
                            builder: (context, state) {
                              var results = state.results;
                              if (results == null)
                                return CircularProgressIndicator();
                              return Container(
                                color: PRIMARY_COLOR,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  itemCount: results.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        results[index].description!,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          _hasResults = true;
                                          _isDissmissed = true;
                                        });
                                        String? desc =
                                            results[index].description;
                                        _getCoordinates(desc);
                                        BlocProvider.of<PartiesCubit>(context)
                                            .fetchPartiesWithWhereIsEqualTo(
                                                "city", desc?.split(",")[0]);
                                        _resultsPanelController
                                            .animatePanelToSnapPoint(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );
                                        _animationController.animateTo(0,
                                            curve: Curves.ease);
                                        _animationController.addListener(() {
                                          setState(() {
                                            _rotation =
                                                _animationController.value;
                                          });
                                        });
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
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

    print("update coordinates : $longitude and $latitude");

    setState(() {
      this.longitude = longitude;
      this.latitude = latitude;
      mapController
          ?.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
    });
  }
}

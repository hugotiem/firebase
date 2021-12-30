import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/blocs/search/search_cubit.dart';
import 'package:pts/const.dart';
import 'package:pts/models/party.dart';
import 'package:pts/pages/search/sliver/calendar_screen.dart';
import 'package:pts/pages/search/sliver/filter_screen.dart';
import 'package:pts/pages/search/sliver/items.dart';
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
  // controllers
  final PanelController _resultsPanelController = PanelController();
  final PanelController _searchPanelController = PanelController();
  final PanelController _filterPanelController = PanelController();
  late AnimationController _animationController;
  late AnimationController _mapAnimationController;
  GoogleMapController? mapController;
  Completer<GoogleMapController> mapControllerCompleter =
      Completer<GoogleMapController>();

  final FocusNode focusNode = FocusNode();

  // privates variables
  bool _hasResults = false;
  bool _isDissmissed = false;
  int _index = 0;
  String result = "";
  double _factor = 0;
  double _rotation = 0;

  double _opacity = 0;

  DateTime _selectedDate = DateTime.now();

  SystemUiOverlayStyle _systemUiOverlayStyle = SystemUiOverlayStyle.dark;

  // to save panel position
  // ignore: unused_field
  double _panelPosition = 0;

  // coordinates
  double? longitude;
  double? latitude;

  Set<Marker> markers = Set<Marker>();
  // Google maps style

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _mapAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {
          _opacity = _mapAnimationController.value;
        });
      });
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
              position: LatLng(
                  e.approximativeCoordinates[1], e.approximativeCoordinates[0]),
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
                  return Container(
                    child: Opacity(
                      opacity: _opacity,
                      child: GoogleMap(
                        compassEnabled: false,
                        onMapCreated: (controller) {
                          mapController = controller;
                          mapControllerCompleter
                              .complete(controller..setMapStyle(mapStyle));
                          _mapAnimationController.forward();
                        },
                        initialCameraPosition: CameraPosition(
                            target: LatLng(latitude!, longitude!), zoom: 14),
                        mapType: MapType.normal,
                        markers: state.parties == null
                            ? const <Marker>{}
                            : _buildMarkers(state.parties),
                      ),
                    ),
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
                    child: BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, state) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Transform.rotate(
                              angle: _isDissmissed
                                  ? (-90 * _rotation) * math.pi / 180
                                  : 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: _factor == 1
                                      ? ICONCOLOR
                                      : SECONDARY_COLOR,
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
                                      if (!_resultsPanelController
                                          .isPanelOpen) {
                                        _factor = 0;
                                        _systemUiOverlayStyle =
                                            SystemUiOverlayStyle.light;
                                      }
                                      _index = 1;
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
                          Expanded(
                            flex: 8,
                            child: IndexedStack(
                              index: _index,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    SearchBar(
                                      onChanged: (value) {
                                        BlocProvider.of<SearchCubit>(context)
                                            .fetchResults(value);
                                      },
                                      focusNode: focusNode,
                                    ),
                                    Positioned(
                                      bottom: -60,
                                      left: -30,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Text(
                                          "Résultats :",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          width: double.infinity,
                                          child: Text(result),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () => setState(() {
                                          focusNode.requestFocus();
                                          _index = 0;
                                          _hasResults = false;
                                          _systemUiOverlayStyle =
                                              SystemUiOverlayStyle.dark;

                                          _searchPanelController.open();
                                          // _panelPosition =
                                          //     _resultsPanelController
                                          //         .panelPosition;
                                          _animationController.animateTo(1,
                                              curve: Curves.ease);

                                          _animationController.addListener(() {
                                            setState(() {
                                              if (!_resultsPanelController
                                                  .isPanelOpen)
                                                _factor = 1 -
                                                    _animationController.value;
                                              _rotation =
                                                  _animationController.value;
                                            });
                                          });
                                        }),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 14, bottom: 14),
                                                  child: Text(
                                                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                                    overflow: TextOverflow.fade,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                BuildContext mainContext =
                                                    context;
                                                showModalBottomSheet(
                                                  context: context,
                                                  constraints: BoxConstraints(
                                                      maxHeight: 600),
                                                  builder: (context) =>
                                                      CalendarScreen(
                                                    currentDay: _selectedDate,
                                                    focusedDay: _selectedDate,
                                                    onClose: (date) {
                                                      setState(() {
                                                        _selectedDate = date;
                                                      });
                                                      BlocProvider.of<
                                                                  PartiesCubit>(
                                                              mainContext)
                                                          .fetchPartiesByDateWithWhereIsEqualTo(
                                                              'city',
                                                              result.split(
                                                                  ", ")[0],
                                                              date);
                                                    },
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                    ),
                                                  ),
                                                  clipBehavior: Clip.antiAlias,
                                                  isScrollControlled: true,
                                                );
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Filtre"),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Icon(
                                                        Icons.sort_rounded),
                                                  ),
                                                ],
                                              ),
                                              onTap: () =>
                                                  _filterPanelController
                                                      .animatePanelToSnapPoint(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      200),
                                                          curve: Curves.ease),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: _size.height - 195,
                        child: SlidingUpPanel(
                          isDraggable: _isDissmissed,
                          defaultPanelState: PanelState.OPEN,
                          controller: _resultsPanelController,
                          snapPoint: 0.5,
                          minHeight: 100,
                          maxHeight: _size.height - 195,
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

                                      if (parties.isEmpty) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical:
                                                  30 + _panelPosition * 120),
                                          child: Text(
                                            "Aucun résultat ne correspond à ta recherche... \nRegarde pour une autre date !",
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }

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
                                                if (desc != result) {
                                                  BlocProvider.of<PartiesCubit>(
                                                          context)
                                                      .fetchPartiesByDateWithWhereIsEqualTo(
                                                    "city",
                                                    desc?.split(",")[0],
                                                    DateTime.now(),
                                                  );
                                                }

                                                setState(() {
                                                  _hasResults = true;
                                                  _index = 1;
                                                  result = results[index]
                                                      .description!;
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
                              _panelPosition = position;
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
                        height: _hasResults ? 0 : _size.height - 195,
                        child: SlidingUpPanel(
                          isDraggable: false,
                          minHeight: 0,
                          maxHeight: _size.height - 195,
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
                                          _index = 1;
                                          result = results[index].description!;
                                          _systemUiOverlayStyle =
                                              SystemUiOverlayStyle.light;
                                        });
                                        String? desc =
                                            results[index].description;
                                        _getCoordinates(desc);
                                        if (desc != result) {
                                          BlocProvider.of<PartiesCubit>(context)
                                              .fetchPartiesByDateWithWhereIsEqualTo(
                                            "city",
                                            desc?.split(",")[0],
                                            DateTime.now(),
                                          );
                                        }

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
              SlidingUpPanel(
                minHeight: 0,
                maxHeight: MediaQuery.of(context).size.height - 50,
                panelBuilder: (ScrollController sc) {
                  return FilterScreen(
                    sc: sc,
                    context: context,
                  );
                },
                controller: _filterPanelController,
                backdropEnabled: true,
                snapPoint: 0.7,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.transparent,
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

    setState(() {
      this.longitude = longitude;
      this.latitude = latitude;
      mapController
          ?.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
    });
  }
}

import 'dart:async';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/blocs/search/search_cubit.dart';
import 'package:pts/components/components_export.dart';
import 'package:pts/components/party_card/party_card.dart';
import 'package:pts/const.dart';
import 'package:pts/models/party.dart';
import 'package:pts/pages/search/search_page.dart';
import 'package:pts/pages/search/items.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapViewPage extends StatefulWidget {
  final bool hasDate;
  final DateTime? date;
  final List<DateTime>? months;

  MapViewPage({Key? key, this.date, this.months, this.hasDate = false})
      : assert(
            !hasDate ^
                (hasDate &&
                    (date != null || (months != null && months.isNotEmpty))),
            "date or month must not be null because hasDate != false");

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  late String? _destination;

  final GlobalKey _seachDetailsKey = GlobalKey();

  GoogleMapController? mapController;
  Completer<GoogleMapController> mapControllerCompleter =
      Completer<GoogleMapController>();

  double? _longitude;
  double? _latitude;

  double? _searchContainerHeight = 0;

  bool _loadingScreen = true;
  bool _hasOpacity = true;

  GlobalKey _globalKey = GlobalKey();

  CameraPosition? _position;

  late DateTime? _date;
  late List<DateTime>? _months;

  BitmapDescriptor icon = BitmapDescriptor.defaultMarker;

  List<PartyMarker> _markerWidgets = [];

  Set<Marker> _markers = Set();

  @override
  void initState() {
    _date = widget.date;
    _months = widget.months;

    _destination = BlocProvider.of<SearchCubit>(context).state.destination;
    _getCoordinates(_destination);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _searchContainerHeight = _seachDetailsKey.currentContext?.size?.height;
      });
      // widgetToIcon(_globalKey).then((value) => setState(() => icon = value));
    });

    super.initState();
  }

  Future<Set<Marker>> _buildMarkers(List<PartyMarker>? markersWidgets) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var list = [];
    for (PartyMarker item in markersWidgets ?? []) {
      var _icon = await widgetToIcon(item.globalKey);
      list.add(Marker(
          markerId: MarkerId(item.id),
          icon: _icon ?? BitmapDescriptor.defaultMarker,
          position: item.coordinates));
    }
    return Set.from(list);
  }

  List<PartyMarker> _buildMarkersWidget(List<Party>? parties) {
    return parties?.map<PartyMarker>((e) {
          GlobalKey _key = GlobalKey();
          return PartyMarker(
            title: e.name ?? "",
            theme: e.theme ?? "",
            globalKey: _key,
            id: e.id ?? "",
            coordinates: LatLng(e.approximativeCoordinates?[1] ?? 0,
                e.approximativeCoordinates?[0] ?? 0),
          );
        }).toList() ??
        [];
  }

  Future<BitmapDescriptor?> widgetToIcon(GlobalKey globalKey) async {
    if (globalKey.currentContext == null) return null;
    RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    if (boundary.debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
    }
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(builder: (context, state) {
      _destination = state.destination;
      return BlocProvider(
        create: (context) {
          if (widget.hasDate) {
            if (widget.date != null) {
              return PartiesCubit()
                ..fetchPartiesByDateWithWhereIsEqualTo(
                    "city", _destination, widget.date!);
            }
            return PartiesCubit()
              ..fetchPartiesByMonthsWithWhereIsEqualTo(
                  "city", _destination, widget.months!);
          }
          if (_destination == null) {
            return PartiesCubit();
          }
          return PartiesCubit()
            ..fetchPartiesWithWhereIsEqualTo("city", _destination);
        },
        child: BlocListener<PartiesCubit, PartiesState>(
          listener: (context, state) async {
            if (state.status == PartiesStatus.loaded) {
              // _buildMarkers(_markerWidgets);
            }
          },
          child: BlocBuilder<PartiesCubit, PartiesState>(
              builder: (context, state) {
            var parties = state.parties;
            _markerWidgets = _buildMarkersWidget(parties);
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
                  ..._markerWidgets,
                  SlidingUpPanel(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40)),
                    snapPoint: 0.5,
                    maxHeight: MediaQuery.of(context).size.height -
                        (_searchContainerHeight ?? 0) +
                        20,
                    body: Stack(
                      children: [
                        if (_longitude != null && _latitude != null)
                          FutureBuilder<Set<Marker>>(
                              future: _buildMarkers(_markerWidgets),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                return GoogleMap(
                                  onCameraIdle: () =>
                                      BlocProvider.of<PartiesCubit>(context),
                                  onCameraMove: (position) =>
                                      setState(() => _position = position),
                                  // onCameraIdle: ,
                                  myLocationButtonEnabled: false,
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(_latitude!, _longitude!),
                                      zoom: 14),
                                  onMapCreated: (controller) {
                                    parties?.forEach((element) {
                                      controller.showMarkerInfoWindow(
                                          MarkerId(element.id!));
                                    });

                                    mapController = controller;

                                    mapControllerCompleter.complete(
                                        controller..setMapStyle(mapStyle));

                                    Future.delayed(
                                            const Duration(milliseconds: 200))
                                        .then((value) => setState(
                                            () => _hasOpacity = false));
                                  },
                                  markers: snapshot.data ?? Set(),
                                );
                              }),
                        Positioned(
                          key: _seachDetailsKey,
                          top: 100,
                          left: 0,
                          right: 0,
                          child: SearchInfoContent(
                            result: _destination,
                            date: _date,
                            months: _months,
                            onDateChanged: (date, months) {
                              print(date);
                              if (date != null) {
                                setState(() {
                                  _date = date;
                                  _months = null;
                                });
                              } else {
                                setState(() {
                                  _months = months;
                                  _date = null;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    panelBuilder: (scrollController) {
                      return ResultsListContent(
                        scrollController: scrollController,
                        parties: parties,
                      );
                    },
                  ),
                  if (_loadingScreen)
                    LoadingScreen(
                      pageLoaded: _hasOpacity,
                      onLoadingClosed: () => setState(() {
                        _loadingScreen = false;
                      }),
                    )
                ],
              ),
            );
          }),
        ),
      );
    });
  }

  Future<void> _getCoordinates(String? result) async {
    print("results = $result");
    String? res = result;
    if (res == null) return;
    List<Location> coordinates = await locationFromAddress(res.split(',')[0]);

    Location place = coordinates[0];
    double _longitude = place.longitude;
    double _latitude = place.latitude;

    setState(() {
      this._longitude = _longitude;
      this._latitude = _latitude;
      mapController?.animateCamera(
          CameraUpdate.newLatLng(LatLng(_latitude, _longitude)));
    });
  }
}

Future<void> showCalendar(BuildContext context,
    {DateTime? date,
    List<DateTime>? months,
    void Function(String, dynamic)? onDateChanged}) async {
  showModalBottomSheet(
      isScrollControlled: true,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (context) {
        return Scaffold(
          body: Column(
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CalendarContent(
                    textColor: ICONCOLOR,
                  ),
                ),
              ),
            ],
          ),
        );
      }).then((value) {
    if (onDateChanged != null && value != null) {
      onDateChanged(value["type"], value["value"]);
    }
  });
}

class LoadingScreen extends StatelessWidget {
  final bool pageLoaded;
  final void Function()? onLoadingClosed;
  const LoadingScreen({Key? key, this.pageLoaded = false, this.onLoadingClosed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: pageLoaded ? 1 : 0,
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
      onEnd: onLoadingClosed,
    );
  }
}

class SearchInfoContent extends StatelessWidget {
  final String? result;
  final DateTime? date;
  final List<DateTime>? months;
  final void Function(DateTime?, List<DateTime>?)? onDateChanged;
  const SearchInfoContent(
      {Key? key, this.result, this.date, this.months, this.onDateChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.white, width: 2)),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  result ?? "Saisir une ville",
                  style: AppTextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              onTap: () {
                var last = BlocProvider.of<SearchCubit>(context).state.last;
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => SearchPage(last: last),
                        fullscreenDialog: true))
                    .then((value) {
                  if (value != null) {
                    var _newDestination = value['newResult'];
                    if (date != null) {
                      BlocProvider.of<PartiesCubit>(context)
                          .fetchPartiesByDateWithWhereIsEqualTo(
                              "city", _newDestination, date!);
                    } else if (months != null) {
                      BlocProvider.of<PartiesCubit>(context)
                          .fetchPartiesByMonthsWithWhereIsEqualTo(
                              "city", _newDestination, months!);
                    } else {
                      BlocProvider.of<PartiesCubit>(context)
                          .fetchPartiesWithWhereIsEqualTo(
                              "city", _newDestination);
                    }
                  }
                });
              }),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(color: Colors.white, width: 2))),
                    child: Builder(builder: (context) {
                      String _date = "";
                      if (date != null) {
                        _date = DateFormat.yMMMEd('fr').format(date!);
                      } else if (months != null) {
                        for (DateTime month in months!) {
                          _date += "${DateFormat.MMM("fr").format(month)}";
                          if (months!.last != month) {
                            _date += "-";
                          }
                        }
                      }
                      return Text(
                        _date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle(color: Colors.white, fontSize: 20),
                      );
                    }),
                  ),
                  onTap: () =>
                      showCalendar(context, onDateChanged: (type, value) {
                    var bloc = BlocProvider.of<PartiesCubit>(context);
                    if (type == "date") {
                      bloc.fetchPartiesByDateWithWhereIsEqualTo(
                          "city", result, value);
                      if (onDateChanged != null) {
                        onDateChanged!(value, null);
                      }
                    } else {
                      bloc.fetchPartiesByMonthsWithWhereIsEqualTo(
                          "city", result, value);
                      if (onDateChanged != null) {
                        onDateChanged!(null, value);
                      }
                    }
                  }),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filtre",
                        style: AppTextStyle(color: Colors.white, fontSize: 20),
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
    );
  }
}

class ResultsListContent extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Party>? parties;
  const ResultsListContent({Key? key, this.scrollController, this.parties})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  itemCount: parties!.length,
                  itemBuilder: (context, index) {
                    var party = parties![index];
                    return Column(
                      children: [
                        PartyCard(party: party),
                        PartyCard(party: party),
                        PartyCard(party: party),
                        PartyCard(party: party),
                        PartyCard(party: party),
                        PartyCard(party: party),
                        PartyCard(party: party),
                      ],
                    );
                  }),
            );
          })
        ],
      ),
    );
  }
}

class PartyMarker extends StatelessWidget {
  final GlobalKey globalKey;
  final String id;
  final LatLng coordinates;
  final String title;
  final String theme;

  const PartyMarker(
      {Key? key,
      required this.globalKey,
      required this.id,
      required this.coordinates,
      required this.title,
      required this.theme})
      : super(key: key);

  String getImage() {
    switch (theme) {
      case 'Festive':
        return "assets/festive.jpg";
      case 'Gaming':
        return "assets/gaming.jpg";
      case "Jeux de société":
        return "assets/jeuxdesociete.jpg";
      case "Thème":
        return "assets/theme.jpg";
      default:
        return "assets/festive.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            height: 180,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: AssetImage(getImage())),
            ),
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}

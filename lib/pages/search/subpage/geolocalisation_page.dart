import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/party_card.dart';
import 'package:pts/models/party.dart';
import 'package:pts/pages/search/search_page.dart';

class GeolocationWidget extends StatefulWidget {
  const GeolocationWidget({Key? key}) : super(key: key);

  @override
  _GeolocationWidgetState createState() => _GeolocationWidgetState();
}

class _GeolocationWidgetState extends State<GeolocationWidget> {
  Geolocator geolocator = Geolocator();
  Position? userLocation;
  String? _currentCity;
  // ignore: unused_field
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
      _getcity(
        (String? locality) => setState(() {
          _currentCity = locality;
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentCity == null) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _currentCity == null
              ? Container()
              : TitleText(
                  text: 'Au plus proche de toi',
                  margin: EdgeInsets.only(top: 30, left: 20, bottom: 22),
                ),
          SizedBox(
            height: 250,
            child: BlocProvider(
              create: (context) => PartiesCubit()..fetchActiveParties(),
              child: BlocBuilder<PartiesCubit, PartiesState>(
                  builder: (context, state) {
                var parties = state.parties;
                if (parties == null)
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                else {
                  parties.forEach((element) async {
                    int distance = await _getDistances(element);
                    element.distance = distance;
                  });
                  // trier les soirées dans l'ordre croissant
                  state.parties!.sort((a, b) {
                    if (a.distance == null || b.distance == null) {
                      return 1;
                    }
                    return a.distance!.compareTo(b.distance!);
                  });
                }
                return PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.parties!.length,
                  controller: PageController(),
                  onPageChanged: (int index) => setState(() => _index = index),
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) =>
                      Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: PartyCard(party: state.parties![index]),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    }
  }

  Future<Position?> _getLocation() async {
    var currentLocation;
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      try {
        currentLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
      } catch (e) {
        currentLocation = null;
      }
      return currentLocation;
    } else {
      return currentLocation = null;
    }
  }

  Future<void> _getcity(void Function(String?) onChanged) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          userLocation!.latitude, userLocation!.longitude);

      Placemark place = placemarks[0];

      onChanged(place.locality);
    } catch (e) {
      print(e);
    }
  }

  Future<int> _getDistances(Party party) async {
    double longitude = party.coordinates[0];
    double latitude = party.coordinates[1];

    // calculer la distance entre notre position et celle de la soirée
    double distanceBetweenCoordinates = Geolocator.distanceBetween(
        userLocation!.latitude, userLocation!.longitude, latitude, longitude);

    double distanceInKm = distanceBetweenCoordinates / 1000;
    int distanceInKmRound = distanceInKm.round();

    return distanceInKmRound;
  }
}

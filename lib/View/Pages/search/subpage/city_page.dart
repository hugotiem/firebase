import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/components/party_card.dart';
import 'package:pts/constant.dart';

class GridViewCity extends StatefulWidget {
  @override
  _GridViewCityState createState() => _GridViewCityState();
}

class _GridViewCityState extends State<GridViewCity> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 182,
            child: Container(
              child: Row(children: [
                Column(
                  children: [
                    CityBox('Paris', image: "assets/paris_nuit.jpg"),
                    CityBox('Marseille', image: "assets/marseille_nuit.jpg"),
                  ],
                ),
                Column(
                  children: [
                    CityBox('Lyon', image: "assets/lyon_nuit.jpg"),
                    CityBox('Toulouse', image: "assets/toulouse_nuit.jpg"),
                  ],
                ),
                Column(
                  children: [
                    CityBox('Nice', image: "assets/nice_nuit.jpg"),
                    CityBox('Nantes', image: "assets/nantes_nuit.jpg"),
                  ],
                ),
                Column(
                  children: [
                    CityBox('Strasbourg', image: "assets/strasbourg_nuit.jpg",),
                    CityBox('Montpellier', image: "assets/montpellier_nuit.jpg"),
                  ],
                ),
                Column(
                  children: [
                    CityBox('Bordeaux', image: "assets/bordeaux_nuit.jpg"),
                    CityBox('Lille', image: "assets/lille_nuit.jpg"),
                  ],
                ),
                SizedBox(width: 32)
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class CityBox extends StatelessWidget {
  final String text;
  final String image;

  const CityBox(this.text, {this.image, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 32),
      child: OpenContainer(
        transitionDuration: Duration(milliseconds: 300),
        closedColor: Colors.transparent,
        middleColor: PRIMARY_COLOR,
        openColor: PRIMARY_COLOR,
        closedElevation: 0,
        closedBuilder: (context, returnvalue) {
          return Container(
            height: 75,
            width: 150,
            decoration: BoxDecoration(
              image: image != null
                  ? DecorationImage(image: AssetImage(image), fit: BoxFit.cover)
                  : null,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: CText(
                this.text,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: FOCUS_COLOR,
              ),
            ),
          );
        },
        openBuilder: (context, returnvalue) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: new BackAppBar(
                title: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: CText(
                    this.text,
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            body: BlocProvider(
              create: (context) => PartiesCubit()
                ..fetchPartiesWithWhereIsEqualTo('city', this.text),
              child: BlocBuilder<PartiesCubit, PartiesState>(
                builder: (context, state) {
                  if (state.parties == null)
                    return Center(child: const CircularProgressIndicator());
                  return ListView.builder(
                    itemCount: state.parties.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildPartyCard(context, state.parties[index]),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
  // }
  // Stream<QuerySnapshot> getPartyStreamSnapshot(BuildContext context) async* {
  //   yield* FirebaseFirestore.instance
  //   .collection('party')
  //   .where('city', isEqualTo: this.text)
  //   .snapshots();
  // }
}

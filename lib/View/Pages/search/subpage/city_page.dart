import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/party_card/party_card.dart';

import '../../../../Constant.dart';

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
              child: Row(
                children: [
                  Column(
                    children: [
                      CityBox(
                        text: 'Paris',
                      ),
                      CityBox(
                        text: 'Marseille',
                      )
                    ]
                  ),
                  Column(
                    children: [
                      CityBox(
                        text: 'Lyon',
                      ),
                      CityBox(
                        text: 'Toulouse',
                      )
                    ]
                  ),
                  Column(
                    children: [
                      CityBox(
                        text: 'Nice',
                      ),
                      CityBox(
                        text: 'Nantes',
                      )
                    ]
                  ),
                  Column(
                    children: [
                      CityBox(
                        text: 'Strasbourg',
                      ),
                      CityBox(
                        text: 'Montpellier',
                      )
                    ]
                  ),
                  Column(
                    children: [
                      CityBox(
                        text: 'Bordeaux',
                      ),
                      CityBox(
                        text: 'Lille',
                      )
                    ]
                  ),
                  SizedBox(
                    width: 32
                  )
                ]
              )
            ),
          ),
        ],
      ),
    );
  }
}

class CityBox extends StatelessWidget {
  final String text;
  const CityBox({
    @required this.text,
    Key key 
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 32), 
      child: OpenContainer(
        transitionDuration: Duration(milliseconds: 400),
        closedColor: Colors.transparent,
        openColor: PRIMARY_COLOR,
        closedElevation: 0,
        closedBuilder: (context, returnvalue) {
          return Container(
            height: 75,
            width: 150,
            decoration: BoxDecoration(
              color: SECONDARY_COLOR,
              borderRadius: BorderRadius.circular(15)
              ),
            child: Center(
              child: Text(
                this.text,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: FOCUS_COLOR
              ),
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
                  child: Text(
                    this.text,
                    style: TextStyle(  
                      color: SECONDARY_COLOR,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
            body: BlocProvider(
              create: (context) => PartiesCubit()..fetchPartiesWithWhere('city', this.text),
              child: BlocBuilder<PartiesCubit, PartiesState>( 
                builder: (context, state) {
                  if (state.parties == null) return Center(child: const CircularProgressIndicator());
                  return ListView.builder(
                    itemCount: state.parties.length,
                    itemBuilder: (BuildContext context, int index) =>
                      buildPartyCard(context, state.parties[index])
                  );
                }, 
              )
            )
          );
        }
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

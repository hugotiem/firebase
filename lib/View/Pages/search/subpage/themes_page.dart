import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/party_card.dart';

import '../../../../Constant.dart';

class GridListThemes extends StatefulWidget {
  const GridListThemes({ Key key }) : super(key: key);

  @override
  _GridListThemesState createState() => _GridListThemesState();
}

class _GridListThemesState extends State<GridListThemes> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(  
                    children: [
                      ThemeBox(
                        text: 'Classique', 
                        colors: [
                          Color(0xFFf12711),
                          Color(0xFFf5af19)
                        ]
                      ),
                      ThemeBox(  
                        text: 'Gaming',
                        colors: [
                          Color(0xFF1c92d2),
                          Color(0xFFf2fcfe)
                        ],
                      )
                    ]
                  ),
                  Row(
                    children: [
                      ThemeBox(
                        text: 'Jeu de société', 
                        colors: [
                          Color(0xFFa8ff78),
                          Color(0xFF78ffd6)
                        ]
                      ),
                      ThemeBox(  
                        text: 'Soirée à thème',
                        colors: [
                          Color(0xFFb24592),
                          Color(0xFFf15f79)
                        ],
                      )
                    ],
                  )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ThemeBox extends StatelessWidget {
  final List<Color> colors;
  final String text;
  const ThemeBox({
    @required this.text,
    @required this.colors,
    Key key 
    }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, bottom: 20),
      child: OpenContainer(
        transitionDuration: Duration(milliseconds: 400),
        closedColor: Colors.transparent,
        openColor: PRIMARY_COLOR,
        closedElevation: 0,
        closedBuilder: (context, returnvalue) {
          return Container(
            height: 145,
            width: 145,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: this.colors
              )
            ),
            child: Center(
              child: Text(
                this.text,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white
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
              create: (context) => PartiesCubit()..fetchPartiesWithWhereIsEqualTo('theme', this.text),
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
            ),
          );
        },
      ),
    );
  }
  // Stream<QuerySnapshot> getPartyStreamSnapshot(BuildContext context) async* {
  //   yield* FirebaseFirestore.instance
  //   .collection('party')
  //   .where('Theme', isEqualTo: this.text)
  //   .snapshots();
  // }
}
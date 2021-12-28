import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/components/party_card.dart';
import 'package:pts/const.dart';

class GridListThemes extends StatefulWidget {
  const GridListThemes({Key? key}) : super(key: key);

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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ThemeBox(
                        'Festive',
                        image: "assets/festive.jpg",
                      ),
                      ThemeBox('Jeux de société',
                          image: "assets/jeuxdesociete.jpg"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ThemeBox(
                        'Thème',
                        image: "assets/theme.jpg",
                      ),
                      ThemeBox(
                        'Gaming',
                        image: "assets/gaming.jpg",
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeBox extends StatelessWidget {
  final String text, image;
  const ThemeBox(this.text, {required this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
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
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
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
                ..fetchPartiesWithWhereIsEqualTo('theme', this.text),
              child: BlocBuilder<PartiesCubit, PartiesState>(
                builder: (context, state) {
                  if (state.parties == null)
                    return Center(child: const CircularProgressIndicator());
                  return ListView.builder(
                    itemCount: state.parties!.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildPartyCard(context, state.parties![index]),
                  );
                },
              ),
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

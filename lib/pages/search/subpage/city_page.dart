import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/party_card/party_card.dart';
import 'package:pts/const.dart';

class NewCityGrid extends StatelessWidget {
  const NewCityGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              CityBox(text: "Paris", image: "assets/paris.jpg"),
              CityBox(text: "Marseille", image: "assets/marseille.jpg"),
              CityBox(text: "Bordeaux", image: "assets/bordeaux.jpg"),
              CityBox(text: "Lyon", image: "assets/lyon.jpg"),
              CityBox(text: "Nantes", image: "assets/nantes.jpg"),
              CityBox(text: "Lille", image: "assets/lille.jpg"),
              SizedBox(width: 32),
            ],
          ),
        ],
      ),
    );
  }
}

class CityBox extends StatelessWidget {
  final String text;
  final String? image;

  const CityBox({required this.text, required this.image, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        transitionDuration: Duration(milliseconds: 300),
        closedColor: Colors.transparent,
        middleColor: PRIMARY_COLOR,
        openColor: PRIMARY_COLOR,
        closedElevation: 0,
        closedBuilder: (context, returnvalue) {
          return Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Container(
              height: 350,
              width: 220,
              decoration: BoxDecoration(
                image: image != null
                    ? DecorationImage(
                        image: AssetImage(image!), fit: BoxFit.cover)
                    : null,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        },
        openBuilder: (context, returnvalue) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: new BackAppBar(
                title: TitleAppBar(this.text),
              ),
            ),
            body: BlocProvider(
              create: (context) => PartiesCubit()
                ..fetchPartiesWithWhereIsEqualToAndIsActive('city', this.text),
              child: BlocBuilder<PartiesCubit, PartiesState>(
                builder: (context, state) {
                  if (state.parties == null)
                    return Center(child: const CircularProgressIndicator());
                  return ListView.builder(
                    itemCount: state.parties!.length,
                    itemBuilder: (BuildContext context, int index) => SizedBox(
                        height: 270,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: PartyCard(party: state.parties![index]),
                        )),
                  );
                },
              ),
            ),
          );
        });
  }
}

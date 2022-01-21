import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/party_card.dart';

class CardParty extends StatefulWidget {
  const CardParty({Key? key}) : super(key: key);

  @override
  _CardPartyState createState() => _CardPartyState();
}

class _CardPartyState extends State<CardParty> {
  // ignore: unused_field
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PartiesCubit()..fetchPartiesByOrder(),
      child: BlocBuilder<PartiesCubit, PartiesState>(builder: (context, state) {
        if (state.parties == null) return Center(child: const CircularProgressIndicator());
        return PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.parties!.length,
            controller: PageController(viewportFraction: 0.85),
            onPageChanged: (int index) => setState(() => _index = index),
            itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: PartyCard(party: state.parties![index]),
                ));
      }),
    );
  }

  // Stream<QuerySnapshot> getPartyStreamSnapshot(BuildContext context) async* {
  //   yield* FirebaseFirestore.instance
  //       .collection('party')
  //       .orderBy("timestamp", descending: true)
  //       .snapshots();
  // }
}

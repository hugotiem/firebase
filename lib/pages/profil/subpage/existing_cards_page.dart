import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/blocs/card_registration/card_registration_cubit.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/models/user.dart';

import 'new_credit_card_page.dart';

class ExistingCard extends StatelessWidget {
  final User? user;
  const ExistingCard({this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardRegistrationCubit()..loadData(user?.mangoPayId),
      child: BlocBuilder<CardRegistrationCubit, CardRegistrationState>(
          builder: (context, state) {
        var cards = state.cards;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: BackAppBar(
              title: TitleAppBar('Carte(s) enregistrée(s)'),
            ),
          ),
          body: Column(
            children: [
              Builder(builder: (context) {
                if (cards == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: cards.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var card = cards[index];
                    return Container(
                      child: Text(card.alias),
                    );
                  },
                );
              }),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewCreditCard(user: user)));
                  },
                  child: ListTile(
                      title: Text('Ajouter une carte'),
                      leading: Icon(Ionicons.add_circle_outline)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  thickness: 1,
                  height: 0,
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

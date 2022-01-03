import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/title_appbar.dart';

import 'new_credid_card_page.dart';

class ExistingCard extends StatefulWidget {
  const ExistingCard({Key? key}) : super(key: key);

  @override
  _ExistingCardState createState() => _ExistingCardState();
}

class _ExistingCardState extends State<ExistingCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          title: TitleAppBar('Carte enregistrer'),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewCreditCard()));
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
      ]),
    );
  }
}

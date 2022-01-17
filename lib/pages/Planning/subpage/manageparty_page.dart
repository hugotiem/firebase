
import 'package:flutter/material.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/custom_text.dart';

import '../../../const.dart';
import 'list_user_party_page.dart';
import 'waitlist_guest_page.dart';
import 'waitlist_party_page.dart';

class ManageParty extends StatelessWidget {
  const ManageParty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget onTapContainer(String text, {Widget? to}) {
      return InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => to!),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Container(
              padding: EdgeInsets.all(22),
              width: MediaQuery.of(context).size.width * .9,
              height: 65,
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CText(
                  text,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          title: TitleAppBar("Gère tes soirées"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            onTapContainer(
              "Mes soirées",
              to: GetPartyData(),
            ),
            onTapContainer(
              "Demande de la part des invités",
              to: GuestWaitList(),
            ),
            onTapContainer(
              "Demande de ma part pour rejoindre une soirée",
              to: PartyWaitList(),
            )
          ],
        ),
      ),
    );
  }
}

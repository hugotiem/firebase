import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/View/Pages/creation/components/fab_form.dart';
import 'package:pts/View/Pages/creation/components/hint_text.dart';
import 'package:pts/View/Pages/creation/components/tff_number.dart';

import 'components/headertext_one.dart';
import 'price_page.dart';

class GuestNumber extends StatefulWidget {
  @override
  _GuestNumberState createState() => _GuestNumberState();
}

class _GuestNumberState extends State<GuestNumber> {
  var _nombre = '20';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FORMBACKGROUNDCOLOR,      
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      floatingActionButton: FABForm( 
        onPressed: () {
          Soiree.setDataNumberPage(
            _nombre
          );
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => PricePage())
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText1(
              text: "Combien de personnes souhaitez-vous inviter ?",
            ),
            Row(
              children: [
                TFFNumber(
                  onChanged: (value) {
                    _nombre = value;
                  }, 
                  hintText: '20'
                ),
                HintText(
                  text: 'invités'
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
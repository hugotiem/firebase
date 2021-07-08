import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/View/Pages/creation/components/fab_form.dart';
import 'package:pts/View/Pages/creation/components/hint_text.dart';

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
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(  
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                     padding: const EdgeInsets.only(left: 16),
                      child: Center(
                        child: TextFormField(
                          onChanged: (value) {
                            _nombre = value;
                          }, 
                          style: TextStyle(
                            fontSize: 30,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[ 
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration( 
                            hintText: '20', 
                            border: InputBorder.none,
                          )
                        ),
                      ),
                    ),
                  ),
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
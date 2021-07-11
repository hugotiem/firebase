import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/calendar_data_source.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/View/Pages/creation/components/Radio_and_text.dart';
import 'package:pts/View/Pages/creation/components/fab_form.dart';
import 'package:pts/View/Pages/creation/components/headertext_one.dart';

import 'components/headertext_two.dart';
import 'components/hint_text.dart';
import 'components/tff_number.dart';
import 'description_page.dart';

enum RadioChoix {
  Gratuit,
  Cinq,
  Dix,
  Quinze,
  Vingt
}

class PricePage extends StatefulWidget {
  @override
  _PricePageState createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {
  var _prix = '10';
  RadioChoix _choixRadio = RadioChoix.Dix;

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
          Soiree.setDataPricePage(
            _prix
          );
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => DescriptionPage())
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText1(
              text: "A combien fixez-vous le prix d'entré ?",
            ),
            HeaderText2(
              text: 'Prédéfini'
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RadioAndText(
                    value: RadioChoix.Gratuit, 
                    groupValue: _choixRadio, 
                    onChanged: (value) {
                      setState(() {
                        _choixRadio = value;
                        _prix = '0';
                      });
                    }, 
                    text: 'Gratuit'
                  ),
                  RadioAndText(
                    value: RadioChoix.Cinq, 
                    groupValue: _choixRadio, 
                    onChanged: (value) {
                      setState(() {
                        _choixRadio = value;
                        _prix = '5';
                      });
                    }, 
                    text: '5 €'
                  ),
                  RadioAndText(
                    value: RadioChoix.Dix, 
                    groupValue: _choixRadio, 
                    onChanged: (value) {
                      setState(() {
                        _choixRadio = value;
                        _prix = '10';
                      });
                    }, 
                    text: '10 €'
                  ),
                  RadioAndText(
                    value: RadioChoix.Quinze, 
                    groupValue: _choixRadio, 
                    onChanged: (value) {
                      setState(() {
                        _choixRadio = value;
                        _prix = '15';
                      });
                    }, 
                    text: '15 €'
                  ),
                  RadioAndText(
                    value: RadioChoix.Vingt, 
                    groupValue: _choixRadio, 
                    onChanged: (value) {
                      setState(() {
                        _choixRadio = value;
                        _prix = '20';
                      });
                    }, 
                    text: '20 €'
                  ),
                ],
              ),
            ),
            HeaderText2(
              text: 'Custom',
              padding: EdgeInsets.only(bottom: 20, top: 40)
            ),
            Row(
              children: [
                TFFNumber(
                  onChanged: (value) {
                    _prix = value;
                  },
                  hintText: '10',
                ),
                HintText(   
                  text: '€',
                )
              ],
            ),
            SizedBox( 
              height: 50,
            )
          ]
        )
      )
    );
  }
}
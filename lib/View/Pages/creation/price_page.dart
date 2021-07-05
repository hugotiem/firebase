import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/View/Pages/creation/components/headertext_one.dart';

import 'components/headertext_two.dart';
import 'components/hint_text.dart';
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
  var _prix;
  RadioChoix _choixRadio = RadioChoix.Dix;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FORMBACKGROUNDCOLOR,      
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      floatingActionButton: FloatingActionButton( 
        backgroundColor: PRIMARY_COLOR,
        elevation: 1,
        child: Icon(
          Icons.arrow_forward_outlined,
          color: SECONDARY_COLOR,
          ),
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
                  Row(
                    children: [
                      Radio(
                        activeColor: SECONDARY_COLOR,
                        value: RadioChoix.Gratuit,
                        groupValue: _choixRadio,
                        onChanged: (value) {
                          setState(() {
                            _choixRadio = value;
                            _prix = '0';
                          });
                        },
                      ),
                      HintText(
                        text: 'Gratuit',
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        activeColor: SECONDARY_COLOR,
                        value: RadioChoix.Cinq,
                        groupValue: _choixRadio,
                        onChanged: (value) {
                          setState(() {
                            _choixRadio = value;
                            _prix = '5';
                          });
                        },
                      ),
                      HintText(
                        text: '5 €',
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        activeColor: SECONDARY_COLOR,
                        value: RadioChoix.Dix,
                        groupValue: _choixRadio,
                        onChanged: (value) {
                          setState(() {
                            _choixRadio = value;
                            _prix = '10';
                          });
                        },
                      ),
                      HintText(
                        text: '10 €',
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        activeColor: SECONDARY_COLOR,
                        value: RadioChoix.Quinze,
                        groupValue: _choixRadio,
                        onChanged: (value) {
                          setState(() {
                            _choixRadio = value;
                            _prix = '15';
                          });
                        },
                      ),
                      HintText(
                        text: '15 €',
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        activeColor: SECONDARY_COLOR,
                        value: RadioChoix.Vingt,
                        groupValue: _choixRadio,
                        onChanged: (value) {
                          setState(() {
                            _choixRadio = value;
                            _prix = '20';
                          });
                        },
                      ),
                      HintText(
                        text: '20 €',
                      )
                    ],
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
                            _prix = value;
                          },
                          keyboardType: TextInputType.number,  
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: TextStyle(
                            fontSize: 30,
                          ),
                          decoration: InputDecoration( 
                            hintText: '10', 
                            border: InputBorder.none,
                          )
                        ),
                      ),
                    ),
                  ),
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
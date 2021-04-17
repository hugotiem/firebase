import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';


// Dans cette quatrième page du formulaire de création on retrouve : 
// le paiement

class Fourthpage extends StatefulWidget {
  @override
  _FourthpageState createState() => _FourthpageState();
}

class _FourthpageState extends State<Fourthpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BLUE_BACKGROUND,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
        ),
      body: Column(
        children: <Widget> [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              'Votre soirée sera :',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                ),
              ),
          ),
          LiteRollingSwitch(
            value: false,
            textOn: 'Payante',
            textOff: 'gratuite',
            colorOn: YELLOW_COLOR,
            colorOff: YELLOW_COLOR,
            iconOn: Icons.credit_card_outlined,
            iconOff: Icons.credit_card_off_outlined,
            onChanged: (bool state) {
              print('turned ${(state) ? 'on' : 'off'}');
            },
          )
        ]
      ),
    );
  }
}
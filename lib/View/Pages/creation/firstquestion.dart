import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';

class QuestionDeBase extends StatefulWidget {
  @override
  _QuestionDeBaseState createState() => _QuestionDeBaseState();
}

class _QuestionDeBaseState extends State<QuestionDeBase> {
  String _chosenValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BLUE_BACKGROUND,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          leading: CupertinoButton(
            child: Icon(
              Icons.close,
              color: YELLOW_COLOR,
            ),
            onPressed: () {
              Navigator.pop(context);
           },
          ),
        )
      ),
      body: Column(
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                '1- Comment voulez-vous appeler votre soirée ?',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 20),
              child: Container( 
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                decoration: BoxDecoration(  
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: TextField(
                    decoration: InputDecoration(  
                      labelText: "Votre soirée s'appelera :",
                      border: InputBorder.none,
                      icon: Icon(Icons.create_outlined)
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 15),
              child: Text(
                '2- Choisissez le thème qui vous plaît :',
                style: TextStyle(  
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)
                  ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 20),
                  child: DropdownButtonFormField<String>( 
                    value: _chosenValue, 
                    items: [
                      'Classique',
                      'Gaming',
                      'Jeu de société',
                      'Thème',
                      'Etudiante'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>( 
                        value: value,
                        child: Text(
                          value, 
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Choisir un thème",
                    ),
                    decoration: InputDecoration(  
                      enabledBorder: UnderlineInputBorder(  
                        borderSide: BorderSide(color: Colors.white)
                      )
                    ),
                    isExpanded: true,
                    onChanged: (String value) {
                      setState(() {
                        _chosenValue = value;
                      });
                    },
                  ),
                ),
              ),
            )
          ]
        ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';

import '../../../../Constant.dart';
import 'date_hour_page.dart';

class ThemePage extends StatefulWidget {
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  String _theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,      
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
          Soiree.setDataThemePage(
            _theme
          );
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => DateHourPage())
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.only(top: 30, bottom: 40),
                child: Text(
                  "Choisissez un thème ",
                  style: TextStyle(  
                    wordSpacing: 1.5,
                    fontSize: 25,
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(  
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Center(
                    child: DropdownButtonFormField<String>(
                    value: _theme,
                    items: [
                      'Classique',
                      'Gaming',
                      'Jeu de société',
                      'Soirée à thème',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(  
                            fontSize: 18
                          ),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Choisir un thème",
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    elevation: 0,
                    decoration: InputDecoration(
                      border: OutlineInputBorder( 
                        borderRadius: BorderRadius.circular(15)
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white
                        )
                      )
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _theme = value;
                      });
                    },
                  ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
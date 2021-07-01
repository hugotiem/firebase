import 'package:flutter/material.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';

import '../../../Constant.dart';
import 'components/headertext_one.dart';
import 'date_hour_page.dart';

class ThemePage extends StatefulWidget {
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  String _theme;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          if (!_formKey.currentState.validate()) {
            return;
          }
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
            HeaderText1(
              text: 'Choississez un thème'
            ),
            Center(
              child: Container(
                height: HEIGHTCONTAINER,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(  
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Form(
                    key: _formKey,
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
                                fontSize: TEXTFIELDFONTSIZE
                              ),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "Choisir un thème",
                          style: TextStyle(
                            fontSize: TEXTFIELDFONTSIZE
                          ),
                        ),
                        elevation: 0,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(  
                            height: 0,
                            background: Paint()..color = Colors.transparent
                          ),
                          errorBorder: OutlineInputBorder( 
                            borderSide: BorderSide(
                              color: Colors.transparent
                            )
                          ),
                          border: OutlineInputBorder( 
                            borderRadius: BorderRadius.circular(15)
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent
                            )
                          )
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _theme = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Vous devez choisir un thème';
                          } else {
                            return null;
                          }
                        },
                      ),
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
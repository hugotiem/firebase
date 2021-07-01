import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/View/Pages/creation/theme_page.dart';

import 'components/headertext_one.dart';

class NamePage extends StatefulWidget {
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  String _name;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FORMBACKGROUNDCOLOR,      
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          leading: CupertinoButton(
              child: Icon(
                Icons.close,
                color: ICONCOLOR,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
        ),
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
          Soiree.setDataNamePage(
            _name
          );
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => ThemePage())
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText1(
              text: "Comment s'appelera-t'elle ?",
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
                  padding: const EdgeInsets.only(left: 16),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(  
                        onChanged: (value) {
                        _name = value;
                        },
                        style: TextStyle(
                          fontSize: TEXTFIELDFONTSIZE,
                        ),
                        decoration: InputDecoration( 
                          hintText: 'ex: La fête du roi', 
                          border: InputBorder.none,
                          counterText: '',
                          errorStyle: TextStyle(  
                            height: 0,
                          )
                        ),
                        maxLength: 20,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Vous devez rentrer un nom';
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
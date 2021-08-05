import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/View/Pages/creation/theme_page.dart';
import 'package:pts/components/components_creation/fab_form.dart';
import 'package:pts/components/components_creation/headertext_one.dart';
import 'package:pts/components/components_creation/tff_text.dart';


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
      floatingActionButton: FABForm( 
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
        child: Form(
          key: _formKey,
          child: Column(  
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText1(
                text: "Comment s'appelera-t'elle ?",
              ),
              TFFText(
                onChanged: (value) {
                  _name = value;
                }, 
                hintText: 'ex : La fête du roi', 
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Vous devez rentrer un nom';
                  } else {
                    return null;
                  }
                },
                maxLength: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
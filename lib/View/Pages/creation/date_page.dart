import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/components/components_creation/date_hour_picker.dart';
import 'package:pts/components/components_creation/fab_form.dart';
import 'package:pts/components/components_creation/headertext_one.dart';

import '../../../Constant.dart';
import 'hour_page.dart';



class DateHourPage extends StatefulWidget {
  @override
  _DateHourPageState createState() => _DateHourPageState();
}

class _DateHourPageState extends State<DateHourPage> {
  var _date;
  TextEditingController dateCtl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          if (!_formKey.currentState.validate()) {
            return;
          }
          Soiree.setDataDatePage(
            _date,
          );
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => HourPage())
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
                text: "Quel jour ?",
              ),
              DateHourPicker(
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await _selectionDate();
                  dateCtl.text = DateFormat.MMMMEEEEd('fr').format(_date);
                }, 
                hintText: 'Choisir une date',
                controller: dateCtl,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Vous devez choisir une date";
                  } else {
                    return null;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectionDate() async {
    DateTime _dateChoisie = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime.now(), 
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: SECONDARY_COLOR,
              onPrimary: ICONCOLOR
            ),
          ), 
          child: child
        );
      }
    );

    if (_dateChoisie != null && _dateChoisie != _date) {
      setState(() {
        _date = _dateChoisie;
      });
    }
  }

  
}
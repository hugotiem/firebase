import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';

import '../../../Constant.dart';
import 'components/headertext_one.dart';
import 'components/headertext_two.dart';
import 'location_page.dart';



class DateHourPage extends StatefulWidget {
  @override
  _DateHourPageState createState() => _DateHourPageState();
}

class _DateHourPageState extends State<DateHourPage> {
  var _date;
  var _heure;
  TextEditingController dateCtl = TextEditingController();
  TextEditingController heureCtl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          if (!_formKey.currentState.validate()) {
            return;
          }
          Soiree.setDataDateHourPage(
            _date,
            _heure
          );
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => LocationPage())
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
                text: "Quand se déroulera-t'elle ?",
              ),
              HeaderText2(
                text: 'Date',
              ),
              Center(
                child: Container(
                  height: HEIGHTCONTAINER,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(  
                    color: PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextFormField(
                        controller: dateCtl,
                        readOnly: true,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          await _selectionDate();
                          dateCtl.text = DateFormat.MMMMEEEEd('fr').format(_date);
                        },
                        style: TextStyle(  
                          fontSize: 18
                        ),
                        decoration: InputDecoration(  
                          hintText: 'Choisir une date',
                          border: InputBorder.none,
                          errorStyle: TextStyle(  
                            height: 0
                          )
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "vous devez choisir une date";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              HeaderText2(
                text: 'Heure',
                padding: EdgeInsets.only(bottom: 20, top: 40)
              ),
              Center(
                child: Container(
                  height: HEIGHTCONTAINER,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(  
                    color: PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextFormField(
                        controller: heureCtl,
                        readOnly: true,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          await _selectionHeure();
                          heureCtl.text = 'A ${_heure.format(context)} ';
                        },
                        style: TextStyle(  
                          fontSize: 18
                        ),
                        decoration: InputDecoration(  
                          hintText: 'Choisir une heure',
                          border: InputBorder.none,
                          errorStyle: TextStyle(  
                            height: 0
                          )
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "vous devez choisir une date";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                ),
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

  Future<Null> _selectionHeure() async {
    TimeOfDay _heureChoisie = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now(),
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

    if (_heureChoisie != null && _heureChoisie != _heure) {
      setState(() {
        _heure = _heureChoisie;
      });
    }
  }
}
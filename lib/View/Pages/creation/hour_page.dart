import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/calendar_data_source.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/View/Pages/creation/components/date_hour_picker.dart';
import 'package:pts/View/Pages/creation/components/fab_form.dart';
import 'package:pts/View/Pages/creation/components/headertext_two.dart';
import 'package:pts/View/Pages/creation/location_page.dart';

import 'components/headertext_one.dart';

class HourPage extends StatefulWidget {
  const HourPage({ Key key }) : super(key: key);

  @override
  _HourPageState createState() => _HourPageState();
}

class _HourPageState extends State<HourPage> {
  var _heuredebut;
  var _heurefin;
  TextEditingController heurefinctl = TextEditingController();
  TextEditingController heuredebutctl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var date;
  DateTime datedebut;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FORMBACKGROUNDCOLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar()
      ),
      floatingActionButton: FABForm( 
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          }

          var date = Soiree.date;
          
          DateTime datedebut = DateTime(date.year, date.month, date.day, _heuredebut.hour, _heuredebut.minute);
          DateTime datefin = DateTime(date.year, date.month, date.day, _heurefin.hour, _heurefin.minute);

          if (datefin.isBefore(datedebut)) {
            datefin = datefin.add(Duration(days: 1));
          }

          Soiree.setDataHourPage(
            _heuredebut,
            _heurefin,
            datedebut,
            datefin
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
                text: 'Quelle heure ?'
              ),
              HeaderText2(
                text: "Heure d'arrivé"
              ),
              DateHourPicker(
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await _selectionHeureArrivee();
                  heuredebutctl.text = 'De ${_heuredebut.format(context)} ';
                },
                hintText: 'Choisir une heure',
                controller: heuredebutctl,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Vous devez choisir une heure d'arrivée";
                  } else {
                    return null;
                  }
                },
              ),
              HeaderText2(
                text: "Heure de départ",
                padding: EdgeInsets.only(top: 40, bottom: 20),
              ),
              DateHourPicker(
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await _selectionHeureDepart();
                  heurefinctl.text = 'A ${_heurefin.format(context)} ';
                }, 
                hintText: 'Choisir une Heure',
                controller: heurefinctl,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Vous devez choisir une heure de départ";
                  } else {
                    return null;
                  }
                },
              )
            ]
          ),
        ),
      )
    );
  }

  Future<Null> _selectionHeureArrivee() async {
    TimeOfDay _heureChoisieArrivee = await showTimePicker(
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

    if (_heureChoisieArrivee != null && _heureChoisieArrivee != _heuredebut) {
      setState(() {
        _heuredebut = _heureChoisieArrivee;
      });
    }
  }

  Future<Null> _selectionHeureDepart() async {
    TimeOfDay _heureChoisieDepart = await showTimePicker(
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

    if (_heureChoisieDepart != null && _heureChoisieDepart != _heurefin) {
      setState(() {
        _heurefin = _heureChoisieDepart;
      });
    }
  }
}
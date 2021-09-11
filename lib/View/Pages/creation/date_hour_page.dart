import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/components_creation/date_hour_picker.dart';
import 'package:pts/components/components_creation/fab_form.dart';
import 'package:pts/components/components_creation/headertext_one.dart';
import 'package:pts/components/components_creation/headertext_two.dart';

import '../../../Constant.dart';

class DateHourPage extends StatefulWidget {
  final void Function() onNext;
  final void Function() onPrevious;

  const DateHourPage({Key key, this.onNext, this.onPrevious}) : super(key: key);
  @override
  _DateHourPageState createState() => _DateHourPageState();
}

class _DateHourPageState extends State<DateHourPage> {
  var _date;
  var _heuredebut;
  var _heurefin;
  TextEditingController heurefinctl = TextEditingController();
  TextEditingController heuredebutctl = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime datedebut;
  DateTime datefin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FORMBACKGROUNDCOLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          onPressed: () {
            widget.onPrevious();
          },
        ),
      ),
      floatingActionButton: FABForm(
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          }

          var date = _date;

          DateTime datedebut = DateTime(date.year, date.month, date.day,
              _heuredebut.hour, _heuredebut.minute);
          DateTime datefin = DateTime(date.year, date.month, date.day,
              _heurefin.hour, _heurefin.minute);

          if (datefin.isBefore(datedebut)) {
            datefin = datefin.add(Duration(days: 1));
          }

          BlocProvider.of<BuildPartiesCubit>(context)
            ..addItem("date", _date)
            ..addItem("startTime", datedebut)
            ..addItem("endTime", datefin);

          widget.onNext();

          // Soiree.setDataDateHourPage(_date, datedebut, datefin);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => LocationPage()));
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText1(text: "Quel jour ?"),
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
              HeaderText2(
                text: "Heure d'arrivé",
                padding: EdgeInsets.only(top: 40, bottom: 20),
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
                colorScheme: ColorScheme.light()
                    .copyWith(primary: SECONDARY_COLOR, onPrimary: ICONCOLOR),
              ),
              child: child);
        });

    if (_dateChoisie != null && _dateChoisie != _date) {
      setState(() {
        _date = _dateChoisie;
      });
    }
  }

  Future<Null> _selectionHeureArrivee() async {
    TimeOfDay _heureChoisieArrivee = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light()
                    .copyWith(primary: SECONDARY_COLOR, onPrimary: ICONCOLOR),
              ),
              child: child);
        });

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
                colorScheme: ColorScheme.light()
                    .copyWith(primary: SECONDARY_COLOR, onPrimary: ICONCOLOR),
              ),
              child: child);
        });

    if (_heureChoisieDepart != null && _heureChoisieDepart != _heurefin) {
      setState(() {
        _heurefin = _heureChoisieDepart;
      });
    }
  }
}

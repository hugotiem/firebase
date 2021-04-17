import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/back_appbar.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  var _date;
  var _heure;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BLUE_BACKGROUND,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50), child: BackAppBar()),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ElevatedButton(
                child: Text('Choisir une Date'),
                onPressed: () {
                  _selectiondate();
                }),
            Text(
              _date == null
                  ? 'Aucune date choisie'
                  : '${_date.day}/${_date.month}/${_date.year} ',
            ),
            ElevatedButton(
              child: Text('choisir une heure'),
              onPressed: () {
                _selectionheure();
              },
            ),
            Text(_heure == null
                ? 'Aucune heure choisie'
                : "${_heure.format(context)} ")
          ],
        ),
      ),
    );
  }

  Future<Null> _selectiondate() async {
    DateTime _dateChoisie = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (_dateChoisie != null) {
      setState(() {
        _date = _dateChoisie;
      });
    }
  }

  Future<Null> _selectionheure() async {
    TimeOfDay _heureChoisie =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (_heureChoisie != null) {
      setState(() {
        _heure = _heureChoisie;
      });
    }
  }
}

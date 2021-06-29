import 'package:flutter/material.dart';
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
                child: TextButton(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        child: 
                          _date == null 
                            ? Text(
                              'Choisir une date',
                              style: TextStyle(  
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                                fontSize: 18
                              ),
                            )
                            : Text(
                              'Le ${_date.day}/${_date.month}/${_date.year} ',
                              style: TextStyle(  
                                color: SECONDARY_COLOR,
                                fontSize: 18
                              ),
                            ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    _selectionDate();
                  },
                  style: TextButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  )
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
                child: TextButton(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        child: 
                          _heure == null 
                            ? Text(
                              'Choisir une heure',
                              style: TextStyle(  
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                                fontSize: 18
                              ),
                            )
                            : Text(
                              'A ${_heure.format(context)} ',
                              style: TextStyle(  
                                color: SECONDARY_COLOR,
                                fontSize: 18
                              ),
                            ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    _selectionHeure();
                  },
                  style: TextButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  )
                ),
              ),
            ),
          ],
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

    if (_dateChoisie != null) {
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

    if (_heureChoisie != null) {
      setState(() {
        _heure = _heureChoisie;
      });
    }
  }
}
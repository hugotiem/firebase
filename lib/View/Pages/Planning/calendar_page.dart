import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/CalendarWidget.dart';
import 'package:pts/View/Pages/creation/test%201/namePage.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: PRIMARY_COLOR, 
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        title: Text(
          'Calendrier',
          style: TextStyle(
            color: SECONDARY_COLOR,
            ),
          ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => NamePage())
                );
              },
              child: Icon(
                Icons.add,
                color: ICONCOLOR,
                size: 30, 
              ),
            ),
          )
        ],
      ),
      body: CalendarWidget(),
    );
  }
}
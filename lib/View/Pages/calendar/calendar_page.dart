import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: PRIMARY_COLOR, 
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR ,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.add,
              color: ICONCOLOR,
              size: 30,
              ),
          )
      ],),
    );
  }
}
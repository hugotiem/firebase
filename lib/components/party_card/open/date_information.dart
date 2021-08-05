import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class DateInformation extends StatelessWidget {
  final String date;

  const DateInformation({ 
    this.date,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Container(  
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 21),
          child: Text(
            this.date,
            style: TextStyle(  
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: SECONDARY_COLOR
            ),
          ),
        ),
      ),
    );
  }
}
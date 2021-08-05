import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class TimeText extends StatelessWidget {
  final String heure;
  final String mois;
  final String jour;

  const TimeText({ 
    this.heure,
    this.mois,
    this.jour,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(  
          padding: EdgeInsets.only(top: 10),
          child: Align(  
            alignment: Alignment.centerLeft,
            child: Text(
              this.heure,
              style: TextStyle(  
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: SECONDARY_COLOR
              ),
            ),
          )
        ),
        Column(  
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Opacity(  
                opacity: 0.7,
                child: Text(  
                  this.mois,
                  style: TextStyle(  
                    color: SECONDARY_COLOR
                  ),
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  this.jour,
                  style: TextStyle(  
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: SECONDARY_COLOR
                  )
                )
              ),
            )
          ],
        )
      ],
    );
  }
}
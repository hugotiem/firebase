import 'package:flutter/material.dart';

import '../../../../../Constant.dart';


class PriceInformation extends StatelessWidget {
  final String prix;

  const PriceInformation({ 
    this.prix,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Stack(  
        children: [
          Container( 
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(  
              border: Border(  
                top: BorderSide(
                  width: 2,
                  color: FOCUS_COLOR
                ),
                bottom: BorderSide(
                  width: 2,
                  color: FOCUS_COLOR
                ),
              )
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 21),
              child: Opacity(  
                opacity: 0.7,
                child: Text(
                  "Prix d'entré pour une personne",
                  style: TextStyle(  
                    fontSize: 16,
                    color: SECONDARY_COLOR,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Container(
              alignment: Alignment.centerRight,
              child: Text( 
                this.prix,
                style: TextStyle(  
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: SECONDARY_COLOR
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
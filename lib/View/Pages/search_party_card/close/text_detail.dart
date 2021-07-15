import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class Textdetail extends StatelessWidget {
  final int flex;
  final String headerText;
  final String detailText;

  const Textdetail({ 
    this.flex,
    @required this.headerText,
    @required this.detailText,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: this.flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Opacity( 
            opacity: 0.7,
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(   
                this.headerText.toUpperCase(),
                style: TextStyle(  
                  fontSize: 14,
                  color: SECONDARY_COLOR
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              this.detailText,
              style: TextStyle(  
                fontSize: 20,
                color: SECONDARY_COLOR,
                fontWeight: FontWeight.w500
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      )
    );
  }
}
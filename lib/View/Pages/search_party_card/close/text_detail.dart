import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class Textdetail extends StatelessWidget {
  final String headerText;
  final String detailText;
  final IconData icon;

  const Textdetail({ 
    @required this.headerText,
    @required this.detailText,
    this.icon,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Row(
          children: [
            Container(
              child: Icon(
                this.icon,
                size: 20,
                color: SECONDARY_COLOR,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                this.detailText,
                style: TextStyle(  
                  fontSize: 20,
                  color: SECONDARY_COLOR
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )
      ],
    );
  }
}
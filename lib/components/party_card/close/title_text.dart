import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class TitleText extends StatelessWidget {
  final String name;
  final String theme;

  const TitleText({ 
    this.name,
    this.theme,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Container( 
            alignment: Alignment.topLeft,
            child: Text( 
              this.name,
              style: TextStyle(  
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: SECONDARY_COLOR
              ),
            ),
          ),
        ),
        Opacity(  
          opacity: 0.7,
          child: Text( 
            this.theme,
            style: TextStyle(  
              color: SECONDARY_COLOR
            ),
          ),
        )
      ],
    );
  }
}
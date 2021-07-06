import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class TitleText extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final String text;
  const TitleText({
    this.margin,
    @required this.text,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.margin,
      child: Text(
        this.text,
        style: TextStyle(  
          fontWeight: FontWeight.w900,
          fontSize: 20,
          color: SECONDARY_COLOR
        ),
      ),
    );
  }
}
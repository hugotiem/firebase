import 'package:flutter/material.dart';

class FontText extends StatelessWidget {
  final String data;
  final double fontSize;
  final Color color;

  const FontText({ 
    this.data,
    this.color,
    this.fontSize,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.data,
      style: TextStyle(  
        fontWeight: FontWeight.w500,
        fontSize: this.fontSize,
        color: this.color
      ),
    );
  }
}
import 'package:flutter/material.dart';
class OpacityText extends StatelessWidget {
  final String data;
  final Color color;
  
  const OpacityText({ 
    this.data,
    this.color,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Text(
        this.data,
        style: TextStyle(  
          color: this.color
        ),
      ),
    );
  }
}
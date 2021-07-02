import 'package:flutter/material.dart';

class ThemeBox extends StatelessWidget {
  final List<Color> colors;
  final String text;
  const ThemeBox({
    @required this.text,
    @required this.colors,
    Key key 
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 40, right: 10),
      height: 145,
      width: 145,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: this.colors
        )
      ),
      child: Center(
        child: Text(
          this.text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
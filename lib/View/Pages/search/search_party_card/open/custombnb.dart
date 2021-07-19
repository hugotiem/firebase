import 'package:flutter/material.dart';

class CustomBNB extends StatelessWidget {
  const CustomBNB({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
    );
  }
}
import 'package:flutter/material.dart';

import '../../../../Constant.dart';

class HeaderText1 extends StatelessWidget {
  final String text;
  const HeaderText1({ 
    required this.text,
    Key? key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.only(top: 30, bottom: 40),
        child: Text(
          this.text,
          style: TextStyle(  
            wordSpacing: 1.5,
            fontSize: 25,
            color: SECONDARY_COLOR,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
    );
  }
}
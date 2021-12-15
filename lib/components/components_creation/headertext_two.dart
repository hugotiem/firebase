import 'package:flutter/material.dart';

import 'package:pts/const.dart';

class HeaderText2 extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;
  const HeaderText2({ 
    required this.text,
    this.padding,
    Key? key, 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: padding == null 
          ? EdgeInsets.only(bottom: 20)
          : this.padding,
        child: Text(
          this.text,
          style: TextStyle(  
            wordSpacing: 1.5,
            fontSize: 22,
            color: SECONDARY_COLOR,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
   );
  }
}
import 'package:flutter/material.dart';
import 'package:pts/Model/components/text_materials.dart';

class TitleTextProfil extends StatelessWidget {
  final String text;

  const TitleTextProfil({ 
    this.text,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 10),
      child: BoldText( 
        text: this.text,
        fontSize: 15,
      ),
    );
  }
}
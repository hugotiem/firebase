import 'package:flutter/material.dart';

class HintText extends StatelessWidget {
  final String text;
  const HintText({ 
    required this.text,
    Key? key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Container(  
        child: Opacity( 
          opacity: 0.7,
          child: Text(
            this.text,
            style: TextStyle(  
              fontSize: 20,
              color: Colors.black
            ),
          ),
        ),
      ),
    );
  }
}
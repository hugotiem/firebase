import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class RadioAndText extends StatelessWidget {
  final dynamic value;
  final dynamic groupValue;
  final void Function(dynamic) onChanged;
  final String text;

  const RadioAndText({ 
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    @required this.text,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          activeColor: SECONDARY_COLOR,
          value: this.value, 
          groupValue: this.groupValue, 
          onChanged: this.onChanged
        ),
        Padding(
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
        ),
      ],
    );
  }
}
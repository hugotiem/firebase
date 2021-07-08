import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/Constant.dart';

class TFFNumber extends StatelessWidget {
  final void Function(String) onChanged;
  final String hintText;

  const TFFNumber({ 
    @required this.onChanged,
    @required this.hintText,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(  
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Padding( 
          padding: const EdgeInsets.only(left: 16),
          child: Center( 
            child: TextFormField(  
              onChanged: this.onChanged,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              style: TextStyle(  
                fontSize: 30,
              ),
              decoration: InputDecoration(  
                hintText: this.hintText,
                border: InputBorder.none
              ),
            ),
          ),
        ),
      ),
    );
  }
}
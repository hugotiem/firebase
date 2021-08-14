import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/Constant.dart';

class TFFText extends StatelessWidget {
  final void Function(String) onChanged;
  final String hintText;
  final int maxLength;
  final String Function(String) validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  const TFFText({ 
    @required this.onChanged,
    @required this.hintText,
    this.maxLength,
    @required this.validator,
    this.keyboardType,
    this.inputFormatters,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: HEIGHTCONTAINER,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Padding( 
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: TextFormField(  
              onChanged: this.onChanged,
              style: TextStyle(  
                fontSize: TEXTFIELDFONTSIZE,
              ),
              decoration: InputDecoration(  
                hintText: this.hintText,
                border: InputBorder.none,
                counterText: '',
                errorStyle: TextStyle(  
                  height: 0
                )
              ),
              maxLength: this.maxLength,
              validator: this.validator,
              keyboardType: this.keyboardType,
              inputFormatters: this.inputFormatters,
            ),
          ),
        ),
      ),
    );
  }
}
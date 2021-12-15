import 'package:flutter/material.dart';
import 'package:pts/const.dart';

class DateHourPicker extends StatelessWidget {
  final TextEditingController? controller;
  final void Function() onTap;
  final String hintText;
  final String? Function(String?)? validator;

  const DateHourPicker({ 
    this.controller,
    required this.onTap,
    required this.hintText,
    this.validator,
    Key? key 
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
        child: Center( 
          child: Padding( 
            padding: const EdgeInsets.only(left: 16),
            child: TextFormField(  
              controller: this.controller,
              readOnly: true,
              onTap: this.onTap,
              style: TextStyle(  
                fontSize: TEXTFIELDFONTSIZE
              ),
              decoration: InputDecoration(  
                hintText: this.hintText,
                border: InputBorder.none,
                errorStyle: TextStyle(  
                  height: 0,
                )
              ),
              validator: this.validator,
            ),
          ),
        ),
      ),
    );
  }
}
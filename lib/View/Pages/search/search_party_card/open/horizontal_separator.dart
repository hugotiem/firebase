import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class HorzontalSeparator extends StatelessWidget {
  const HorzontalSeparator({ 
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 50, left: 21, right: 21),
      child: Container(
        decoration: BoxDecoration(  
          border: Border(  
            top: BorderSide(  
              width: 2,
              color: FOCUS_COLOR
            )
          )
        ),
      ),
    );
  }
}
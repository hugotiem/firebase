import 'package:flutter/material.dart';

import '../../../../../Constant.dart';

class VerticalSeparator extends StatelessWidget {
  const VerticalSeparator({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15, top: 12),
          child: Center(  
            child: Container(  
              height: 160,
              decoration: BoxDecoration(  
                border: Border.all(
                  width: 1,
                  color: FOCUS_COLOR
                )
              ),
            ),
          ),
        )
      ],
    );
  }
}
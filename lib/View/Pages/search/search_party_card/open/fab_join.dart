import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class FABJoin extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const FABJoin({ 
    this.label,
    this.onPressed,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text(  
        this.label,
        style: TextStyle(  
          fontSize: 15
        ),
      ),
      backgroundColor: SECONDARY_COLOR,
      elevation: 0,
      onPressed: this.onPressed,
    );
  }
}
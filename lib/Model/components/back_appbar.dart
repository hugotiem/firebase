import 'package:flutter/material.dart';


class BackAppBar extends PreferredSize {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon:  Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ), 
          onPressed: () {
            Navigator.pop((context)
            );
          }
          ),
    );
  }
}
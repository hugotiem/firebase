import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class API extends StatelessWidget {
  API({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Searchbar1(),
    );
  }
}

class Searchbar1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "test",
      child: Container(
        width: 350,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(29.5),
          boxShadow: [
            BoxShadow(
              color: BLUE_BACKGROUND.withOpacity(0.3),
              offset: Offset(1, 2),
              blurRadius: 4,
              spreadRadius: 2,
            )
          ],
        ),
        child: Container(),
      ),
    );
  }
}

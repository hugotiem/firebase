import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class API extends StatelessWidget {
  API({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BLUE_BACKGROUND,
      body: Searchbar1()
    );
  }
}

class Searchbar1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Hero(
          tag: "test",
          child: Container(
            height: 100,
            width: 50,
            color: Colors.amber,         
            ),
            );
    
  }
}

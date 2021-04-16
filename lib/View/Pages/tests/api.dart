import 'package:flutter/material.dart';

class API extends StatefulWidget {
  API({Key key}) : super(key: key);

  @override
  _APIState createState() => _APIState();
}

class _APIState extends State<API> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        builder: (context, child) {
          return child;
        },
        animation: null,
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? to;
  const SplashScreen({ this.to, Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime(widget.to!);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initScreen(context),
    );
  }
  
  startTime(Widget to) async {
    var duration = new Duration(seconds: 6);
    return new Timer(duration, route(to));
  }
route(Widget to) {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => to
      )
    ); 
  }
  
  initScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset("assets/logo.png"),
        ),
      ),
    );
  }
}
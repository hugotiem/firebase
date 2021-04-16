import 'package:flutter/material.dart';

class CustomSliver extends StatelessWidget {
  final Widget appBar, body;
  final Color backgroundColor;
  final Function(ScrollNotification) onNotification;
  CustomSliver({
    Key key,
    @required this.appBar,
    @required this.body,
    this.onNotification,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: onNotification,
        child: Stack(
          children: <Widget>[
            body,
            appBar,
          ],
        ),
      ),
    );
  }
}

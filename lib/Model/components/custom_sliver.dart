import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class CustomSliver extends StatelessWidget {
  final Widget appBar, body;
  final Color backgroundColor;
  final Brightness brightness;
  final Function(ScrollNotification) onNotification;
  CustomSliver({
    Key key,
    @required this.appBar,
    @required this.body,
    this.onNotification,
    this.backgroundColor,
    this.brightness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        brightness: brightness,
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        backwardsCompatibility: false,
      ),
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

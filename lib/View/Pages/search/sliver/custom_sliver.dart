import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSliver extends StatelessWidget {
  final Widget appBar, body, searchBar;
  final Color backgroundColor, toolbarColor;
  final Brightness brightness;
  final Function(ScrollNotification) onNotification;
  CustomSliver({
    Key key,
    @required this.appBar,
    @required this.body,
    this.onNotification,
    this.backgroundColor,
    this.toolbarColor,
    this.brightness,
    @required this.searchBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        brightness: brightness,
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: onNotification,
        child: Stack(
          children: <Widget>[
            appBar,
            body,
            Container(
              height: toolbarColor == Colors.transparent ? 0 : 100,
              color: toolbarColor,
            ),
            searchBar,
          ],
        ),
      ),
    );
  }
}

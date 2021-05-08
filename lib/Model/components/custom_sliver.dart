import 'package:flutter/material.dart';

class CustomSliver extends StatelessWidget {
  final Widget appBar, body, searchBar;
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
    @required this.searchBar,
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
            appBar,
            body,
            searchBar,
          ],
        ),
      ),
    );
  }
}

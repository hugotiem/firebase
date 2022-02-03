import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSliver extends StatelessWidget {
  final Widget? appBar, body, searchBar, bottomNavigationBar;
  final Color? backgroundColor, toolbarColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Function(ScrollNotification)? onNotification;
  CustomSliver({
    Key? key,
    required this.appBar,
    required this.body,
    this.onNotification,
    this.backgroundColor,
    this.toolbarColor,
    this.systemOverlayStyle,
    required this.searchBar,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: systemOverlayStyle,
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: onNotification as bool Function(ScrollNotification)?,
        child: Stack(
          children: <Widget>[
            appBar!,
            body!,
            Container(
              height: toolbarColor == Colors.transparent ? 0 : 120,
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
                color: toolbarColor,
              ),
            ),
            searchBar!,
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class BackAppBar extends PreferredSize {
  final Widget title;
  final List<Widget> actions;

  BackAppBar({this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: CupertinoButton(
        child: Icon(
          Icons.arrow_back_sharp,
          color: YELLOW_COLOR,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: title,
      actions: actions,
    );
  }
}

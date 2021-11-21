import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/Constant.dart';

class BackAppBar extends StatelessWidget {
  final Widget? title, leading;
  final List<Widget>? actions;
  //final Brightness brightness;
  final PreferredSizeWidget? bottom;
  final void Function()? onPressed;
  final Color? backgroundColor;

  BackAppBar({
    this.title,
    this.actions,
    //this.brightness,
    this.leading,
    this.bottom,
    this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor == null ? Colors.transparent : backgroundColor,
      elevation: 0.0,
      //centerTitle: true,
      leading: leading != null
          ? leading
          : CupertinoButton(
              child: Icon(
                Icons.arrow_back_sharp,
                color: ICONCOLOR,
              ),
              onPressed: onPressed == null 
                ? () {
                  Navigator.pop(context);
                }
                : onPressed
            ),
      title: title,
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      //brightness: brightness != null ? brightness : Brightness.light,
      bottom: bottom,
    );
  }
}

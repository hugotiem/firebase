import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/const.dart';

import 'custom_text.dart';

class BackAppBar extends StatelessWidget {
  final Widget? title, leading;
  final List<Widget>? actions;
  //final Brightness brightness;
  final PreferredSizeWidget? bottom;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final double? elevation;

  BackAppBar({
    this.title,
    this.actions,
    //this.brightness,
    this.leading,
    this.bottom,
    this.onPressed,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor == null ? Colors.transparent : backgroundColor,
      elevation: elevation != null ? elevation : 0.0,
      //centerTitle: true,
      leading: leading != null
          ? leading
          : CupertinoButton(
              child: Icon(
                Ionicons.arrow_back_outline,
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

class TitleAppBar extends StatelessWidget {
  final String? title;

  const TitleAppBar(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6),
      child: CText(
        title!,
        color: SECONDARY_COLOR,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    );
  }
}

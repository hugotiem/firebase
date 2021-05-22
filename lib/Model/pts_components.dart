import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constant.dart';
import 'components/pts_box.dart';

// containers with blue shadow

// Clickable container
class ClickableContainer extends StatelessWidget {
  final Widget child;
  final Widget to;
  final Color color;
  final Color focusColor;
  final bool containerShadow;
  final bool cupertino;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  ClickableContainer({
    Key key,
    this.child,
    this.color = const Color(0xffffffff),
    this.focusColor = FOCUS_COLOR,
    this.cupertino = true,
    this.containerShadow = false,
    this.padding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.all(0),
    this.to,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                to != null ? to : new Container(color: Colors.white),
          ),
        ),
      },
      child: containerShadow
          ? PTSBox(
              color: color,
              padding: padding,
              child: child,
            )
          : AnimatedContainer(
              padding: padding,
              margin: margin,
              duration: Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: color,
              ),
              child: child,
            ),
    );
  }
}

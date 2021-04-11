import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constant.dart';
import 'components/cupertino_navigator.dart';

// containers with blue shadow
class ContainerShadow extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double height;

  const ContainerShadow({
    Key key,
    this.child,
    this.margin,
    this.padding = const EdgeInsets.all(20),
    this.color = Colors.white,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
      height: height,
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      margin: EdgeInsets.only(top: 40),
      padding: padding,
      duration: Duration(milliseconds: 100),
      child: child,
    );
  }
}

// Clickable container
class ClickableContainer extends StatefulWidget {
  final Widget child;
  final Widget to;
  final Color color;
  final Color focusColor;
  final double radius;
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
    this.radius = 0.0,
    this.padding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.all(0),
    this.to,
  }) : super(key: key);

  @override
  _ClickableContainerState createState() => cupertino
      ? _ClickableContainerState(
          child: child,
          color: color,
          focusColor: focusColor,
          containerShadow: containerShadow,
          radius: radius,
          padding: padding,
          margin: margin,
          to: to,
        )
      : null;
}

class _ClickableContainerState extends State<ClickableContainer> {
  final Widget child;
  final Widget to;
  final Color color;
  final Color focusColor;
  final double radius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool containerShadow;

  _ClickableContainerState({
    this.child,
    this.to,
    this.color,
    this.focusColor,
    this.containerShadow = false,
    this.radius,
    this.padding,
    this.margin,
  });

  Color _color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          new CupertinoNavigator(
            child: to != null ? to : new Container(color: Colors.white),
          ),
        ),
      },
      onTapDown: (_) {
        setState(() {
          _color = focusColor;
        });
      },
      onTapUp: (_) {
        setState(() {
          _color = color;
        });
      },
      onTapCancel: () {
        setState(() {
          _color = color;
        });
      },
      child: containerShadow
          ? ContainerShadow(
              color: _color == null ? color : _color,
              padding: padding,
              child: child,
            )
          : AnimatedContainer(
              padding: padding,
              margin: margin,
              duration: Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: _color == null ? color : _color,
                borderRadius: new BorderRadius.all(
                  Radius.circular(radius),
                ),
              ),
              child: child,
            ),
    );
  }
}

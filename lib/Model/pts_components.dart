import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constant.dart';

// containers with blue shadow
class ContainerShadow extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double height;
  final double width;

  const ContainerShadow({
    Key key,
    this.child,
    this.margin,
    this.padding = const EdgeInsets.all(20),
    this.color = Colors.white,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
      height: height,
      width: width != null ? width : MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: Colors.blue.withOpacity(0.23),
          )
        ],
      ),
      margin: EdgeInsets.only(top: 40),
      padding: padding,
      duration: Duration(milliseconds: 100),
      child: child,
    );
  }
}

// Cupertino transition navigation
class CupertinoNavigator extends CupertinoPageRoute {
  final Widget child;
  CupertinoNavigator({
    this.child,
  }) : super(builder: (BuildContext context) => new GoTo(child: child));
}

class GoTo extends StatelessWidget {
  final Widget child;
  const GoTo({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
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
  final double height;
  final double width;
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
    this.height,
    this.width,
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
          height: height,
          width: width,
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
  final double height;
  final double width;
  final bool containerShadow;

  _ClickableContainerState({
    this.child,
    this.to,
    this.color,
    this.focusColor,
    this.containerShadow = false,
    this.radius,
    this.padding,
    this.height,
    this.width,
    this.margin,
  });

  Color _color;

  @override
  Widget build(BuildContext context) {
    print(width);
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
              height: height != null ? height : double.infinity,
              width: width != null ? width : double.infinity,
              child: child,
            )
          : AnimatedContainer(
              padding: padding,
              margin: margin,
              duration: Duration(milliseconds: 100),
              height: height != null ? height : double.infinity,
              width: width != null ? height : double.infinity,
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

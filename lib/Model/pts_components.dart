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
  final Color color;
  final Color focusColor;
  final bool containerShadow;
  final bool cupertino;
  ClickableContainer({
    Key key,
    this.child,
    this.color = const Color(0xffffffff),
    this.focusColor = FOCUS_COLOR,
    this.cupertino = true,
    this.containerShadow = false,
  }) : super(key: key);

  @override
  _ClickableContainerState createState() => cupertino
      ? _ClickableContainerState(
          child: child,
          color: color,
          focusColor: focusColor,
          containerShadow: containerShadow)
      : null;
}

class _ClickableContainerState extends State<ClickableContainer> {
  final Widget child;
  final Color color;
  final Color focusColor;
  final bool containerShadow;

  _ClickableContainerState(
      {this.child, this.color, this.focusColor, this.containerShadow = false});

  Color _color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          new CupertinoNavigator(
            child: new Container(color: Colors.white),
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
              child: child,
            )
          : AnimatedContainer(
              color: _color == null ? color : _color,
              duration: Duration(milliseconds: 100),
              child: child,
            ),
    );
  }
}

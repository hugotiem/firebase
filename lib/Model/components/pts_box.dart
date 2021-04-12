import 'package:flutter/material.dart';

class PTSBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color color;

  const PTSBox({
    Key key,
    this.child,
    this.margin,
    this.padding = const EdgeInsets.all(20),
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
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

import 'package:flutter/material.dart';

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
    return new Container(
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
      child: child,
    );
  }
}

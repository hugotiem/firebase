import 'package:flutter/cupertino.dart';
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

class CupertinoNavigator extends CupertinoPageRoute {
  //final Widget child;
  CupertinoNavigator() : super(builder: (BuildContext context) => new GoTo());
}

class GoTo extends StatelessWidget {
  //final Widget child;
  const GoTo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GestureDetector(
        // onTap: () => Navigator.pop(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Profil(),
        //   ),
        // ),
        child: new Container(
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';

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
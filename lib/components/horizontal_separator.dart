import 'package:flutter/material.dart';
import 'package:pts/const.dart';

class HorzontalSeparator extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  const HorzontalSeparator({this.padding, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == null ? EdgeInsets.only(top: 40, bottom: 40, left: 21, right: 21) : padding!,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.1, color: FOCUS_COLOR),
          ),
        ),
      ),
    );
  }
}

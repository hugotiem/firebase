import 'package:flutter/material.dart';
import 'package:pts/const.dart';

class BoldText extends StatelessWidget {
  final String? text;
  final double fontSize;
  const BoldText({
    required this.text,
    this.fontSize = 20,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text!,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: this.fontSize,
        color: SECONDARY_COLOR,
      ),
    );
  }
}

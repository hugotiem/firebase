import 'package:flutter/material.dart';
import 'package:pts/const.dart';

class CText extends StatelessWidget {
  @required
  final String? text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const CText(this.text,
      {this.fontSize, this.color, this.fontWeight, this.textAlign, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: textAlign == null ? TextAlign.left : textAlign,
      style: TextStyle(
        fontFamily: PRIMARY_FONT,
        fontSize: fontSize == null ? 14 : fontSize,
        color: color == null ? SECONDARY_COLOR : color,
        fontWeight: fontWeight == null ? FontWeight.w400 : fontWeight,
      ),
    );
  }
}

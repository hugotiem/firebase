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

class DescriptionTextWidget extends StatefulWidget {
  final String? text;

  DescriptionTextWidget({required this.text});

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String? firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text!.length > 75) {
      firstHalf = widget.text!.substring(0, 75);
      secondHalf = widget.text!.substring(75, widget.text!.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Opacity(opacity: 0.7, child: CText(firstHalf!)),
              ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Opacity(
                  opacity: 0.7,
                  child: CText(
                    flag ? (firstHalf! + "...") : (firstHalf! + secondHalf),
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: InkWell(
                    child: Text(flag ? "Afficher" : "Réduire",
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                    onTap: () {
                      setState(() {
                        flag = !flag;
                      });
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/const.dart';

class TitleAppBar extends StatelessWidget {
  final String? title;

  const TitleAppBar(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6),
      child: CText(
        title!,
        color: SECONDARY_COLOR,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    );
  }
}

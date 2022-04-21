import 'package:flutter/material.dart';
import 'package:pts/const.dart';

class InsideLineText extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  const InsideLineText({Key? key, required this.text, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: 1,
                width: double.infinity,
                color: SECONDARY_COLOR,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Text("ou"),
                color: backgroundColor ?? Colors.white,
              )
            ],
          ),
        ],
      ),
    );
  }
}

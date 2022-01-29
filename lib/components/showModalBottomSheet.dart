import 'package:flutter/material.dart';
import 'package:pts/const.dart';

import 'custom_text.dart';

Future<void> customShowModalBottomSheet(
    BuildContext context, List<Widget> children) {
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
    },
  );
}

Widget titleText(String str) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 22),
    child: CText(
      str,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget onTapContainer(BuildContext context, String str, Widget to) {
  return InkWell(
    onTap: () =>
        Navigator.push(context, MaterialPageRoute(builder: (context) => to)),
    child: Container(
      margin: EdgeInsets.only(bottom: 22),
      height: 55,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.23), width: 1.5),
        ),
      ),
      child: CText(
        str,
        fontSize: 18,
      ),
    ),
  );
}

Widget onTapContainerToDialog(
  BuildContext context,
  String str, {
  required String title,
  required String textButton1,
  required String textButton2,
  void Function()? onPressed1,
  void Function()? onPressed2,
  String? content,
}) {
  return InkWell(
    onTap: () {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: content == null ? null : Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: onPressed1,
                child: Text(
                  textButton1,
                  style: TextStyle(
                    color: SECONDARY_COLOR,
                  ),
                ),
              ),
              TextButton(
                onPressed: onPressed2,
                child: Text(
                  textButton2,
                  style: TextStyle(
                    color: SECONDARY_COLOR,
                  ),
                ),
              )
            ],
          );
        },
      );
      
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 22),
      height: 55,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.23), width: 1.5),
        ),
      ),
      child: CText(
        str,
        fontSize: 18,
      ),
    ),
  );
}

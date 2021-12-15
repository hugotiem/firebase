import 'package:flutter/material.dart';
import 'package:pts/const.dart';

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
      ? Text(firstHalf!)
      : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Opacity(
            opacity: 0.7,
            child: Text(
              flag ? (firstHalf! + "...") : (firstHalf! + secondHalf), 
              style: TextStyle(
                fontSize: 16,
                color: SECONDARY_COLOR
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: InkWell(
              child: Text(
                flag ? "Afficher" : "Réduire",
                style: TextStyle(color: Colors.blue, fontSize: 16)
              ),
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
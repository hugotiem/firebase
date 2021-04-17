import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.5),
        boxShadow: [
          BoxShadow(
            color: BLUE_BACKGROUND.withOpacity(0.3),
            offset: Offset(1, 2),
            blurRadius: 4,
            spreadRadius: 2,
          )
        ],
      ),
      child: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Rechercher',
          hintStyle: TextStyle(
            fontSize: 18,
          ),
          icon: Icon(
            Icons.search_rounded,
            size: 20,
            color: YELLOW_COLOR,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

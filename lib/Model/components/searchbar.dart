import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class SearchBar extends StatelessWidget {
  final void Function(String) onChanged;

  const SearchBar({Key key, this.onChanged}) : super(key: key);

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
            color: PRIMARY_COLOR.withOpacity(0.3),
            offset: Offset(1, 2),
            blurRadius: 4,
            spreadRadius: 2,
          )
        ],
      ),
      child: TextField(
        autofocus: true,
        keyboardAppearance: Brightness.light,
        decoration: InputDecoration(
          hintText: 'Rechercher',
          hintStyle: TextStyle(
            fontSize: 18,
          ),
          icon: Icon(
            Icons.search_rounded,
            size: 20,
            color: SECONDARY_COLOR,
          ),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

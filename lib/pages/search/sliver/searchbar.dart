import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/const.dart';

class SearchBar extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function()? onTap;

  const SearchBar({Key? key, this.onChanged, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.5),
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
            Ionicons.search_outline,
            size: 20,
            color: SECONDARY_COLOR,
          ),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
        onTap: onTap,
      ),
    );
  }
}

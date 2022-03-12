import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/const.dart';

class SearchBar extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final bool readOnly;
  final Color? backgroundColor;

  const SearchBar(
      {Key? key,
      this.onChanged,
      this.onTap,
      this.focusNode,
      this.readOnly = false,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(29.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: TextField(
          readOnly: readOnly,
          focusNode: focusNode,
          autofocus: true,
          keyboardAppearance: Brightness.light,
          decoration: InputDecoration(
            hintText: 'Sélectionne ta ville',
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: SECONDARY_COLOR,
            ),
            icon: Icon(
              Ionicons.search,
              size: 25,
              color: SECONDARY_COLOR,
            ),
            border: InputBorder.none,
          ),
          onChanged: onChanged,
          onTap: onTap,
        ),
      ),
    );
  }
}

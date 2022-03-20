import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/const.dart';

class SearchBar extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final bool readOnly;
  final Color? backgroundColor;
  final bool autofocus;
  final Color? borderColor;
  final Color? hintColor;
  final String hintText;

  const SearchBar(
      {Key? key,
      this.onChanged,
      this.onTap,
      this.focusNode,
      this.readOnly = false,
      this.backgroundColor,
      this.autofocus = false,
      this.borderColor,
      this.hintColor,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextField(
        cursorColor: hintColor ?? SECONDARY_COLOR,
        readOnly: readOnly,
        focusNode: focusNode,
        autofocus: autofocus,
        keyboardAppearance: Brightness.light,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          filled: true,
          fillColor: backgroundColor ?? Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: hintColor ?? SECONDARY_COLOR,
          ),
          prefixIcon: Icon(
            Ionicons.search,
            size: 25,
            color: hintColor ?? SECONDARY_COLOR,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(29.5),
            borderSide: borderColor == null
                ? BorderSide.none
                : BorderSide(color: borderColor!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(29.5),
            borderSide: borderColor == null
                ? BorderSide.none
                : BorderSide(color: borderColor!, width: 1),
          ),
        ),
        onChanged: onChanged,
        onTap: onTap,
      ),
    );
  }
}

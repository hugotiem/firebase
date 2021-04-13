import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
          width: 250,
          height: 40,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(  
            color: Colors.white,
            borderRadius: BorderRadius.circular(29.5),
            boxShadow: [
              BoxShadow(  
                color: BLUE_BACKGROUND.withOpacity(0.3),
                offset: Offset(1, 2),
                blurRadius: 4,
                spreadRadius: 2
              )
            ]
          ),
          child: TextField(
            decoration: InputDecoration(
            hintText: 'Rechercher',
            hintStyle: TextStyle(
              fontSize: 11,
            ),
            icon: Icon(
              Icons.search_rounded,
              size: 20,
              ),
            border: InputBorder.none,
            ),
          )
      ),
    );
  }
}
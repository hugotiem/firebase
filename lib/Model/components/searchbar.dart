import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: Container(
                padding: EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Rechercher',
                    suffixIcon: Icon(Icons.search_rounded)
                    ),
                )
            ),
    );
  }
}
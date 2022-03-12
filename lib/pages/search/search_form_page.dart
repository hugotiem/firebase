import 'package:flutter/material.dart';
import 'package:pts/pages/search/sliver/searchbar.dart';

class SearchFormPage extends StatelessWidget {
  SearchFormPage({Key? key}) : super(key: key);

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Hero(
          tag: 'search-widget',
          child: SearchBar(
            onChanged: (value) {},
            focusNode: focusNode,
          ),
        ),
      ),
    );
  }
}

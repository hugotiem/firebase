import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/searchbar.dart';
import 'package:pts/View/Pages/search/resluts_screen.dart';
import 'package:pts/blocs/application_bloc.dart';

class SearchBarScreen extends StatefulWidget {
  SearchBarScreen({Key key}) : super(key: key);

  @override
  _SearchBarScreenState createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final ApplicationBloc applicationBloc = new ApplicationBloc();

  String _search = "";
  bool _results = false;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _panelSize = _size.height - 150;
    return Hero(
      tag: 'test',
      child: Scaffold(
        //backgroundColor: PRIMARY_COLOR,
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          brightness: Brightness.light,
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Container(
              width: _size.width,
              color: PRIMARY_COLOR,
              padding: EdgeInsets.only(top: 50, bottom: 40),
              child: SearchBar(
                onChanged: (value) {
                  setState(() {
                    _search = value;
                  });
                },
              ),
            ),
            Container(
              height: _size.height - 150,
              child: _results
                  ? ResultsScreen()
                  : FutureBuilder(
                      future: applicationBloc.searchPlaces(_search),
                      builder: (context, snapshots) {
                        return Container(
                          color: PRIMARY_COLOR,
                          child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: applicationBloc.searchResults.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  applicationBloc
                                      .searchResults[index].description,
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    _results = true;
                                  });
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

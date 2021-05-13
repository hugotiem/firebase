import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/searchbar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:pts/blocs/application_bloc.dart';

class SearchBarScreen extends StatefulWidget {
  SearchBarScreen({Key key}) : super(key: key);

  @override
  _SearchBarScreenState createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final ApplicationBloc applicationBloc = new ApplicationBloc();
  PanelController _panelController = PanelController();

  String _search = "";
  bool _results = false;

  double _factor = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
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
              color: PRIMARY_COLOR.withOpacity(1 - _factor),
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
              child: SlidingUpPanel(
                defaultPanelState: PanelState.OPEN,
                controller: _panelController,
                snapPoint: 0.5,
                minHeight: 100,
                maxHeight: _size.height - 150,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36 * _factor),
                  topRight: Radius.circular(36 * _factor),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 8.0 * _factor,
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                  ),
                ],
                // collapsed: Container(
                //   color: Colors.transparent,
                // ),
                panelBuilder: (ScrollController sc) {
                  return _results
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(36 * _factor),
                              topRight: Radius.circular(36 * _factor),
                            ),
                            color: PRIMARY_COLOR,
                          ),
                          child: ListView.builder(
                            controller: sc,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(20),
                                height: 100,
                                color: Colors.red,
                              );
                            },
                          ),
                        )
                      : FutureBuilder(
                          future: applicationBloc.searchPlaces(_search),
                          builder: (context, snapshots) {
                            return Container(
                              color: PRIMARY_COLOR,
                              child: ListView.builder(
                                padding: EdgeInsets.all(0),
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

                                        _panelController
                                            .animatePanelToSnapPoint(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );
                                      });
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                },

                onPanelSlide: (position) {
                  setState(() {
                    if (position > 0.5) {
                      _factor = 0;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

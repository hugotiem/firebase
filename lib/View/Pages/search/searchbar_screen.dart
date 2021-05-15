import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/searchbar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math' as math;
import 'package:pts/blocs/application_bloc.dart';

class SearchBarScreen extends StatefulWidget {
  SearchBarScreen({Key key}) : super(key: key);

  @override
  _SearchBarScreenState createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen>
    with TickerProviderStateMixin {
  final ApplicationBloc applicationBloc = new ApplicationBloc();
  PanelController _panelController = PanelController();
  AnimationController _animationController;
  ScrollController _sc;

  String _search = "";
  bool _hasResults = false;
  bool _isDissmissed = false;

  double _factor = 0;
  double _rotation = 0;

  Brightness _brightness = Brightness.light;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: SECONDARY_COLOR,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        brightness: _brightness,
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
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Transform.rotate(
                    angle:
                        _isDissmissed ? (-90 * _rotation) * math.pi / 180 : 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: _factor == 1 ? ICONCOLOR : SECONDARY_COLOR,
                      ),
                      onPressed: () async {
                        if (!_isDissmissed || _rotation == 0)
                          Navigator.of(context).pop();
                        else {
                          FocusScope.of(context).unfocus();

                          _hasResults = true;

                          _panelController.animatePanelToPosition(
                            0.5,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                          _animationController.animateTo(0, curve: Curves.ease);
                          _animationController.addListener(() {
                            setState(() {
                              _rotation = _animationController.value;
                            });
                          });
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    child: SearchBar(
                      onChanged: (value) {
                        setState(() {
                          _search = value;
                        });
                      },
                      onTap: () {
                        _hasResults = false;
                        _panelController.animatePanelToPosition(
                          1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                        _animationController.animateTo(1, curve: Curves.ease);
                        _animationController.addListener(() {
                          setState(() {
                            _rotation = _animationController.value;
                          });
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: _size.height - 150,
            child: SlidingUpPanel(
              isDraggable: _hasResults,
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
              panelBuilder: (ScrollController sc) {
                _sc = sc;
                return _hasResults
                    ? Container(
                        clipBehavior: Clip.antiAlias,
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.white,
                              ),
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
                                      _hasResults = true;

                                      _panelController
                                          .animatePanelToSnapPoint(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.ease,
                                          )
                                          .whenComplete(
                                              () => _isDissmissed = true);
                                      _animationController.animateTo(0,
                                          curve: Curves.ease);
                                      _animationController.addListener(() {
                                        setState(() {
                                          _rotation =
                                              _animationController.value;
                                        });
                                      });
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
                  if (position >= 0.8) {
                    _factor = 1 - ((position * 5) - 4);
                    _brightness = Brightness.light;
                  } else if (position < 0.8) {
                    _factor = 1;
                    _brightness = Brightness.dark;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

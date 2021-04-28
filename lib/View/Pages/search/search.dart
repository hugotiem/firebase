import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/components/backgroundtitle.dart';
import 'package:pts/Model/components/custom_sliver.dart';
import 'package:pts/View/Pages/search/searchbar_page.dart';

import '../../../../Constant.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  double _size;
  double current;
  double _opacity;
  double _barSizeWidth;
  double _barSizeHeight;
  bool _isOpen = false;
  Brightness _brightness = Brightness.dark;

  @override
  void initState() {
    setState(() {
      _size = 400;
      current = 0;
      _opacity = 1;
      _barSizeWidth = 350;
      _barSizeHeight = 60;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSliver(
      backgroundColor: PRIMARY_COLOR,
      brightness: _brightness,
      appBar: Container(
        height: _size,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: SECONDARY_COLOR.withOpacity(_opacity),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
        ),
        child: Container(
          child: Stack(
            children: [
              Positioned(
                top: (_size - 100) / 2,
                width: MediaQuery.of(context).size.width,
                child: Opacity(
                  opacity: _opacity,
                  child: Center(child: BackGroundtitle()),
                ),
              ),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchBarPage(),
                          ),
                        );
                      },
                      child: Hero(
                        tag: "test",
                        child: Container(
                          width: _barSizeWidth,
                          height: _barSizeHeight,
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
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Icon(
                                    Icons.search_rounded,
                                    size: 20,
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.7,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      "Rechercher",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            margin: EdgeInsets.only(top: index == 0 ? 350 : 0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Card(
                color: Colors.white,
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      Container(),
                      closeContent(this._isOpen ? 400 : 150),
                    ],
                  ),
                ),
              ),
              onTap: () {
                open();
              },
            ),
          );
        },
      ),
      onNotification: (notification) {
        setState(() {
          if (!(notification is ScrollStartNotification)) {
            double _pixels = notification.metrics.pixels;
            if (_pixels <= 400 && (400 - _pixels) >= 100) {
              _size = 400 - _pixels;

              if (_pixels >= 250) {
                _opacity = (_size - 100) / 50;
              } else if (_pixels <= 250) {
                _opacity = 1;
              }
              _barSizeWidth = 350 - (_pixels / 8);
              _barSizeHeight = 60 - (_pixels / 15);
            } else if (_pixels > 300) {
              _size = 100;
              _opacity = 0;
              _brightness = Brightness.light;
            }
          }
        });

        return true;
      },
    );
  }

  void open() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  Widget closeContent(double _height) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.ease,
      height: _height,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      "\$14",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Opacity(
                            opacity: 0.6,
                            child: Text("TODAY"),
                          ),
                        ),
                        Container(
                          child: Text(
                            "05:50 PM",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Nom de l'organisateur",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Opacity(
                            opacity: 0.6,
                            child: Text(
                              "Catégorie de la soirée",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Opacity(
                                opacity: 0.6,
                                child: Text(
                                  "PERSONNES",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(Icons.person),
                                ),
                                Container(
                                  child: Text("14"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Opacity(
                                opacity: 0.6,
                                child: Text(
                                  "prix".toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(Icons.attach_money_outlined),
                                ),
                                Container(
                                  child: Text("14"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Opacity(
                                opacity: 0.6,
                                child: Text(
                                  "lieu".toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(Icons.location_on),
                                ),
                                Container(
                                  child: Text("Caen"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

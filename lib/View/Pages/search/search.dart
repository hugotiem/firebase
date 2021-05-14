import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/components/backgroundtitle.dart';
import 'package:pts/Model/components/custom_sliver.dart';
import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/View/Pages/search/searchbar_screen.dart';
import 'package:animations/animations.dart';

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
  Brightness _brightness;
  Color _toolbarColor;
  int _index = 0;

  FireStoreServices _firestore = new FireStoreServices("Soirée");

  @override
  void initState() {
    setState(() {
      _size = 400;
      current = 0;
      _opacity = 1;
      _barSizeWidth = 350;
      _barSizeHeight = 60;
      _brightness = Brightness.dark;
      _toolbarColor = Colors.transparent;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSliver(
      backgroundColor: PRIMARY_COLOR,
      brightness: _brightness,
      toolbarColor: _toolbarColor,
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
                  child: Center(
                    child: BackGroundtitle(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox.expand(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 350,
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                      child: Text(
                        'A proximité',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: SECONDARY_COLOR,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        controller: PageController(viewportFraction: 0.85),
                        onPageChanged: (int index) =>
                            setState(() => _index = index),
                        itemBuilder: (_, i) {
                          return Transform.scale(
                            scale: 1,
                            child: GridView.count(
                              childAspectRatio: (100 / 320),
                              crossAxisCount: 2,
                              scrollDirection: Axis.horizontal,
                              children: [
                                Stack(children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.white,
                                            )),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: Text(
                                                    'Nom',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                child: Opacity(
                                                  opacity: 0.7,
                                                  child: Text(
                                                    'description',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                                Stack(children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.white,
                                            )),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: Text(
                                                    'Nom',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                child: Opacity(
                                                  opacity: 0.7,
                                                  child: Text(
                                                    'description',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                    child: Text(
                      "Thèmes",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: SECONDARY_COLOR,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 320,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      controller: PageController(viewportFraction: 0.85),
                      onPageChanged: (int index) =>
                          setState(() => _index = index),
                      itemBuilder: (_, i) {
                        return Transform.scale(
                            scale: 1,
                            child: GridView.count(
                                crossAxisCount: 1,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 300,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        child: Container(
                                            decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                        )),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 8),
                                          alignment: Alignment.bottomLeft,
                                          child: Opacity(
                                            opacity: 0.7,
                                            child: Text(
                                              'Thème',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ]));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      "Soirées étudiantes :",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: SECONDARY_COLOR,
                      ),
                    ),
                  ),
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            height: 140,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            height: 140,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            height: 140,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            height: 140,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            height: 140,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 60),
              height: 500,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: SECONDARY_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                      "Organise ta propre soirée !",
                      style: TextStyle(
                        color: ICONCOLOR,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      //width: MediaQuery.of(context).size.width - 100,
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: ICONCOLOR,
                        borderRadius: BorderRadius.all(
                          Radius.circular(200),
                        ),
                      ),
                      child: Text(
                        "Créer maintenant !".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // child: StreamBuilder(
        //   stream: _firestore.getSnapshots(),
        //   builder: (context, snapshot) {
        //     if (!snapshot.hasData) return CircularProgressIndicator();
        //     //print(snapshot.data.docs[1].id);
        //     return ListView.builder(
        //       itemCount: snapshot.data.docs.length,
        //       itemBuilder: (context, index) {
        //         Widget _container = Container(
        //           padding: const EdgeInsets.all(8.0),
        //           //margin: EdgeInsets.only(top: index == 0 ? 350 : 0),
        //           child: GestureDetector(
        //             behavior: HitTestBehavior.translucent,
        //             child: Card(
        //               color: Colors.white,
        //               child: Container(
        //                 child: Stack(
        //                   children: <Widget>[
        //                     Container(),
        //                     closeContent(
        //                         this._isOpen ? 400 : 150, index, snapshot),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             onTap: () {
        //               open();
        //             },
        //           ),
        //         );
        //         if (index == 0) {
        //           return Stack(
        //             children: <Widget>[
        //               Column(
        //                 children: <Widget>[
        //                   SizedBox(
        //                     height: 350,
        //                   ),
        //                   _container,
        //                 ],
        //               ),
        //             ],
        //           );
        //         }
        //         return _container;
        //       },
        //     );
        //   },
        // ),
      ),
      onNotification: (notification) {
        setState(() {
          if (!(notification is ScrollStartNotification) &&
              notification.metrics.axis != Axis.horizontal) {
            double _pixels = notification.metrics.pixels;
            if (_pixels <= 400 && (400 - _pixels) >= 100) {
              _size = 400 - _pixels;
              _brightness = Brightness.dark;
              _toolbarColor = Colors.transparent;

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
              _toolbarColor = PRIMARY_COLOR;
            }
          }
        });

        return true;
      },
      searchBar: Column(
        children: [
          SizedBox(
            height: (_size - 80) > 50 ? _size - 80 : 50,
          ),
          Center(
            child: OpenContainer(
              tappable: true,
              transitionDuration: Duration(milliseconds: 400),
              closedColor: Colors.white,
              openColor: Colors.white,
              closedElevation: 0,
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29.5),
              ),
              closedBuilder: (context, returnValue) {
                return Container(
                  width: _barSizeWidth,
                  height: _barSizeHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: ICONCOLOR,
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
                );
              },
              openBuilder: (context, returnValue) {
                return SearchBarScreen();
              },
            ),
          ),
        ],
      ),
    );
  }

  void open() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  Widget closeContent(double _height, index, snapshot) {
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
                              snapshot.data.docs[index]["Theme"],
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

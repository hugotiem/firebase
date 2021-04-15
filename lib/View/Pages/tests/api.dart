import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/components/backgroundtitle.dart';

import '../../../Constant.dart';

class API extends StatefulWidget {
  API({Key key}) : super(key: key);

  @override
  _APIState createState() => _APIState();
}

class _APIState extends State<API> {
  double _size;
  double current;
  double _opacity;
  double _barSizeWidth;
  double _barSizeHeight;
  bool _isOpen = false;
  ScrollController _scrollController;

  @override
  void initState() {
    setState(() {
      _size = 300;
      current = 0;
      _opacity = 1;
      _barSizeWidth = 350;
      _barSizeHeight = 60;
      _scrollController = ScrollController();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BLUE_BACKGROUND,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          setState(() {
            if (!(notification is ScrollStartNotification)) {
              double _pixels = notification.metrics.pixels;
              if (_pixels <= 300 && (300 - _pixels) >= 100) {
                _size = 300 - _pixels;
                _opacity = (_size - 100) / 200;
                _barSizeWidth = 350 - (_pixels / 3);
                _barSizeHeight = 60 - (_pixels / 9);
              } else if (_pixels > 300) {
                _size = 100;
                _opacity = 0;
              }
            }
          });
          return true;
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: 2000,
                // child: ListView.builder(
                //   itemCount: 10,
                //   controller: _scrollController,
                //   itemBuilder: (context, index) {
                //     return Container(
                //       padding: const EdgeInsets.all(8.0),
                //       margin: EdgeInsets.only(top: index == 0 ? 300 : 0),
                //       child: GestureDetector(
                //         child: Card(
                //           color: Colors.white,
                //           child: Container(
                //             child: Stack(
                //               children: <Widget>[
                //                 Container(),
                //                 closeContent(_isOpen ? 300 : 150),
                //               ],
                //             ),
                //           ),
                //         ),
                //         onTap: () {
                //           setState(() {
                //             _isOpen = !_isOpen;
                //           });
                //         },
                //       ),
                //     );
                //   },
                // ),
              ),
            ),
            Container(
              height: _size,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: YELLOW_COLOR.withOpacity(_opacity),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
                // image: DecorationImage(
                //   alignment: Alignment.topCenter,
                //   image: AssetImage("assets/images/abstract-1268.png"),
                // ),
              ),
              child: Container(
                //height: _size,
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
                        child: Container(
                          width: _barSizeWidth,
                          height: _barSizeHeight,
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(29.5),
                            boxShadow: [
                              BoxShadow(
                                color: BLUE_BACKGROUND.withOpacity(0.3),
                                offset: Offset(1, 2),
                                blurRadius: 4,
                                spreadRadius: 2,
                              )
                            ],
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
                          ),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/components/backgroundtitle.dart';
import 'package:pts/Model/components/custom_sliver.dart';
import 'package:pts/Model/components/text_materials.dart';
import 'package:pts/Model/services/auth_service.dart';
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
              height: 325,
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 60, left: 20),
                      child: BoldText(text: "Dernières créées"),
                    ),
                    SizedBox(
                      height: 250,
                      child: StreamBuilder(
                        stream: getPartyStreamSnapshot(context),
                        builder:  (context, snapshot) {
                          if (!snapshot.hasData) return const Text('Loading...');
                          return PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.docs.length,
                            controller: PageController(viewportFraction: 0.85),
                            onPageChanged: (int index) =>
                                setState(() => _index = index),
                            itemBuilder: (BuildContext context, int index) => 
                              buildPartyCard(context, snapshot.data.docs[index])
                          );
                        }
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
                    margin: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                    child: BoldText(
                      text: "Thèmes",
                    ),
                  ),
                  SizedBox(
                    //height: 310,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 10, left: 40, right: 10),
                              height: 145,
                              width: 145,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFf12711),
                                      Color(0xFFf5af19)
                                    ]),
                              ),
                              child: Center(
                                child: Text('Classiques'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 10, left: 40, right: 10),
                              height: 145,
                              width: 145,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF1c92d2),
                                      Color(0xFFf2fcfe)
                                    ]
                                  ),
                              ),
                              child: Center(
                                child: Text('Gamings'),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 10, left: 40, right: 10),
                              height: 145,
                              width: 145,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFa8ff78),
                                      Color(0xFF78ffd6)
                                    ]),
                              ),
                              child: Center(
                                child: Text('Jeux de sociétés'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 10, left: 40, right: 10),
                              height: 145,
                              width: 145,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFb24592),
                                      Color(0xFFf15f79)
                                    ]),
                              ),
                              child: Center(
                                child: Text('Soirées à thèmes'),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                    child: BoldText(
                      text: "Soirées étudiantes :",
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

  Stream<QuerySnapshot> getPartyStreamSnapshot(BuildContext context) async* {
    yield* FirebaseFirestore.instance
    .collection('party')
    .snapshots();
  }

  Widget buildPartyCard(BuildContext context, DocumentSnapshot party) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            margin: EdgeInsets.only(right: 15),
            height: 250,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: OpenContainer(
              closedElevation: 0,
              transitionDuration: Duration(milliseconds: 400),
              closedColor: Colors.white,
              openColor: Colors.white,
              closedBuilder: (context, returnValue) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 145,
                          height: 145,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFb24592),
                                Color(0xFFf15f79)
                              ]
                            ),
                          )
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 5),
                              child: Container(
                                height: 50,
                                width: 50,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, top: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      AuthService.auth.currentUser.displayName.split(" ")[0],
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star_rate_rounded,
                                      color: ICONCOLOR,
                                      ),
                                      Text('4.9')
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    party['Name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(),
                                  child: Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      party['city'],
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8, right: 8),
                      alignment: Alignment.topRight,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 8, bottom: 8),
                            child: Text(
                              party['Price'],
                              style: TextStyle(  
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text( 
                              '€',
                              style: TextStyle(  
                                fontSize: 20
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
              openBuilder: (context, returnValue) {
                return Scaffold(  
                  appBar: PreferredSize(  
                    preferredSize: Size.fromHeight(50),
                    child: BackAppBar(),
                  ),
                  body: Container( 
                    child: Column(
                      children: <Widget> [
                        Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 20
                            ),
                          child: Container( 
                            child: Text(
                              party['Name'],
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900
                              ),
                            )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container( 
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Date :',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container( 
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Heure :',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container( 
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Description :',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                );
              },
            ),
          ),
        ), 
      ],
    );
  }
}

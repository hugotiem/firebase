import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/SearchBar.dart';
import 'package:pts/Model/components/backgroundtitle.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Widget _customScrollView() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          expandedHeight: MediaQuery.of(context).size.height * 0.45,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: SearchBar(),
            background: Container(
              decoration: BoxDecoration(
                color: YELLOW_COLOR,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
                image: DecorationImage(  
                  alignment: Alignment.topCenter,
                  image: AssetImage("assets/images/abstract-1268.png"),
                )
              ),
              child: BackGroundtitle(),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Card(
                  color: Colors.white,
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        openContent(),
                        closeContent(_isOpen ? 300 : 150),
                      ],
                    ), //_isOpen ?  : ,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _isOpen = !_isOpen;
                  });
                },
              ),
            ),
            childCount: 10,
          ),
        )
      ],
    );
  }

  bool _isOpen = false;

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

  Widget openContent() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _customScrollView(),
      backgroundColor: BLUE_BACKGROUND,
    );
  }
}

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animations/animations.dart';
import 'package:pts/View/Pages/search/sliver/searchbar_screen.dart';
import 'package:pts/view/pages/creation/creation_page.dart';
import '../../../../../Constant.dart';

import 'subpage/city_page.dart';
import 'subpage/last_party_page.dart';
import 'subpage/themes_page.dart';
import 'sliver/backgroundtitle.dart';
import 'sliver/custom_sliver.dart';

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
              height: 400,
            ),
            // liste des 10 villes les plus grandes de france
            // quand on clique dessus on arrive sur une liste des soirées dans cette ville
            TitleText(
              text: 'Villes',
              margin: EdgeInsets.only(left: 20),
            ),
            GridViewCity(),
            // liste des dernières soirées créées
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(
                    text: 'Dernières soirées créées',
                    margin: EdgeInsets.only(top: 30, left: 20)),
                SizedBox(height: 270, child: CardParty()),
              ],
            )),
            // listes des thèmes de soirées
            TitleText(
              text: 'Thèmes',
              margin: EdgeInsets.only(left: 20, top: 30),
            ),
            GridListThemes(),
            // container qui permet de créer une soirée
            ContainerAddParty(),
          ],
        ),
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
}

class ContainerAddParty extends StatefulWidget {
  const ContainerAddParty({Key key}) : super(key: key);

  @override
  _ContainerAddPartyState createState() => _ContainerAddPartyState();
}

class _ContainerAddPartyState extends State<ContainerAddParty> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CreationPage()));
            },
            child: Container(
              //width: MediaQuery.of(context).size.width - 100,
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
    );
  }
}

class TitleText extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final String text;
  const TitleText({this.margin, @required this.text, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.margin,
      child: Text(
        this.text,
        style: TextStyle(
            fontWeight: FontWeight.w900, fontSize: 20, color: SECONDARY_COLOR),
      ),
    );
  }
}

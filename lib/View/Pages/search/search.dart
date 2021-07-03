import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/components/text_materials.dart';
import 'package:pts/View/Pages/search/backgroundtitle.dart';
import 'package:pts/View/Pages/search/custom_sliver.dart';
import 'package:pts/View/Pages/search/gridlistcity.dart';
import 'package:pts/View/Pages/search/searchbar_screen.dart';
import 'package:animations/animations.dart';
import '../../../../Constant.dart';

import 'cardparty.dart';
import 'containeraddparty.dart';
import 'gridlistthemes.dart';

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
              height: 325,
            ),
            // liste des 10 villes les plus grandes de france 
            // quand on clique dessus on arrive sur une liste des soirées dans cette ville
            GridViewCity(),   
            // liste des soirées 
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container( 
                    margin: EdgeInsets.only(top: 30, left: 20),
                    child: BoldText(text: "Dernières créées"),
                  ),
                  SizedBox(
                    height: 220,
                    child: CardParty()
                  ),
                ],
              )
            ),
            // listes des thèmes de soirées
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

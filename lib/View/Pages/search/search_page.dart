import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter/services.dart';
import 'package:pts/View/Pages/search/sliver/searchbar_screen.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/constant.dart';
import 'package:pts/view/pages/creation/creation_page.dart';
import 'package:pts/view/pages/search/subpage/geolocalisation_page.dart';
import 'subpage/city_page.dart';
// import 'subpage/last_party_page.dart';
import 'subpage/themes_page.dart';
import 'sliver/custom_sliver.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  double? _size;
  double? current;
  late double _opacity;
  double? _barSizeWidth;
  double? _barSizeHeight;
  Color? _toolbarColor;
  SystemUiOverlayStyle? _systemOverlayStyle;

  @override
  void initState() {
    setState(() {
      _size = 400;
      current = 0;
      _opacity = 1;
      _barSizeWidth = 350;
      _barSizeHeight = 60;
      _systemOverlayStyle = SystemUiOverlayStyle.light;
      _toolbarColor = Colors.transparent;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSliver(
      backgroundColor: PRIMARY_COLOR,
      systemOverlayStyle: _systemOverlayStyle,
      toolbarColor: _toolbarColor,
      appBar: Opacity(
        opacity: _opacity,
        child: Container(
          height: _size,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              // opacity: _opacity,
              fit: BoxFit.cover,
              image: AssetImage('assets/map.png'),
            ),
            // opacity: _opacity,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          child: Container(
            child: Stack(
              children: [
                Positioned(
                  top: (_size! - 100) / 2,
                  right: 75,
                  width: MediaQuery.of(context).size.width,
                  child: Opacity(
                    opacity: _opacity,
                    child: Center(
                      child: Icon(
                        // BackGroundtitle(),
                        Icons.location_on_outlined,
                        size: 50,
                        color: ICONCOLOR,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: (_size! - 100) / 2,
                  left: 90,
                  bottom: 29,
                  width: MediaQuery.of(context).size.width,
                  child: Opacity(
                    opacity: _opacity,
                    child: Center(
                        child: Icon(Icons.location_on_outlined,
                            size: 50, color: ICONCOLOR)),
                  ),
                ),
              ],
            ),
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
            TitleText(
              text: 'New ville',
              margin: EdgeInsets.only(left: 20, top: 30),
            ),
            NewCityGrid(),
            GeolocationWidget(),
            // liste des dernières soirées créées
            // Container(
            //     child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     TitleText(
            //         text: 'Dernières soirées créées',
            //         margin: EdgeInsets.only(top: 30, left: 20)),
            //     SizedBox(height: 270, child: CardParty()),
            //   ],
            // )),
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
              _toolbarColor = Colors.transparent;

              if (_pixels >= 250) {
                _opacity = (_size! - 100) / 50;
              } else if (_pixels <= 250) {
                _opacity = 1;
              }
              _barSizeWidth = 350 - (_pixels / 8);
              _barSizeHeight = 60 - (_pixels / 15);
            } else if (_pixels > 300) {
              _size = 100;
              _opacity = 0;
              _toolbarColor = PRIMARY_COLOR;
            }
          }
        });

        return true;
      },
      searchBar: Column(
        children: [
          SizedBox(
            height: (_size! - 80) > 50 ? _size! - 80 : 50,
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
                            child: CText(
                              "Rechercher",
                              fontSize: 18,
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
  const ContainerAddParty({Key? key}) : super(key: key);

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
            child: CText(
              "Organise ta propre soirée !",
              color: ICONCOLOR,
              fontSize: 40,
              fontWeight: FontWeight.w900,
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreationPage()));
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
              child: CText(
                "Créer maintenant !".toUpperCase(),
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
  final EdgeInsetsGeometry? margin;
  final String text;
  const TitleText({this.margin, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.margin,
      child: CText(
        this.text,
        fontWeight: FontWeight.w900,
        fontSize: 20,
      ),
    );
  }
}

class NewCityGrid extends StatelessWidget {
  const NewCityGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Container(
                  height: 350,
                  width: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/toureiffel2.png")),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Container(
                  height: 350,
                  width: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/toureiffel2.png")),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Container(
                  height: 350,
                  width: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/toureiffel2.png")),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

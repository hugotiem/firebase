import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/pages/search/search_form_page.dart';
import 'package:pts/pages/search/sliver/searchbar.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/const.dart';
import 'package:pts/pages/creation/creation_page.dart';
import 'package:pts/pages/search/subpage/geolocalisation_page.dart';
import 'subpage/city_page.dart';
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

  Color? _toolbarColor;
  SystemUiOverlayStyle? _systemOverlayStyle;

  @override
  void initState() {
    setState(() {
      _size = 400;
      current = 0;
      _opacity = 1;
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
              fit: BoxFit.cover,
              image: AssetImage('assets/cityview.png'),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
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
            // GridViewCity(),
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
              text: 'Catégories de soirées',
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
              _systemOverlayStyle = SystemUiOverlayStyle.light;
              if (_pixels >= 250) {
                _opacity = (_size! - 100) / 50;
              } else if (_pixels <= 250) {
                _opacity = 1;
              }
            } else if (_pixels > 300) {
              _size = 100;
              _opacity = 0;
              _toolbarColor = PRIMARY_COLOR;
              _systemOverlayStyle = SystemUiOverlayStyle.dark;
            }
          }
        });

        return true;
      },
      searchBar: Container(
        margin: EdgeInsets.only(
            right: 30,
            left: 30,
            top:
                (_size! - 100) > 50 ? _size! - 100 : 50), //(_size ?? 0) - 130),

        child: Hero(
          tag: 'search-widget',
          child: SearchBar(
              hintText: 'Sélectionne ta ville',
              backgroundColor: Colors.white.withOpacity(0.8),
              readOnly: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchFormPageLauncher(),
                    fullscreenDialog: true,
                  ),
                );
              }),
        ),
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
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w900,
              textAlign: TextAlign.center,
            ),
          ),
          Image.asset(
            "assets/logo.png",
            height: 200,
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

import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/searchbar.dart';
import 'package:pts/blocs/application_bloc.dart';

class SearchBarPage extends StatefulWidget {
  SearchBarPage({Key key}) : super(key: key);

  @override
  _SearchBarPageState createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  final ApplicationBloc applicationBloc = new ApplicationBloc();

  String _search = "";

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'test',
      child: Scaffold(
        backgroundColor: PRIMARY_COLOR,
        appBar: AppBar(
          brightness: Brightness.dark,
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: SearchBar(
                onChanged: (value) {
                  setState(() {
                    _search = value;
                  });
                },
              ),
            ),
            FutureBuilder(
              future: applicationBloc.searchPlaces(_search),
              builder: (context, snapshots) {
                return Container(
                  height: 400,
                  child: ListView.builder(
                    itemCount: applicationBloc.searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          applicationBloc.searchResults[index].description,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    },
                  ),
                  // height: 300,
                  // child: GoogleMap(
                  //   mapType: MapType.normal,
                  //   myLocationEnabled: true,
                  //   initialCameraPosition:
                  //       CameraPosition(target: LatLng(41.8781, -87.6298)),
                  // ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Searchbar1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: 0,
            child: Center(
              child: Hero(
                tag: "test",
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: SearchBar(),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 100),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 30, left: 30),
                    child: Text(
                      "Resultats de la recherche",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 80,
                          color: Colors.white,
                          child: Center(
                              child: Text(
                            "RESULT",
                          )),
                        );
                      },
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

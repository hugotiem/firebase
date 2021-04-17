import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/searchbar.dart';

class SearchBarPage extends StatefulWidget {
  SearchBarPage({Key key}) : super(key: key);

  @override
  _SearchBarPageState createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BLUE_BACKGROUND,
        appBar: AppBar(
          brightness: Brightness.dark,
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Searchbar1());
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

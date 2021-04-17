import 'package:flutter/material.dart';
import 'package:pts/Model/components/searchbar.dart';

class API extends StatelessWidget {
  API({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Searchbar1(),
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
                  margin: EdgeInsets.only(top: 50),
                  child: SearchBar(),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 140),
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 1),
                  height: 100,
                  width: 300,
                  color: Colors.red,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

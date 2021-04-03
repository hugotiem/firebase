import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: new Container(
            height: 100,
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 10,
                  color: Colors.blue.withOpacity(0.23),
                )
              ],
            ),
            margin: EdgeInsets.only(top: 40),
            padding: EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.all(20),
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "Name",
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    new Text("show profile"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

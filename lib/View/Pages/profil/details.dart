import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProfilDetails extends StatefulWidget {
  ProfilDetails({Key key}) : super(key: key);

  @override
  _ProfilDetailsState createState() => _ProfilDetailsState();
}

class _ProfilDetailsState extends State<ProfilDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: CupertinoButton(
          child: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        actions: <Widget>[
          CupertinoButton(
            onPressed: () {},
            child: Text(
              "Modifier",
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

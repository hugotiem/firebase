import 'package:flutter/material.dart';

import '../../../Constant.dart';

class ContainerAddParty extends StatefulWidget {
  const ContainerAddParty({ Key key }) : super(key: key);

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
            child: Container(
              //width: MediaQuery.of(context).size.width - 100,
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.symmetric(
                vertical: 20, horizontal: 20),
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
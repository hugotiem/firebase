import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pts/const.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/pts_box.dart';

class ProfilDetails extends StatefulWidget {
  ProfilDetails({Key? key}) : super(key: key);
  @override
  _ProfilDetailsState createState() => _ProfilDetailsState();
}

class _ProfilDetailsState extends State<ProfilDetails> {
  @override
  Widget build(BuildContext context) {
    // var _creationDate = AuthService.auth.currentUser.metadata.creationTime;

    List _month = [
      "Janv.",
      "Févr.",
      "Mars",
      "Avr.",
      "Mai",
      "Juin",
      "Juill.",
      "Août",
      "Sept.",
      "Oct.",
      "Nov.",
      "Déc."
    ];

    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          actions: <Widget>[
            CupertinoButton(
              onPressed: () {},
              child: Text(
                "Modifier",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: SECONDARY_COLOR,
                ),
              ),
            ),
          ],
          //brightness: Brightness.dark,
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              PTSBox(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "AuthService.auth.currentUser.displayName",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Opacity(
                                  opacity: 0.5,
                                  child: Text(
                                    "A rejoint en ",//${_month[_creationDate.month - 1]} ${_creationDate.year}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            width: 80,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.5),
                            ),
                            child: GestureDetector(
                              onTap: () {},
                              child: Image.network(
                                'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.star_rate_rounded,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Opacity(
                                  opacity: 0.7,
                                  child: Text(
                                    "3 avis",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.check_rounded,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Opacity(
                                  opacity: 0.7,
                                  child: Text(
                                    "Identité verifiée",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              PTSBox(),
            ],
          ),
        ),
      ),
    );
  }
}

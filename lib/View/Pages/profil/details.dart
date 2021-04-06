import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pts/Model/pts_components.dart';

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
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: CupertinoButton(
          child: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          CupertinoButton(
            onPressed: () {},
            child: Text(
              "Modifier",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              ContainerShadow(
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
                                  "FullName",
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
                                    "A rejoint en 2021",
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
              ContainerShadow(),
            ],
          ),
        ),
      ),
    );
  }
}

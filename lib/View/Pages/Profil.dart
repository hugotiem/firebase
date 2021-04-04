import 'package:flutter/material.dart';
import 'package:pts/Model/pts_components.dart';

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
          child: Column(
            children: <Widget>[
              new ContainerShadow(
                child: Row(
                  children: <Widget>[
                    new Container(
                      height: 60,
                      width: 60,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                          'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: new Column(
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
                    ),
                  ],
                ),
              ),
              new ContainerShadow(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("Paramètres du compte"),
                    new Container(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.withOpacity(0.23)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            "Informations personnelles",
                            style: TextStyle(fontSize: 20),
                          ),
                          new Icon(Icons.perm_identity)
                        ],
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.withOpacity(0.23)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            "Paiements",
                            style: TextStyle(fontSize: 20),
                          ),
                          new Icon(Icons.payment)
                        ],
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.withOpacity(0.23)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            "Notifications",
                            style: TextStyle(fontSize: 20),
                          ),
                          new Icon(Icons.notifications_outlined)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Model/pts_components.dart';
import 'package:pts/View/Pages/profil/details.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar pour eviter certains bug d'affichage avec le haut de l'écran
      // a mettre seulement durant le scroll
      // appBar: new AppBar(
      //   toolbarHeight: 0,
      //   backgroundColor: Colors.white,
      // ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              ClickableContainer(
                to: ProfilDetails(),
                containerShadow: true,
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
                        'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                      ),
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
                          Opacity(
                            opacity: 0.7,
                            child: new Text("Afficher le profil"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              new ContainerShadow(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                // creer une list avec tous les elements
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20, bottom: 10),
                      child: new Text("Paramètres du compte"),
                    ),
                    ClickableContainer(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                        left: 20,
                        right: 20,
                      ),
                      child: new Container(
                        padding: EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.23),
                            ),
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
                    ),
                    ClickableContainer(
                      padding: EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                        left: 20,
                        right: 20,
                      ),
                      child: new Container(
                        padding: EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.23),
                            ),
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
                    ),
                    ClickableContainer(
                      padding: EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                        left: 20,
                        right: 20,
                      ),
                      child: new Container(
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.23),
                            ),
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
                    ),
                  ],
                ),
              ),
              ClickableContainer(
                containerShadow: true,
                child: Text(
                  "Se deconnecter",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

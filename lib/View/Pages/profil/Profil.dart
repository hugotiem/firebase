import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/ProfilPhoto.dart';
import 'package:pts/Model/components/pts_box.dart';
import 'package:pts/Model/components/text_materials.dart';
import 'package:pts/Model/pts_components.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/View/Pages/creation/firstpage.dart';
import 'package:pts/View/Pages/creation/test%200/firstpage.dart';
import 'package:pts/View/Pages/creation/test%201/firstpagetest1.dart';

import 'package:pts/View/Pages/login/login.dart';
import 'package:pts/View/Pages/profil/details.dart';
import 'package:pts/View/Pages/tests/api.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  //FireAuth

  @override
  void initState() {
    AuthService.auth.authStateChanges().listen((user) {
      setState(() {
        AuthService.logged = user != null;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar pour eviter certains bug d'affichage avec le haut de l'écran
      // a mettre seulement durant le scroll
      appBar: new AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: PRIMARY_COLOR,
        brightness: Brightness.light,
      ),
      backgroundColor: PRIMARY_COLOR,
      body: AuthService.isLogged
          ? Container(
              color: PRIMARY_COLOR,
              child: Center(
                child: Column(
                  children: <Widget>[
                    ClickableContainer(
                      to: ProfilDetails(),
                      containerShadow: true,
                      child: Row(
                        children: <Widget>[
                          ProfilPhoto(),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new BoldText(
                                    text: AuthService
                                                .auth.currentUser.displayName !=
                                            null
                                        ? AuthService
                                            .auth.currentUser.displayName
                                            .split(" ")[0]
                                        : ""),
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
                    PTSBox(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      // creer une list avec tous les elements
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 20, bottom: 10),
                            child: BoldText(
                              text: "Paramètres du compte",
                              fontSize: 15,
                            ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            to: API(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                          ClickableContainer(
                            to: FirstPage(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                    "création test 0",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  new Icon(Icons.add)
                                ],
                              ),
                            ),
                          ),
                          ClickableContainer(
                            to: FirsPageTest1(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                    "création test 1",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  new Icon(Icons.add)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await AuthService.auth.signOut();
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Se deconnecter",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                              ),
                            ),
                            Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "Vous n'etes pas connecté",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: ICONCOLOR,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: BoldText(
                          text: "Se connecter",
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

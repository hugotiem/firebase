import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/ProfilPhoto.dart';
import 'package:pts/Model/components/pts_box.dart';
import 'package:pts/Model/components/text_materials.dart';
import 'package:pts/Model/pts_components.dart';
import 'package:pts/Model/services/auth_service.dart';

import 'package:pts/View/Pages/login/login.dart';
import 'package:pts/View/Pages/profil/details.dart';
import 'package:pts/View/Pages/profil/info_screen.dart';

import 'list_of_party.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  var _user = AuthService.currentUser;

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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: PRIMARY_COLOR,
      body: StreamBuilder<User>(
          stream: AuthService.auth.userChanges(),
          builder: (context, snapshot) {
            if (!AuthService.isLogged) {
              return SafeArea(
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
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Login(),
                            isScrollControlled: true,
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
              );
            }

            if (snapshot.hasData) {
              _user = snapshot.data;
            }

            return SingleChildScrollView(
              child: Container(
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
                                  BoldText(
                                      text: _user.displayName != null
                                          ? _user.displayName.split(" ")[0]
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 20, bottom: 10),
                                  child: BoldText(
                                    text: 'Activités',
                                    fontSize: 15,
                                  )),
                              ClickableContainer(
                                to: GetPartyData(),
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.only(
                                  top: 0,
                                  bottom: 0,
                                  left: 20,
                                  right: 20,
                                ),
                                child: Container(
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
                                      Text(
                                        "Vos soirées",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Icon(Icons.calendar_today_outlined)
                                    ],
                                  ),
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
                                child: Container(
                                  padding: EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Messagerie",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Icon(Icons.message_outlined)
                                    ],
                                  ),
                                ),
                              )
                            ]),
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
                              to: InfoScreen(),
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
              ),
            );
          }),
    );
  }
}

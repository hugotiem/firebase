import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/Constant.dart';
import 'package:pts/View/Pages/login/login.dart';
import 'package:pts/components/ProfilPhoto.dart';
import 'package:pts/components/pts_box.dart';
import 'package:pts/components/text_materials.dart';
import 'package:pts/components/pts_components.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/View/Pages/profil/info_screen.dart';
import 'package:pts/view/pages/profil/subpage/list_user_party_page.dart';

import 'package:pts/view/pages/profil/subpage/user_page.dart';
import 'package:pts/view/pages/profil/subpage/waitlist_guest_page.dart';
import 'package:pts/view/pages/profil/subpage/waitlist_party_page.dart';


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
                            TitleTextProfil(
                              text: 'Activités',
                            ),
                            CickableContainerProfil(
                              to: GetPartyData(),
                              text:  "Vos soirées",
                              icon: Icons.calendar_today_outlined,
                            ),
                            CickableContainerProfil(
                              text:  "Messagerie",
                              icon: Icons.message_outlined,
                              bottomBorder: false,
                            ),
                          ]
                        ),
                      ),
                      PTSBox(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(  
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleTextProfil(
                              text: "Listes d'attente",
                            ),
                            CickableContainerProfil(
                              to: PartyWaitList(),
                              text: "Soirées",
                              icon: Icons.calendar_today_outlined,
                            ),
                            CickableContainerProfil( 
                              to: GuestWaitList(),
                              text: 'Invités',
                              icon: Icons.perm_identity_outlined,
                              bottomBorder: false,
                            )
                          ],
                        ),
                      ),
                      PTSBox(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        // creer une list avec tous les elements
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TitleTextProfil(
                              text: 'Paramètres du compte',
                            ),
                            CickableContainerProfil(
                              to: InfoScreen(),
                              text: "Informations personnelles",
                              icon: Icons.perm_identity_outlined,
                            ),
                            CickableContainerProfil( 
                              text: "Paiements",
                              icon: Icons.payment_outlined,
                            ),
                            CickableContainerProfil(  
                              text: "Notifications",
                              icon: Icons.notifications_outlined,
                              bottomBorder: false,
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


class CickableContainerProfil extends StatelessWidget {
  final Widget to;
  final bool bottomBorder;
  final String text;
  final IconData icon;

  const CickableContainerProfil({ 
    this.to,
    this.bottomBorder = true,
    this.text,
    this.icon,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClickableContainer(
      to: this.to,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(  
        padding: EdgeInsets.only(top: 15, bottom: 15),
        decoration: this.bottomBorder == true 
        ? BoxDecoration(
            border: Border(  
              bottom: BorderSide(  
                color: Colors.grey.withOpacity(0.23)
              )
            )
          )
        : null,
        child: Row(  
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              this.text,
              style: TextStyle(
                fontSize: 20
              ),
            ),
            Icon(
              this.icon
            )
          ],
        ),
      ),
    );
  }
}


class TitleTextProfil extends StatelessWidget {
  final String text;

  const TitleTextProfil({ 
    this.text,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 10),
      child: BoldText( 
        text: this.text,
        fontSize: 15,
      ),
    );
  }
}
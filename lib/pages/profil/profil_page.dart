import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/components/connect.dart';
import 'package:pts/const.dart';
import 'package:pts/pages/login/id_form_screen.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/ProfilPhoto.dart';
import 'package:pts/components/pts_box.dart';
import 'package:pts/components/text_materials.dart';
import 'package:pts/components/pts_components.dart';
import 'package:pts/models/services/auth_service.dart';
import 'package:pts/models/services/notification_service.dart';
import 'package:pts/pages/profil/subpage/existingcard_page.dart';
import 'package:pts/pages/profil/subpage/list_user_party_page.dart';
import 'package:pts/pages/profil/subpage/user_page.dart';

import 'package:pts/pages/profil/subpage/waitlist_guest_page.dart';
import 'package:pts/pages/profil/subpage/waitlist_party_page.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  AuthService service = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar pour eviter certains bug d'affichage avec le haut de l'écran
      // a mettre seulement durant le scroll
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: PRIMARY_COLOR,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: PRIMARY_COLOR,
      body: BlocProvider(
        create: (context) => UserCubit()..init(),
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            var isLogged = state.token != null;

            if (!isLogged) {
              return Connect(context);
            }

            var user = state.user;
            if (user == null) {
              return Center(child: CircularProgressIndicator());
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
                                  BoldText(text: user.name ?? ""),
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
                              text: "Vos soirées",
                              icon: Ionicons.calendar_clear_outline,
                              bottomBorder: false,
                            ),
                          ],
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
                              icon: Ionicons.calendar_clear_outline,
                            ),
                            CickableContainerProfil(
                              to: GuestWaitList(),
                              text: 'Invités',
                              icon: Ionicons.person_outline,
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
                              to: IdFormScreen(),
                              text: "Informations personnelles",
                              icon: Ionicons.person_outline,
                            ),
                            CickableContainerProfil(
                              to: ExistingCard(),
                              text: "Paiements",
                              icon: Ionicons.card_outline,
                            ),
                            CickableContainerProfil(
                              to: NotificationPage(),
                              text: "Notifications",
                              icon: Ionicons.notifications_outline,
                              bottomBorder: false,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await service.setToken(null);
                          await service.instance.signOut();
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
                                Ionicons.exit_outline,
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
          },
        ),
      ),
    );
  }
}

class CickableContainerProfil extends StatelessWidget {
  final Widget? to;
  final bool bottomBorder;
  final String? text;
  final IconData? icon;

  const CickableContainerProfil(
      {this.to, this.bottomBorder = true, this.text, this.icon, Key? key})
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
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.23))))
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              this.text!,
              style: TextStyle(fontSize: 20),
            ),
            Icon(this.icon)
          ],
        ),
      ),
    );
  }
}

class TitleTextProfil extends StatelessWidget {
  final String? text;

  const TitleTextProfil({this.text, Key? key}) : super(key: key);

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

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (Center(
        child: TextButton(
          onPressed: () => Timer(
            const Duration(seconds: 10),
            () => NotificationService.showNotification(
                body: 'Vous avez été accepté à la soirée du roi.',
                title: 'PTS',
                payload: 'test'),
          ),
          child: Text('Notification'),
        ),
      )),
    );
  }
}

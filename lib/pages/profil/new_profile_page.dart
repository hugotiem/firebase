import 'package:flutter/services.dart';
import 'package:pts/components/party_card/party_export.dart';
import 'package:pts/pages/profil/subpage/about_page.dart';
import 'package:pts/pages/profil/subpage/existing_cards_page.dart';
import 'package:pts/pages/profil/subpage/new_user_page.dart';
import 'package:pts/pages/profil/subpage/notification_page.dart';
import 'package:pts/services/auth_service.dart';

import 'subpage/contactus_page.dart';
import 'subpage/info_page.dart';
import 'subpage/qr_code_page.dart';

class NewProfilePage extends StatefulWidget {
  const NewProfilePage({Key? key}) : super(key: key);

  @override
  State<NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  double _radius = 120;
  final AuthService service = AuthService();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: BlocProvider(
        create: (context) => UserCubit()..init(),
        child: BlocBuilder<UserCubit, UserState>(builder: (context, userstate) {
          User? user = userstate.user;
          if (user == null)
            return Center(
              child: CircularProgressIndicator(),
            );

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels < 0) {
                setState(() {
                  _radius = 120;
                });
              } else if (notification.metrics.pixels > 80) {
                setState(() {
                  _radius = 120 - 80;
                });
              } else if (notification.metrics.pixels < 80) {
                setState(() {
                  _radius = 120 - notification.metrics.pixels;
                });
              }
              return true;
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR]),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.05,
                      left: width * 0.05,
                    ),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Image(
                        image: AssetImage("assets/RETOUR.png"),
                        alignment: Alignment.topLeft,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    height: height * 0.88,
                    width: width,
                    decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: "user ",
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 22, right: 28, left: 28),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: PRIMARY_COLOR,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height * 0.2,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  user.name!,
                                                  style: TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.w800,
                                                    color: SECONDARY_COLOR,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Icon(
                                                    (user.verified ?? false)
                                                      ? Icons.verified_sharp : Icons.close_outlined,
                                                      color: user.verified?? false ? ICONCOLOR : Colors.red),
                                                )
                                              ],
                                            ),
                                            InkWell(
                                              onTap: () => Navigator.push(
                                                  // .push(_route()),
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewUserPage())),
                                              child: const Opacity(
                                                opacity: 0.7,
                                                child: Text(
                                                  "Afficher le profil",
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              ),
                                            ),
                                            BlocProvider(
                                              create: ((context) => PartiesCubit()
                                                ..fetchPartiesWithWhereIsEqualTo(
                                                    "ownerId", user.id)),
                                              child: BlocBuilder<PartiesCubit,
                                                      PartiesState>(
                                                  builder: (context,
                                                      partyownerstate) {
                                                if (partyownerstate.parties ==
                                                    null)
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                int i = 0;
                                                int count = 0;

                                                if (partyownerstate.parties !=
                                                    null) {
                                                  // ignore: unused_local_variable
                                                  for (var test
                                                      in partyownerstate
                                                          .parties!) {
                                                    if (partyownerstate
                                                        .parties![i]
                                                        .commentIdList!
                                                        .isNotEmpty) {
                                                      setState(() {
                                                        count += partyownerstate
                                                            .parties![i]
                                                            .commentIdList!
                                                            .length;
                                                      });
                                                    }
                                                    i++;
                                                  }
                                                } else
                                                  count = 0;
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 30, bottom: 30),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Info(
                                                          count.toString(),
                                                          hintInfo: "Avis",
                                                        ),
                                                        Info(
                                                          partyownerstate.parties!.length.toString(),
                                                          hintInfo:
                                                              "Soirée organisées",
                                                        ),
                                                        BlocProvider(
                                                          create: (context) => PartiesCubit()..fetchPartiesWithWhereIsEqualTo("validatedList", user.id),
                                                          child: BlocBuilder<PartiesCubit, PartiesState>(
                                                            builder: (context, joinpartystate) {
                                                              if (joinpartystate.parties == null) 
                                                                return Center(child: CircularProgressIndicator(),);
                                                              return Info(
                                                                joinpartystate.parties!.length.toString(),
                                                                hintInfo:
                                                                    "Participations",
                                                              );
                                                            }
                                                          ),
                                                        )
                                                      ]),
                                                );
                                              }),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 28, top: 28, bottom: 14),
                              child: Text(
                                "PARAMÈTRES DU COMPTE",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                            SettingContainer(
                                text: "Informations personnelles",
                                icon: Ionicons.person_outline,
                                to: InformationPage(user)),
                            SettingContainer(
                                text: "Paiements",
                                icon: Ionicons.card_outline,
                                to: ExistingCard(user: user)),
                            SettingContainer(
                                text: "Notifications",
                                icon: Ionicons.notifications_outline,
                                to: NotificationPage()),
                            SettingContainer(
                                text: "À propos",
                                icon: Ionicons.information_circle_outline,
                                to: AboutPage()),
                            SettingContainer(
                                text: "Nous contacter",
                                icon: Ionicons.mail_outline,
                                to: ContactUsPage()),
                            SettingContainer(
                                text: "QR code",
                                icon: Ionicons.qr_code_outline,
                                to: QrCodePage()),
                            GestureDetector(
                              onTap: () async {
                                await service.setToken(null);
                                await service.instance.signOut();
                              },
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 22),
                                  child: Text(
                                    "Se déconnecter",
                                    style: TextStyle(
                                      color: Colors.red,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: height * 0.05),
                    child: ProfilePhoto(
                      "",
                      radius: _radius,
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

class Info extends StatelessWidget {
  final String info;
  final String hintInfo;
  const Info(this.info, {required this.hintInfo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            decoration: BoxDecoration(
              color: PRIMARY_COLOR,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              info,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: SECONDARY_COLOR,
              ),
            ),
          ),
        ),
        if (hintInfo.contains(" "))
          Opacity(
            opacity: 0.7,
            child: Column(
              children: [
                Text(
                  hintInfo.split(" ")[0],
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  hintInfo.split(" ")[1],
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          )
        else
          Opacity(
            opacity: 0.7,
            child: Text(
              hintInfo,
              style: TextStyle(fontSize: 12),
            ),
          )
      ],
    );
  }
}

class SettingContainer extends StatelessWidget {
  final String text;
  final IconData icon;
  final Widget to;
  const SettingContainer(
      {required this.icon, required this.text, required this.to, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => to)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: PRIMARY_COLOR,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 6,
                spreadRadius: 0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Icon(icon)
            ],
          ),
        ),
      ),
    );
  }
}

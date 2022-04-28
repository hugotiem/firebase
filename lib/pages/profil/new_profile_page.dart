import 'package:pts/components/party_card/party_export.dart';

class NewProfilePage extends StatelessWidget {
  const NewProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR]),
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
              height: height * 0.88,
              width: width,
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 22, right: 28, left: 28),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Jean",
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w800,
                                          color: SECONDARY_COLOR,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Icon(Icons.verified_user_sharp,
                                            color: ICONCOLOR, size: 32),
                                      )
                                    ],
                                  ),
                                  const Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      "Afficher le profil",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, bottom: 30),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Info(
                                            "164",
                                            hintInfo: "Avis",
                                          ),
                                          const Info(
                                            "12",
                                            hintInfo: "Soirée organisées",
                                          ),
                                          const Info(
                                            "28",
                                            hintInfo: "Participations",
                                          )
                                        ]),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 28, top: 28, bottom: 14),
                      child: Text(
                        "PARAMÈTRES DU COMPTE",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SettingContainer(
                        text: "Informations personnelles",
                        icon: Ionicons.person_outline),
                    SettingContainer(
                        text: "Paiements", icon: Ionicons.card_outline),
                    SettingContainer(
                        text: "Notifications",
                        icon: Ionicons.notifications_outline),
                    SettingContainer(
                        text: "À propos",
                        icon: Ionicons.information_circle_outline),
                    SettingContainer(
                        text: "Nous contacter", icon: Ionicons.mail_outline),
                    SettingContainer(
                        text: "QR code", icon: Ionicons.qr_code_outline),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        child: Text(
                          "Se déconnecter",
                          style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                radius: 120,
              ),
            ),
          )
        ],
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
  const SettingContainer({required this.icon, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
    );
  }
}

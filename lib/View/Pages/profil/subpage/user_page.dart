import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pts/Constant.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/Constant.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadProfil(
              fullName: 'Jean Sauvage',
              age: '21',
              photo: "assets/roundBlankProfilPicture.png",
              identiteVerif: 'Identité vérifiée',
              avis: '0',
            ),
          ],
        ),
      ),
    );
  }
}

class HeadProfil extends StatelessWidget {
  final String? fullName;
  final String? age;
  final String? photo;
  final String? identiteVerif;
  final String? avis;

  const HeadProfil({this.fullName, this.age, this.photo, this.avis, this.identiteVerif, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(photo!),
            ),
          ),
        ),
        Text(
          fullName!,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: SECONDARY_COLOR,
              fontSize: 22),
        ),
        Opacity(
          opacity: 0.65,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              '$age ans',
              style: TextStyle(color: SECONDARY_COLOR, fontSize: 16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 15),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Icon(Icons.star, color: ICONCOLOR),
              ),
              Text('$avis avis',
                  style: TextStyle(
                    fontSize: 16,
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.w100,
                  ))
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Icon(Icons.verified_user_sharp, color: ICONCOLOR),
            ),
            Text(identiteVerif!,
                style: TextStyle(
                  fontSize: 16,
                  color: SECONDARY_COLOR,
                  fontWeight: FontWeight.w100,
                ))
          ],
        ),
      ],
    );
  }
}

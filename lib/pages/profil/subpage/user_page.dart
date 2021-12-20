import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/const.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/horizontal_separator.dart';

class ProfilDetails extends StatelessWidget {
  const ProfilDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          actions: <Widget>[
            CupertinoButton(
              onPressed: () => modify(context),
              child: Text(
                "Modifier",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: SECONDARY_COLOR,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeadProfil(
                fullName: 'Jean Sauvage',
                age: '21',
                photo: "assets/roundBlankProfilPicture.png",
                identiteVerif: 'Identité vérifiée',
                avis: '0',
              ),
              HorzontalSeparator(),
              Histoty(
                soireeOrganisee: "0",
                soireeParticipee: "0",
              ),
              HorzontalSeparator(),
              Comment(),
            ],
          ),
        ),
      ),
    );
  }

  Future modify(BuildContext context) async {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) => Modify());
  }
}

class HeadProfil extends StatelessWidget {
  final String? fullName;
  final String? age;
  final String? photo;
  final String? identiteVerif;
  final String? avis;

  const HeadProfil(
      {this.fullName,
      this.age,
      this.photo,
      this.avis,
      this.identiteVerif,
      Key? key})
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
                child: Icon(Ionicons.star, color: ICONCOLOR),
              ),
              Text(
                '$avis avis',
                style: TextStyle(
                  fontSize: 16,
                  color: SECONDARY_COLOR,
                  fontWeight: FontWeight.w100,
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Icon(Icons.verified_user_sharp, color: ICONCOLOR),
            ),
            Text(
              identiteVerif!,
              style: TextStyle(
                fontSize: 16,
                color: SECONDARY_COLOR,
                fontWeight: FontWeight.w100,
              ),
            )
          ],
        ),
      ],
    );
  }
}

class Histoty extends StatelessWidget {
  final String? soireeOrganisee;
  final String? soireeParticipee;

  const Histoty({this.soireeOrganisee, this.soireeParticipee, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(
                'Historique',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: SECONDARY_COLOR),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(bottom: 15, top: 40),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Icon(Ionicons.home, color: ICONCOLOR),
              ),
              Text(
                '$soireeOrganisee soirée organisé',
                style: TextStyle(
                  fontSize: 16,
                  color: SECONDARY_COLOR,
                  fontWeight: FontWeight.w100,
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Icon(Ionicons.people, color: ICONCOLOR),
            ),
            Text(
              '$soireeParticipee soirée participé',
              style: TextStyle(
                fontSize: 16,
                color: SECONDARY_COLOR,
                fontWeight: FontWeight.w100,
              ),
            )
          ],
        ),
      ],
    );
  }
}

class Comment extends StatelessWidget {
  const Comment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Commentaire',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: SECONDARY_COLOR),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Opacity(
                  opacity: 0.65,
                  child: Text(
                    "Vous n'avez pas encore de commentaires",
                    style: TextStyle(color: SECONDARY_COLOR, fontSize: 16),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class Modify extends StatelessWidget {
  const Modify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: BackAppBar(
            leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  color: ICONCOLOR,
                )),
            actions: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Enregistrer',
                  style: TextStyle(color: SECONDARY_COLOR, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

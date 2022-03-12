import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/profile_photo.dart';
import 'package:pts/const.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/horizontal_separator.dart';
import 'package:pts/models/Capitalize.dart';
import 'package:path/path.Dart' as Path;
import 'package:pts/services/auth_service.dart';
import 'package:pts/services/storage_service.dart';

class ProfilDetails extends StatefulWidget {
  const ProfilDetails({Key? key}) : super(key: key);

  @override
  State<ProfilDetails> createState() => _ProfilDetailsState();
}

class _ProfilDetailsState extends State<ProfilDetails> {
  File? image;

  @override
  Widget build(BuildContext context) {
    registerPhotoInFirebase(String photo) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String userID = AuthService().currentUser!.uid;

      try {
        firestore.collection('user').doc(userID).update({"photo": photo});
      } catch (e) {
        print(e.toString());
      }
    }

    Future registerPhoto() async {
      String fileName = Path.basename(image!.path);
      String destination = "UserPhoto/$fileName";
      UploadTask task = StorageService(destination).uploadFile(image!);

      task.then((element) async {
        var url = await element.ref.getDownloadURL();
        registerPhotoInFirebase(url);
      });

      Navigator.pop(context);
    }

    Future photoSelected() async {
      return showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(80),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: BackAppBar(actions: [
                    TextButton(
                      onPressed: () => registerPhoto(),
                      child: Text(
                        'Enregistrer',
                        style: TextStyle(color: SECONDARY_COLOR, fontSize: 16),
                      ),
                    ),
                  ]),
                ),
              ),
              body: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Container(
                    child: Image.file(image!),
                  ),
                ),
              ),
            );
          });
    }

    Future pickImage() async {
      try {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) return;

        final imageTemporary = File(image.path);
        setState(() => this.image = imageTemporary);

        Navigator.pop(context);
        photoSelected();
      } on PlatformException catch (e) {
        print('failed to pick image: $e');
      }
    }

    Future takePhoto() async {
      try {
        final image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (image == null) return;

        final imageTemporary = File(image.path);
        setState(() => this.image = imageTemporary);

        Navigator.pop(context);
        photoSelected();
      } on PlatformException catch (e) {
        print('failed to pick image: $e');
      }
    }

    Future<void> pickDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Prendre une photo'),
            content: Text(
                'Prenez une nouvelle photo ou importez-en une depuis votre bibliothèque.'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => pickImage(),
                  child: Text('GALERIE',
                      style: TextStyle(color: SECONDARY_COLOR))),
              TextButton(
                  onPressed: () => takePhoto(),
                  child: Text(
                    'APPAREIL',
                    style: TextStyle(color: SECONDARY_COLOR),
                  ))
            ],
          );
        },
      );
    }

    Future showPhoto(String photo) async {
      return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BackAppBar(
                  actions: [
                    TextButton(
                      onPressed: () => pickDialog(),
                      child: Text(
                        'Modifier',
                        style: TextStyle(
                          color: SECONDARY_COLOR,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Container(
                  child: photo == "assets/roundBlankProfilPicture.png"
                      ? Image.asset(photo)
                      : Image.network(photo, fit: BoxFit.cover),
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      body: BlocProvider(
        create: (context) => UserCubit()..init(),
        child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          var user = state.user;

          if (user == null)
            return Center(
              child: CircularProgressIndicator(),
            );

          String? photo = "";
          if (user.photo!.isEmpty) {
            photo = "assets/roundBlankProfilPicture.png";
          } else {
            photo = user.photo;
          }

          return BlocProvider(
            create: (context) => PartiesCubit()
              ..fetchPartiesWithWhereIsEqualTo("party owner", user.id),
            child: BlocBuilder<PartiesCubit, PartiesState>(
              builder: (context, partyStateOwner) {
                if (partyStateOwner.parties == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return BlocProvider(
                  create: (context) => PartiesCubit()
                    ..fetchPartiesWithWhereArrayContains(
                        "validatedList", user.id),
                  child: BlocBuilder<PartiesCubit, PartiesState>(
                    builder: (context, partyStateJoin) {
                      if (partyStateJoin.parties == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              HeadProfil(
                                fullName:
                                    '${user.name} ${user.surname.toString().inCaps}',
                                age: user.age.toString(),
                                photo: user.photo,
                                onTap: () => showPhoto(photo!),
                                identiteVerif: user.verified,
                                avis: '0',
                              ),
                              HorzontalSeparator(),
                              Histoty(
                                soireeOrganisee:
                                    partyStateOwner.parties!.length.toString(),
                                soireeParticipee:
                                    partyStateJoin.parties!.length.toString(),
                              ),
                              HorzontalSeparator(),
                              Comment(),
                              SizedBox(height: 50)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class HeadProfil extends StatelessWidget {
  final String? fullName;
  final String? age;
  final String? photo;
  final bool? identiteVerif;
  final String? avis;
  final void Function()? onTap;

  const HeadProfil(
      {this.fullName,
      this.age,
      this.photo,
      this.avis,
      this.identiteVerif,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: ProfilePhoto(
                  photo,
                  radius: 70,
                )),
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
              child: Icon(
                  identiteVerif! == true
                      ? Icons.verified_user_sharp
                      : Icons.close_outlined,
                  color: identiteVerif! == true ? ICONCOLOR : Colors.red),
            ),
            Text(
              identiteVerif! == true
                  ? "Profil vérifiée"
                  : "Profil non vérifiée",
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

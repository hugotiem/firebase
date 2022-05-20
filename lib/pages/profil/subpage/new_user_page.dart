import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.Dart' as Path;
import 'package:pts/components/party_card/party_export.dart';
import 'package:pts/services/storage_service.dart';

import '../../../services/auth_service.dart';

class NewUserPage extends StatefulWidget {
  final User? user;
  const NewUserPage(this.user, {Key? key}) : super(key: key);

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  File? image;
  String photo = "";

  @override
  Widget build(BuildContext context) {
    if (widget.user!.photo!.isEmpty) 
      photo = "assets/roundBlankProfilPicture.png";
    else 
      photo = widget.user!.photo!;
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
                    Hero(
                      tag: "user",
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
                                          widget.user!.name ?? "",
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w800,
                                            color: SECONDARY_COLOR,
                                          ),
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Icon(
                                                widget.user!.verified!
                                                    ? Icons.verified_sharp
                                                    : Icons.close_outlined,
                                                color: widget.user!.verified!
                                                    ? ICONCOLOR
                                                    : Colors.red))
                                      ],
                                    ),
                                    Text(
                                      "${widget.user!.age.toString()} ans",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    InkWell(
                                      onTap: () => showPhoto(photo),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 6, bottom: 16),
                                        child: const Opacity(
                                          opacity: 0.7,
                                          child: Text(
                                            "Modifier la photo de profil",
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    BlocProvider(
                        create: (context) => PartiesCubit()
                          ..fetchPartiesWithWhereIsEqualTo("ownerId", widget.user!.id),
                        child: BlocBuilder<PartiesCubit, PartiesState>(
                            builder: (context, partyownerstate) {
                          if (partyownerstate.parties == null)
                            return Center(child: CircularProgressIndicator());
                          return Commment(partyownerstate.parties);
                        })),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.user!.verified!
                                ? Icons.verified_sharp
                                : Icons.close_outlined,
                            color: SECONDARY_COLOR,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              widget.user!.verified!
                                  ? "Identité vérifiée"
                                  : "Identité non verifiée",
                              style: TextStyle(
                                  color: SECONDARY_COLOR, fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 12),
                      child: Text(
                        "À propos de moi",
                        style: TextStyle(
                            color: SECONDARY_COLOR,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w500),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => PartiesCubit()
                        ..fetchPartiesWithWhereIsEqualTo("ownerId", widget.user!.id),
                      child: BlocBuilder<PartiesCubit, PartiesState>(
                          builder: (context, partyownerstate) {
                        if (partyownerstate.parties == null)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        return Padding(
                          padding: const EdgeInsets.only(top: 28),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                partyownerstate.parties!.length.toString(),
                                style: TextStyle(
                                    color: ICONCOLOR,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  "Soirées organisées",
                                  style:
                                      TextStyle(color: ICONCOLOR, fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                    BlocProvider(
                      create: (context) => PartiesCubit()
                        ..fetchPartiesWithWhereIsEqualTo(
                            "validatedList", widget.user!.id),
                      child: BlocBuilder<PartiesCubit, PartiesState>(
                          builder: (context, joinpartystate) {
                        if (joinpartystate.parties == null)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        return Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                joinpartystate.parties!.length.toString(),
                                style: TextStyle(
                                    color: ICONCOLOR,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  "Participations",
                                  style:
                                      TextStyle(color: ICONCOLOR, fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
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
                photo,
                radius: 120,
              ),
            ),
          )
        ],
      ),
    );
  }
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
}

class Commment extends StatefulWidget {
  final List<Party>? party;
  const Commment(this.party, {Key? key}) : super(key: key);

  @override
  State<Commment> createState() => _CommmentState();
}

class _CommmentState extends State<Commment> {
  late Map comment;
  late List commentListId;
  List list = [];
  List list1 = [];
  int countComment = 0;
  double countNote = 0;
  bool showComment = false;

  @override
  void initState() {
    super.initState();

    for (Party party in widget.party!) {
      if (party.commentIdList!.isNotEmpty) {
        countComment += party.commentIdList!.length;
      }
    }

    double _counter = 0;

    for (Party party in widget.party!) {
      if (party.commentIdList!.isNotEmpty) {
        List nameList = party.commentIdList!;
        nameList.map((doc) {
          Map info = party.comment![doc];
          _counter += double.parse(info["note"].toString());
        }).toList();
      }
    }
    countNote = _counter;
    countNote /= countComment;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: InkWell(
        onTap: () {
          setState(() {
            if (showComment)
              showComment = false;
            else
              showComment = true;
          });
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 6,
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                ),
              ], color: PRIMARY_COLOR, borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Ionicons.star_outline, color: SECONDARY_COLOR),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          countNote.isNaN
                              ? "$countComment avis"
                              : "${countNote.toStringAsFixed(1)}/5 - $countComment avis",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  AnimatedRotation(
                    turns: showComment ? 1.25 : 1,
                    duration: Duration(milliseconds: 300),
                    child: Icon(Ionicons.play_outline),
                  ),
                ],
              ),
            ),
            if (showComment)
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.party!.length,
                itemBuilder: (BuildContext context, int index) {
                  commentListId = widget.party![index].commentIdList ?? [];
                  list = commentListId.map((doc) {
                    comment = widget.party![index].comment![doc];
                    String date =
                        widget.party![index].startTime.toString().split(" ")[0];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: PRIMARY_COLOR,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 6,
                              spreadRadius: 0,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfilePhoto(comment["photo"], radius: 40),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment["name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 22),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4, bottom: 8),
                                      child: Text(
                                          "Soirée du ${date.split("-")[2]}.${date.split("-")[1]}.${date.split("-")[0]}"),
                                    ),
                                    Text(comment["comment"])
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList();
                  return Column(
                    children: list as List<Widget>,
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}

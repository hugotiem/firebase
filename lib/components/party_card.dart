import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/components/custom_container.dart';
import 'package:pts/components/profile_photo.dart';
import 'package:pts/models/capitalize.dart';
import 'package:pts/models/party.dart';
import 'package:pts/models/user.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/models/services/auth_service.dart';
import 'package:pts/pages/messaging/subpage/chatpage.dart';
import 'package:pts/pages/profil/subpage/existingcard_page.dart';
import 'package:pts/pages/search/sliver/custom_sliver.dart';
import 'package:pts/const.dart';
import 'custom_text.dart';
import 'horizontal_separator.dart';
import 'piechart.dart';

Widget buildPartyCard(BuildContext context, Party party) {
  List nameList = party.validateGuestList!;

  List list = nameList.map((doc) {
    return BlocProvider(
      create: (context) => UserCubit()..loadDataByUserID(doc['uid']),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state.user == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User? user = state.user;
          return Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CText(
                          "${user!.name!.inCaps} ${user.surname!.inCaps}",
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: SECONDARY_COLOR,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Opacity(
                            opacity: 0.7,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(Ionicons.star, color: ICONCOLOR),
                                ),
                                CText(
                                  '4.9 / 5 - 0 avis',
                                  fontSize: 16,
                                  color: SECONDARY_COLOR,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ProfilePhoto(user.photo, radius: 25),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 2, color: FOCUS_COLOR),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }).toList();

  String? image;
  Color? color;
  Color? textColor;

  if (party.theme == 'Festive') {
    image = "assets/festive.jpg";
    color = ICONCOLOR;
    textColor = SECONDARY_COLOR;
  } else if (party.theme == "Gaming") {
    image = "assets/gaming.jpg";
    color = ICONCOLOR;
    textColor = SECONDARY_COLOR;
  } else if (party.theme == "Jeux de société") {
    image = "assets/jeuxdesociete.jpg";
    color = SECONDARY_COLOR;
    textColor = PRIMARY_COLOR;
  } else if (party.theme == "Thème") {
    image = "assets/theme.jpg";
    color = SECONDARY_COLOR;
    textColor = PRIMARY_COLOR;
  }

  void contacter(String? ownerName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var chatCollection = firestore.collection('chat');
    var currentUserID = AuthService().currentUser!.uid;
    var currentUserName = AuthService().currentUser!.displayName;
    var otherUserUID = party.ownerId;
    List currentUIDList = [];
    List otherUIDList = [];
    List emptyList = [];

    currentUIDList.add({'uid': currentUserID, 'name': currentUserName});
    otherUIDList.add({'uid': party.ownerId, 'name': ownerName});

    chatCollection.doc(party.ownerId).snapshots().listen((datasnapshot) async {
      chatCollection
          .doc(currentUserID)
          .snapshots()
          .listen((datasnapshot) async {
        if (datasnapshot.exists) {
          return;
        } else {
          await chatCollection.doc(currentUserID).set({
            'userid': FieldValue.arrayUnion(emptyList),
          });
        }
      });
      if (datasnapshot.exists) {
        await chatCollection.doc(party.ownerId).update({
          'userid': FieldValue.arrayUnion(currentUIDList),
        }).then((value) {
          chatCollection.doc(currentUserID).update({
            'userid': FieldValue.arrayUnion(otherUIDList),
          }).then((value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatPage(otherUserUID, otherUserName: ownerName)));
          });
        });
      } else {
        await chatCollection
            .doc(party.ownerId)
            .set({'userid': emptyList}).then((value) {
          chatCollection.doc(currentUserID).set({'userid': emptyList});
        });

        await chatCollection.doc(party.ownerId).update({
          'userid': FieldValue.arrayUnion(currentUIDList),
        }).then((value) {
          chatCollection.doc(currentUserID).update({
            'userid': FieldValue.arrayUnion(otherUIDList),
          }).then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChatPage(otherUserUID, otherUserName: ownerName),
              ),
            );
          });
        });
      }
    });
  }

  return BlocProvider(
    create: (context) => UserCubit()..loadDataByUserID(party.ownerId),
    child: BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state.user == null) {
          return Center(child: CircularProgressIndicator());
        }
        User? user = state.user;

        return Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Container(
                  // height: 250,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    color: PRIMARY_COLOR,
                  ),
                  child: OpenContainer(
                    closedElevation: 0,
                    transitionDuration: Duration(milliseconds: 200),
                    closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    closedColor: Colors.white,
                    openColor: Colors.white,
                    closedBuilder: (context, returnValue) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                color: color,
                                height: 180,
                                child: Image.asset(image!),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: BlurryContainer(
                                  bgColor: color == SECONDARY_COLOR
                                      ? Colors.blueGrey
                                      : Colors.yellow.shade100,
                                  child: Column(
                                    children: [
                                      Text(
                                        DateFormat.MMM('fr').format(party.date),
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          DateFormat.d('fr').format(party.date),
                                          style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 22),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CText(party.name!,
                                    fontSize: 15, fontWeight: FontWeight.w500),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 1),
                                  child: Row(
                                    children: [
                                      CText("${user!.name!} ${user.surname!}",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        user.verified == true
                                            ? Icons.verified
                                            : null,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CText(party.city!,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                    CText(
                                        party.distance != null
                                            ? "${party.distance.toString()} km"
                                            : "",
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    openBuilder: (context, returnValue) {
                      return CustomSliverCard(
                        image: image,
                        color: color,
                        name: party.name,
                        date:
                            '${DateFormat.E('fr').format(party.startTime!).inCaps} ${DateFormat.d('fr').format(party.startTime!)} ${DateFormat.MMMM('fr').format(party.startTime!)}',
                        location: party.city,
                        body: SizedBox.expand(
                          child: SingleChildScrollView(
                            child: CardBody(
                              nombre: party.number,
                              desc: party.desc != null ? party.desc : '',
                              nomOrganisateur: "${user!.name} ${user.surname}",
                              avis: '4.9 / 5 - 0 avis',
                              animal: party.animals!,
                              smoke: party.smoke!,
                              list: list,
                              nameList: nameList,
                              contacter: () => contacter(user.name),
                              photoUserProfile: user.photo,
                            ),
                          ),
                        ),
                        bottomNavigationBar: CardBNB(
                            prix: party.price.toString(),
                            heureDebut:
                                "${DateFormat.Hm('fr').format(party.startTime!).split(":")[0]}h${DateFormat.Hm('fr').format(party.startTime!).split(":")[1]}",
                            heureFin:
                                "${DateFormat.Hm('fr').format(party.endTime!).split(':')[0]}h${DateFormat.Hm('fr').format(party.endTime!).split(':')[1]}",
                            onTap: () async {
                              var token = await AuthService().getToken();

                              if (token == null) {
                                final snackBar = SnackBar(
                                  content:
                                      const CText("Vous n'êtes pas connecté"),
                                  duration: Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                if (party.price == 0) {
                                  final _db = FirebaseFirestore.instance
                                      .collection('parties')
                                      .doc(party.id);

                                  final uid = user.id;
                                  List waitList = [];

                                  waitList.add({"uid": uid});

                                  await _db.update({
                                    "wait list":
                                        FieldValue.arrayUnion(waitList),
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JoinWaitList(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExistingCard(),
                                    ),
                                  );
                                }
                              }
                            }),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

class CustomSliverCard extends StatefulWidget {
  final Widget? body, titleText, bottomNavigationBar;
  final String? name, date, location, image;
  final Color? color;

  const CustomSliverCard(
      {this.image,
      this.color,
      this.body,
      this.titleText,
      this.name,
      this.date,
      this.location,
      this.bottomNavigationBar,
      Key? key})
      : super(key: key);

  @override
  _CustomSliverCardState createState() => _CustomSliverCardState();
}

class _CustomSliverCardState extends State<CustomSliverCard> {
  double? _size, _barSizeWidth, _barSizeHeight, _borderRadius, _opacity;
  late Color _toolbarColor;
  bool? _headerName, _headerLocation, _headerDate;

  @override
  void initState() {
    setState(() {
      _size = 300;
      _toolbarColor = Colors.transparent;
      _barSizeWidth = 350;
      _barSizeHeight = 150;
      _headerName = true;
      _headerLocation = true;
      _headerDate = true;
      _borderRadius = 60;
      _opacity = 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSliver(
      backgroundColor: PRIMARY_COLOR,

      // brightness: _brightness,
      toolbarColor: _toolbarColor,
      appBar: Opacity(
        opacity: _opacity!,
        child: Container(
          height: _size,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: widget.color,
            image: DecorationImage(
              image: AssetImage(widget.image!),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
          ),
        ),
      ),
      body: widget.body!,
      searchBar: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 55, left: 22),
              child: Container(
                decoration: BoxDecoration(
                  color: PRIMARY_COLOR.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Ionicons.arrow_back_outline),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: (_size! - 80) > 50 ? _size! - 80 : 50),
              Center(
                child: Container(
                  width: _barSizeWidth,
                  height: _barSizeHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(_borderRadius!),
                          bottomRight: Radius.circular(_borderRadius!),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30))),
                  child: Container(
                    child: _headerName == true
                        ? Padding(
                            padding:
                                const EdgeInsets.only(top: 27.5, left: 27.5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: CText(
                                    widget.name,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: _headerDate == true
                                        ? Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: Icon(
                                                  Ionicons
                                                      .calendar_clear_outline,
                                                  color: SECONDARY_COLOR,
                                                ),
                                              ),
                                              CText(widget.date,
                                                  color: SECONDARY_COLOR)
                                            ],
                                          )
                                        : Container()),
                                _headerLocation == true
                                    ? Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Icon(
                                              Ionicons.location_outline,
                                              color: SECONDARY_COLOR,
                                            ),
                                          ),
                                          CText(
                                            widget.location,
                                            color: SECONDARY_COLOR,
                                          )
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                          )
                        : Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Ionicons.arrow_back_outline,
                                    color: ICONCOLOR,
                                  ),
                                ),
                              ),
                              Center(
                                child: CText(
                                  widget.name,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      onNotification: (notification) {
        setState(() {
          if (!(notification is ScrollStartNotification) &&
              notification.metrics.axis != Axis.horizontal) {
            double _pixels = notification.metrics.pixels;
            if (_pixels <= 300 && (300 - _pixels) >= 100) {
              _size = 300 - _pixels;
              _toolbarColor = Colors.transparent;
              _headerName = true;
              _headerDate = true;
              _headerLocation = true;

              _barSizeWidth = 350 + (_pixels / 5);
              _barSizeHeight = 150 - (_pixels / 2.8);

              _borderRadius = 60 - (_pixels / 7);

              if (_pixels > 61) {
                _headerLocation = false;
              }

              if (_pixels > 120) {
                _headerDate = false;
              }

              if (_pixels > 150) {
                _opacity = (_size! - 100) / 50;
              } else if (_opacity! <= 150) {
                _opacity = 1;
              }
            } else if (_pixels > 200) {
              _size = 100;
              _toolbarColor = PRIMARY_COLOR;
              _headerName = false;
            }
          }
        });

        return true;
      },
      bottomNavigationBar: widget.bottomNavigationBar!,
    );
  }
}

class CardBody extends StatelessWidget {
  final bool? animal, smoke;
  final String? desc, nomOrganisateur, avis, nombre, photoUserProfile;
  final List? nameList, list;
  final void Function()? contacter;

  const CardBody({
    Key? key,
    this.desc,
    this.nomOrganisateur,
    this.avis,
    this.animal,
    this.smoke,
    this.nameList,
    this.list,
    this.nombre,
    this.contacter,
    this.photoUserProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 420,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22, bottom: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  this.nomOrganisateur != null
                      ? CText(this.nomOrganisateur,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: SECONDARY_COLOR)
                      : CText(''),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Opacity(
                      opacity: 0.7,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(Ionicons.star, color: ICONCOLOR),
                          ),
                          CText(this.avis,
                              fontSize: 16, color: SECONDARY_COLOR),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              ProfilePhoto(photoUserProfile),
            ],
          ),
        ),
        this.desc != ""
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 22, right: 22),
                  child: DescriptionTextWidget(text: this.desc),
                ),
              )
            : Container(),
        Padding(
          padding: this.desc == ""
              ? const EdgeInsets.only(left: 22)
              : const EdgeInsets.only(left: 22, top: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              child: CText(
                this.nomOrganisateur != null
                    ? "contacter ${this.nomOrganisateur!.split(" ")[0]}"
                    : 'Contacter',
                color: Colors.blue,
                fontSize: 16,
              ),
              onPressed: this.contacter,
            ),
          ),
        ),
        HorzontalSeparator(),
        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    this.animal == true
                        ? Padding(
                            padding: const EdgeInsets.only(right: 22),
                            child: Icon(Ionicons.paw),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 22),
                            child: Stack(
                              children: [
                                Icon(Ionicons.paw),
                                Positioned(
                                  left: -5,
                                  child: Transform.rotate(
                                      angle: 45,
                                      child: Icon(
                                        Icons.horizontal_rule_outlined,
                                        size: 35,
                                        color: Colors.red,
                                      )),
                                )
                              ],
                            ),
                          ),
                    this.animal == true
                        ? CText(
                            "Le propriétaire possède un ou des animaux",
                            fontSize: 17,
                            color: SECONDARY_COLOR,
                          )
                        : CText(
                            "Aucun animal n'est présent sur place",
                            fontSize: 17,
                            color: SECONDARY_COLOR,
                          )
                  ],
                ),
              ),
              Row(
                children: [
                  this.smoke == true
                      ? Padding(
                          padding: const EdgeInsets.only(right: 22),
                          child: (Icon(Icons.smoking_rooms_outlined)),
                        )
                      : Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 22),
                              child: Icon(Icons.smoking_rooms_outlined),
                            ),
                            Positioned(
                              left: -5,
                              child: Transform.rotate(
                                angle: 45,
                                child: Icon(
                                  Icons.horizontal_rule_outlined,
                                  size: 35,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                  this.smoke == true
                      ? CText(
                          "Vous pouvez fumer à l'intérieur",
                          fontSize: 17,
                          color: SECONDARY_COLOR,
                        )
                      : CText(
                          "Vous devez fumer dehors",
                          fontSize: 17,
                          color: SECONDARY_COLOR,
                        ),
                ],
              ),
            ],
          ),
        ),
        HorzontalSeparator(),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: SECONDARY_COLOR,
                  borderRadius: BorderRadius.circular(15)),
              child: CText("Personnes acceptées : ${list!.length}/$nombre",
                  color: PRIMARY_COLOR, fontSize: 16)),
        ),
        this.nameList!.isNotEmpty
            ? Column(
                children: [
                  // graphique pourcentage homme/femme/autre
                  PieChartInformation(
                    valueHomme: 45,
                    titleHomme: '45 %',
                    valueFemme: 45,
                    titleFemme: '45 %',
                    valueAutre: 10,
                    titleAutre: '10 %',
                  ),
                  PieChartLegend(),
                  // faire la liste des personnes acceptées à la soirée
                  Column(children: this.list as List<Widget>)
                ],
              )
            : Opacity(
                opacity: 0.7,
                child: CText("Il n'y a pas encore d'invité",
                    fontSize: 16, color: SECONDARY_COLOR),
              ),
        SizedBox(height: this.list!.isNotEmpty ? 34 : 50)
      ],
    );
  }
}

class CardBNB extends StatelessWidget {
  final String? prix, heureDebut, heureFin;
  final void Function()? onTap;

  const CardBNB(
      {this.prix, this.onTap, this.heureDebut, this.heureFin, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: PRIMARY_COLOR,
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      CText(this.prix,
                          fontWeight: FontWeight.w600, fontSize: 20),
                      Icon(Icons.euro_outlined, size: 20)
                    ],
                  ),
                ),
                CText('De ${this.heureDebut} à ${this.heureFin}')
              ],
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: SECONDARY_COLOR,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: CText('Rejoindre', color: PRIMARY_COLOR, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class JoinWaitList extends StatelessWidget {
  const JoinWaitList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SECONDARY_COLOR,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        backgroundColor: ICONCOLOR,
        elevation: 0,
        label: Text(
          'OK',
          style: TextStyle(fontSize: 15),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(
            "Vous venez de rejoindre la liste d'attente de la soirée !",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                height: 1.4,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );
  }
}

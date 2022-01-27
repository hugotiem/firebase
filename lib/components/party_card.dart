import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/custom_container.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/components/profile_photo.dart';
import 'package:pts/components/showModalBottomSheet.dart';
import 'package:pts/models/capitalize.dart';
import 'package:pts/models/party.dart';
import 'package:pts/models/services/firestore_service.dart';
import 'package:pts/models/user.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/models/services/auth_service.dart';
import 'package:pts/pages/login/connect.dart';
import 'package:pts/pages/messaging/subpage/chatpage.dart';
import 'package:pts/pages/profil/subpage/existingcard_page.dart';
import 'package:pts/pages/search/sliver/custom_sliver.dart';
import 'package:pts/const.dart';
import 'custom_text.dart';
import 'horizontal_separator.dart';
import 'piechart.dart';

class PartyCard extends StatelessWidget {
  final Party party;

  final FireStoreServices services = FireStoreServices("parties");

  PartyCard({Key? key, required this.party}) : super(key: key);

  Widget buildPartyCard(BuildContext context, Party party) {
    List nameList = party.validatedList ?? [];

    List list = nameList.map((doc) {
      Map infos = party.validatedListInfo[doc];
      return Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ProfilePhoto(infos["photo"], radius: 25),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: CText(
                    "${infos["name"].toString().inCaps} ${infos["surname"].toString().inCaps}",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: SECONDARY_COLOR,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.1, color: FOCUS_COLOR),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();

    List gender = nameList.map((e) {
      Map infos = party.validatedListInfo[e];
      return infos['gender'];
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

      chatCollection
          .doc(party.ownerId)
          .snapshots()
          .listen((datasnapshot) async {
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

          return Stack(children: [
            Center(
              child: Container(
                //height: 270,
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
                                          fontSize: 22,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CText(party.name,
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
                    return BlocProvider(
                      create: (context) => UserCubit()..init(),
                      child: BlocBuilder<UserCubit, UserState>(
                          builder: (context, connectUserState) {
                        return CustomSliverCard(
                          party: party,
                          user: connectUserState.user,
                          image: image,
                          color: color,
                          date:
                              '${DateFormat.E('fr').format(party.startTime!).inCaps} ${DateFormat.d('fr').format(party.startTime!)} ${DateFormat.MMMM('fr').format(party.startTime!)}',
                          startHour:
                              "${DateFormat.Hm('fr').format(party.startTime!).split(":")[0]}h${DateFormat.Hm('fr').format(party.startTime!).split(":")[1]}",
                          endHour:
                              "${DateFormat.Hm('fr').format(party.endTime!).split(':')[0]}h${DateFormat.Hm('fr').format(party.endTime!).split(':')[1]}",
                          body: SizedBox.expand(
                            child: SingleChildScrollView(
                              child: CardBody(
                                user: connectUserState.user,
                                nombre: party.number,
                                desc: party.desc != null ? party.desc : '',
                                nomOrganisateur:
                                    "${user!.name} ${user.surname}",
                                avis: '4.9 / 5 - 0 avis',
                                animal: party.animals!,
                                smoke: party.smoke!,
                                list: list,
                                nameList: nameList,
                                contacter: () => contacter(user.name),
                                photoUserProfile: user.photo,
                                acceptedUserInfo: party.validatedListInfo,
                                gender: gender,
                              ),
                            ),
                          ),
                          bottomNavigationBar: CardBNB(
                            prix: party.price.toString(),
                            onTap: connectUserState.user == null
                                ? GestureDetector(
                                    onTap: () async {
                                      showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25.0),
                                            topRight: Radius.circular(25.0),
                                          ),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 22,
                                                      horizontal: 18),
                                                  child: Text(
                                                    "Tu dois être connecté pour rejoindre une soirée",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 22),
                                                child: Connect(
                                                  text: false,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: SECONDARY_COLOR,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      child: CText('Rejoindre',
                                          color: PRIMARY_COLOR, fontSize: 16),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      if (party.price == 0) {
                                        final uid = connectUserState.user!.id;

                                        if (uid == null) {
                                          throw Error();
                                        }

                                        await BlocProvider.of<PartiesCubit>(
                                                context)
                                            .addUserInWaitList(user, party);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                JoinWaitList(),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ExistingCard(),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: SECONDARY_COLOR,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      child: CText(
                                        'Rejoindre',
                                        color: PRIMARY_COLOR,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildPartyCard(context, party));
  }
}

class CustomSliverCard extends StatefulWidget {
  final Widget? body, titleText, bottomNavigationBar;
  final String? date, image, startHour, endHour;
  final Color? color;
  final User? user;
  final Party party;

  const CustomSliverCard(
      {this.image,
      this.color,
      this.body,
      this.titleText,
      this.date,
      this.bottomNavigationBar,
      this.endHour,
      this.startHour,
      this.user,
      required this.party,
      Key? key})
      : super(key: key);

  @override
  _CustomSliverCardState createState() => _CustomSliverCardState();
}

class _CustomSliverCardState extends State<CustomSliverCard> {
  double? _size, _barSizeWidth, _barSizeHeight, _opacity;
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
      _opacity = 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    Future<void> editParty() {
      return customShowModalBottomSheet(
        context,
        [
          titleText("Gère ta soirée"),
          onTapContainer(context, "Modifie ta soirée", EditParty(widget.party)),
          onTapContainerToDialog(
            context,
            "Supprime ta soirée",
            title: "Supprime ta soirée",
            textButton1: "OUI",
            textButton2: "NON",
            onPressed1: () {
              FirebaseFirestore.instance
                  .collection("parties")
                  .doc(widget.party.id)
                  .delete();
              Navigator.popUntil(context, (route) {
                return count++ == 2;
              });
            }, //supprime la soirée
            onPressed2: () => Navigator.pop(context),
          ),
        ],
      );
    }

    return CustomSliver(
      backgroundColor: PRIMARY_COLOR,
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
          widget.party.ownerId == widget.user?.id
              ? Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 55, right: 22),
                    child: Container(
                      decoration: BoxDecoration(
                        color: PRIMARY_COLOR.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Ionicons.ellipsis_vertical_outline),
                        onPressed: () => editParty(),
                      ),
                    ),
                  ),
                )
              : Container(),
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
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
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
                                    widget.party.name,
                                    fontSize: 26,
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
                                                  size: 25,
                                                ),
                                              ),
                                              CText(
                                                "${widget.date} : de ${widget.startHour} à ${widget.endHour}",
                                                color: SECONDARY_COLOR,
                                                fontSize: 16,
                                              )
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
                                              size: 25,
                                            ),
                                          ),
                                          CText(
                                            widget.party.city,
                                            color: SECONDARY_COLOR,
                                            fontSize: 16,
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
                                  widget.party.name,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              widget.party.ownerId == widget.user?.id
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        onPressed: () => editParty(),
                                        icon: Icon(
                                          Ionicons.ellipsis_vertical_outline,
                                          color: ICONCOLOR,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
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
  final List? nameList, list, gender;
  final void Function()? contacter;
  final Map? acceptedUserInfo;
  final User? user;

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
    this.acceptedUserInfo,
    this.user,
    this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic countMale = 0;
    dynamic countFemale = 0;
    dynamic countOther = 0;

    if (gender!.contains("Homme")) {
      countMale = gender!.where((element) => element == "Homme").length;
    }
    if (gender!.contains("Femme")) {
      countFemale = gender!.where((element) => element == "Femme").length;
    }
    if (gender!.contains("Autre")) {
      countOther = gender!.where((element) => element == "Autre").length;
    }
    countMale = (countMale / gender!.length) * 100;
    countFemale = (countFemale / gender!.length) * 100;
    countOther = (countOther / gender!.length) * 100;
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
                          CText(
                            this.avis,
                            fontSize: 16,
                          ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: DescriptionTextWidget(text: this.desc),
                ),
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Opacity(
                    opacity: 0.7,
                    child: CText(
                      "Aucune description",
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
        user == null
            ? Container()
            : nameList!.contains(user!.id)
                ? Padding(
                    padding: const EdgeInsets.only(left: 22, top: 16),
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
                  )
                : Container(),
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
                    valueHomme: countMale,
                    titleHomme: '$countMale %',
                    valueFemme: countFemale,
                    titleFemme: '$countFemale %',
                    valueAutre: countOther,
                    titleAutre: '$countOther %',
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
  final String? prix;
  final Widget? onTap;

  const CardBNB({this.prix, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: PRIMARY_COLOR, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 10),
        )
      ]),
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Center(
                    child: CText(
                      this.prix,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Icon(Icons.euro_outlined, size: 20)
                ],
              ),
            ),
            onTap!,
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

class EditParty extends StatefulWidget {
  final Party party;
  const EditParty(this.party, {Key? key}) : super(key: key);

  @override
  State<EditParty> createState() => _EditPartyState();
}

class _EditPartyState extends State<EditParty> {
  String? _name;
  String? _theme;
  String? _number;
  bool? _animal;
  bool? _smoke;
  String? _desc;

  TextEditingController? _nameController;
  TextEditingController? _numberController;
  TextEditingController? _descController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.party.name)
      ..addListener(() {
        _name = _nameController!.text;
      });
    _numberController = TextEditingController(text: widget.party.number)
      ..addListener(() {
        _number = _numberController!.text;
      });
    _descController = TextEditingController(text: widget.party.desc)
      ..addListener(() {
        _desc = _descController!.text;
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _animal == null ? _animal = widget.party.animals : _animal = _animal;
    _name == null ? _name = widget.party.name : _name = _name;
    _number == null ? _number = widget.party.number : _number = _number;
    _theme == null ? _theme = widget.party.theme : _theme = _theme;
    _smoke == null ? _smoke = widget.party.smoke : _smoke = _smoke;
    _desc == null ? _desc = widget.party.desc : _desc = _desc;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(actions: [
          TextButton(
            onPressed: () async {
              saveData(widget.party.id, {
                "name": _name,
                "theme": _theme,
                "number": _number,
                "animals": _animal,
                "smoke": _smoke,
                "desc": _desc
              });
              int count = 0;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: CText("Modifié"),
                      content: CText("Tu as bien modifié t'as soirée"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.popUntil(context, (route) {
                            return count++ == 3;
                          }),
                          child: CText("OK"),
                        )
                      ],
                    );
                  });
            },
            child: CText("Sauvegarder"),
          )
        ]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText1(text: "Modifie ta soirée"),
              ttf("Nom", _nameController),
              dropdownTheme("Thème", widget.party.theme),
              ttf("Nombre d'invité", _numberController),
              dropdownAnimals("Animaux", widget.party.animals),
              dropdownSmoke("Fumé", widget.party.smoke),
              ttf('Description', _descController, maxLength: true)
            ],
          ),
        ),
      ),
    );
  }

  Widget ttf(String text, TextEditingController? controller,
      {bool? maxLength = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Stack(
        children: [
          hintText1(text),
          Padding(
            padding:
                EdgeInsets.only(top: controller!.text.length > 60 ? 12 : 0),
            child: TextFormField(
              maxLines: 100,
              minLines: 1,
              maxLength: maxLength == true ? 500 : null,
              textAlignVertical: TextAlignVertical.bottom,
              controller: controller,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: SECONDARY_COLOR),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropdownTheme(String text, String? theme) {
    return Stack(
      children: [
        hintText1(text),
        Padding(
          padding: const EdgeInsets.only(bottom: 22, top: 2),
          child: DropdownButtonFormField<String>(
            value: _theme,
            items: [
              'Festive',
              'Gaming',
              'Jeux de société',
              "Thème",
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: CText(
                  value,
                  fontSize: 16,
                ),
              );
            }).toList(),
            hint: Text(
              theme!,
            ),
            elevation: 0,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 15),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                _theme = value;
              });
            },
            alignment: Alignment.bottomLeft,
          ),
        ),
      ],
    );
  }

  Widget dropdownAnimals(String text, bool? animal) {
    String? val;
    return Stack(
      children: [
        hintText1(text),
        Padding(
          padding: const EdgeInsets.only(bottom: 22, top: 2),
          child: DropdownButtonFormField<String>(
            value: val,
            items: [
              'Oui',
              'Non',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: CText(
                  value,
                  fontSize: 16,
                ),
              );
            }).toList(),
            hint: Text(
              animal == true ? "Oui" : "Non",
            ),
            elevation: 0,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 15),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                val = value;
                val == "Oui" ? _animal = true : _animal = false;
              });
            },
            alignment: Alignment.bottomLeft,
          ),
        ),
      ],
    );
  }

  Widget dropdownSmoke(String text, bool? smoke) {
    String? val;
    return Stack(
      children: [
        hintText1(text),
        Padding(
          padding: const EdgeInsets.only(bottom: 22, top: 2),
          child: DropdownButtonFormField<String>(
            value: val,
            items: [
              'Oui',
              'Non',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: CText(
                  value,
                  fontSize: 16,
                ),
              );
            }).toList(),
            hint: Text(
              smoke == true ? "Oui" : "Non",
            ),
            elevation: 0,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 15),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                val = value;
                val == "Oui" ? _smoke = true : _smoke = false;
              });
            },
            alignment: Alignment.bottomLeft,
          ),
        ),
      ],
    );
  }

  Widget hintText1(String text) {
    return Opacity(opacity: 0.65, child: CText(text));
  }

  Future saveData(String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection("parties").doc(id).update(data);
  }
}

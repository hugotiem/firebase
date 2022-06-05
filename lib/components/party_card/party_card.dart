import 'package:intl/intl.dart';

import 'party_export.dart';

class PartyCard extends StatelessWidget {
  final Party party;

  PartyCard({Key? key, required this.party}) : super(key: key);

  Widget buildPartyCard(BuildContext context, Party party) {
    List nameList = party.validatedList ?? [];

    List list = nameList.map((doc) {
      Map infos = party.validatedListInfo?[doc];
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
      Map infos = party.validatedListInfo?[e];
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

    void contact(String? ownerName, User? connectUser) async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var chatCollection = firestore.collection('chat');
      var currentUserID = connectUser?.id;
      var currentUserName = connectUser?.name;
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

    Future<dynamic> joinPartyBottomSheet(
        double prix,
        List<CreditCard> listCreditcard,
        User? connectedUser,
        User? ownerPartyUser,
        Wallet? wallet) {
      String selectedId = wallet?.id ?? listCreditcard[0].id;
      String selectedType = wallet?.id == null ? "CARD" : "WALLET";
      return customShowModalBottomSheet(
        context,
        child: BlocProvider(
          create: (context) => PaymentCubit(),
          child: BlocBuilder<PaymentCubit, PaymentState>(
              builder: (context, state) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText("Sélectionne ton moyen de paiement"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 4, left: 2),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          NewCreditCard(user: connectedUser)));
                                },
                                child: Container(
                                  height: 70,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: PRIMARY_COLOR,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 3,
                                        spreadRadius: 0,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Ionicons.add_circle_outline,
                                      size: 45),
                                ),
                              ),
                            ),
                            const Text("+ ajouter")
                          ],
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: listCreditcard.length,
                            itemBuilder: (context, index) {
                              var card = listCreditcard[index];
                              bool _selected = card.id == selectedId;
                              return Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedId = card.id;
                                          });
                                        },
                                        child: Badge(
                                          badgeContent: _selected
                                              ? Icon(
                                                  Ionicons.checkmark_outline,
                                                  color: PRIMARY_COLOR,
                                                  size: 15,
                                                )
                                              : null,
                                          position: BadgePosition.bottomEnd(),
                                          badgeColor: _selected
                                              ? SECONDARY_COLOR
                                              : PRIMARY_COLOR,
                                          elevation: 0,
                                          child: Container(
                                            height: 70,
                                            width: 110,
                                            decoration: BoxDecoration(
                                              color: PRIMARY_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: _selected
                                                      ? SECONDARY_COLOR
                                                      : PRIMARY_COLOR,
                                                  width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 3,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 3),
                                                )
                                              ],
                                            ),
                                            child: Center(
                                                child: Text(card.cardProvider)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(card.alias
                                        .substring(8)
                                        .replaceAll("X", "*"))
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                  InsideLineText(text: "ou"),
                  Builder(builder: (context) {
                    if (wallet?.id == null) return Container();
                    bool _selected = selectedId == wallet?.id;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedId = wallet!.id;
                        });
                      },
                      child: Badge(
                        badgeContent: _selected
                            ? Icon(
                                Ionicons.checkmark_outline,
                                color: PRIMARY_COLOR,
                                size: 15,
                              )
                            : null,
                        position: BadgePosition.bottomEnd(),
                        badgeColor: _selected ? SECONDARY_COLOR : PRIMARY_COLOR,
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: PRIMARY_COLOR,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color:
                                    _selected ? SECONDARY_COLOR : PRIMARY_COLOR,
                                width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3,
                                spreadRadius: 0,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              "Portfeuille: ${wallet?.amount.toString()}€",
                              style: TextStyle(fontSize: 17, color: SECONDARY_COLOR),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: GestureDetector(
                      onTap: () async {
                        int _price = (prix * 100).toInt();
                        BlocProvider.of<PaymentCubit>(context).purchase(
                          selectedType,
                          userId: connectedUser?.mangoPayId,
                          amount: _price,
                          selectedPurchaseId: selectedId,
                          creditedUserId: ownerPartyUser?.id,
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.99,
                        height: 40,
                        decoration: BoxDecoration(
                          color: SECONDARY_COLOR,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                "Payer $prix €",
                                style: TextStyle(
                                  color: PRIMARY_COLOR,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Icon(Ionicons.lock_closed_outline,
                                    color: PRIMARY_COLOR),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
          }),
        ),
      );
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
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: PRIMARY_COLOR,
                ),
                child: OpenContainer(
                  openElevation: 0,
                  closedElevation: 0,
                  // transitionDuration: Duration(milliseconds: 200),
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  closedColor: Colors.white,
                  openColor: Colors.white,
                  closedBuilder: (context, returnValue) {
                    return SizedBox(
                      height: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: color,
                                  child: Image.asset(image!),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: BlurryContainer(
                                    height: 85,
                                    bgColor: color == SECONDARY_COLOR
                                        ? Colors.blueGrey
                                        : Colors.yellow.shade100,
                                    child: Column(
                                      children: [
                                        Text(
                                          DateFormat.MMM('fr').format(
                                              party.date ?? DateTime.now()),
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            DateFormat.d('fr').format(
                                                party.date ?? DateTime.now()),
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
                                      CText("${user?.name} ${user?.surname}",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        user?.verified == true
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
                                    CText(party.address!.city!,
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
                      ),
                    );
                  },
                  openBuilder: (context, returnValue) {
                    return BlocProvider(
                      create: (context) => UserCubit()..init(),
                      child: BlocBuilder<UserCubit, UserState>(
                          builder: (context, connectUserState) {
                        return BlocProvider(
                          create: (context) => PartiesCubit()
                            ..fetchPartiesWithWhereIsEqualTo(
                                "party owner", state.user!.id),
                          child: BlocBuilder<PartiesCubit, PartiesState>(
                              builder: (context, partyOwnerState) {
                            if (partyOwnerState.parties == null)
                              return Center(
                                child: CircularProgressIndicator(),
                              );
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
                                    nombre: party.number?.toString(),
                                    desc: party.desc != null ? party.desc : '',
                                    nomOrganisateur:
                                        "${user?.name} ${user?.surname}",
                                    partyOwner: partyOwnerState.parties,
                                    animal: party.animals!,
                                    smoke: party.smoke!,
                                    list: list,
                                    nameList: nameList,
                                    contacter: () => contact(
                                        user?.name, connectUserState.user),
                                    photoUserProfile: user?.photo,
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
                                                    padding:
                                                        const EdgeInsets.only(
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
                                              color: PRIMARY_COLOR,
                                              fontSize: 16),
                                        ),
                                      )
                                    : BlocProvider(
                                        create: (context) => PartiesCubit(),
                                        child: BlocBuilder<PartiesCubit,
                                                PartiesState>(
                                            builder: (context, state) {
                                          return BlocProvider(
                                            create: (context) =>
                                                CardRegistrationCubit()
                                                  ..loadData(connectUserState
                                                      .user!.mangoPayId),
                                            child: BlocBuilder<
                                                    CardRegistrationCubit,
                                                    CardRegistrationState>(
                                                builder: (context,
                                                    paymentCardState) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  if (party.price == 0) {
                                                    final uid = connectUserState
                                                        .user!.id;

                                                    if (uid == null) {
                                                      throw Error();
                                                    }

                                                    await BlocProvider.of<
                                                                PartiesCubit>(
                                                            context)
                                                        .addUserInWaitList(
                                                            user, party);

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            JoinParty(),
                                                      ),
                                                    );
                                                  } else {
                                                    print(party.price);
                                                    joinPartyBottomSheet(
                                                      party.price!,
                                                      paymentCardState.cards!,
                                                      connectUserState.user,
                                                      user,
                                                      connectUserState.wallet,
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                    color: SECONDARY_COLOR,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                  ),
                                                  child: CText(
                                                    'Rejoindre',
                                                    color: PRIMARY_COLOR,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        }),
                                      ),
                              ),
                            );
                          }),
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
    return buildPartyCard(context, party);
  }
}

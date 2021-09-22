import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pts/Model/capitalize.dart';
import 'package:pts/Model/party.dart';
import 'package:pts/Model/user.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/text_descpription_show_hide.dart';
import 'package:pts/model/services/auth_service.dart';
import 'package:pts/view/pages/messaging/subpage/chatpage.dart';
import 'package:pts/view/pages/profil/subpage/existingcard_page.dart';
import 'package:pts/view/pages/search/sliver/custom_sliver.dart';
import '../../../Constant.dart';
import 'horizontal_separator.dart';
import 'join_wait_list.dart';
import 'piechart_informartion.dart';
import 'piechart_legend.dart';
import 'package:blurrycontainer/blurrycontainer.dart';

Widget buildPartyCard(BuildContext context, Party party) {
  List nameList = party.validateGuestList;

  List list = nameList.map((doc) {
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
                  Text(
                    doc['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: SECONDARY_COLOR
                    ),
                  ),
                  Opacity(
                    opacity: 0.7,
                    child: Row(
                      children: [
                        Icon( Icons.star_border_rounded, color: ICONCOLOR),
                        Text(
                          '4.9 / 5 - 0 avis',
                          style: TextStyle(
                            fontSize: 16,
                            color: SECONDARY_COLOR,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 50,
                  width: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(  
                        "assets/roundBlankProfilPicture.png"
                      )
                    )
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Container(
              decoration: BoxDecoration(  
                border: Border(  
                  top: BorderSide(  
                    width: 2,
                    color: FOCUS_COLOR
                  )
                )
              ),
            ),
          )
        ],
      ),
    );
  }).toList();

  List listPhoto = nameList.map((doc) {
    return Align(
      widthFactor: 0.6,
      alignment: Alignment.center,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle, 
          image: DecorationImage(
            image: AssetImage(
              "assets/roundBlankProfilPicture.png"
            )
          )
        ),
      ),
    );
  }).toList();

  List listPhoto1 = nameList.map((doc) {
    return Align(
      widthFactor: 0.6,
      alignment: Alignment.center,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle, 
          image: DecorationImage(
              image: AssetImage(
                "assets/roundBlankProfilPicture.png"
              )
            )
        ),
      ),
    );
  }).toList();

  if (listPhoto.length >= 3) {
    listPhoto1 = listPhoto1.sublist(0, 3);
  }

  List<Color> colors;

  if (party.theme == 'Classique') {
    colors = [
      Color(0xFFf12711),
      Color(0xFFf5af19)
    ];
  } else if (party.theme == 'Gaming') {
    colors = [
      Color(0xFF1c92d2),
      Color(0xFFf2fcfe)
    ];
  } else if (party.theme == 'Jeu de société') {
    colors = [
      Color(0xFFa8ff78),
      Color(0xFF78ffd6)
    ];
  } else if (party.theme == 'Soirée à thème') {
    colors = [
      Color(0xFFb24592),
      Color(0xFFf15f79)
    ];
  }

  void contacter() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var chatCollection = firestore.collection('chat');
    var currentUserID = AuthService().currentUser.uid;
    var currentUserName = AuthService().currentUser.displayName;
    var otherUserUID = party.uid;
    List currentUIDList = [];
    List otherUIDList = [];
    List emptyList = [];

    currentUIDList.add({ 'uid': currentUserID, 'name': currentUserName });
    otherUIDList.add({ 'uid': party.uid, 'name': party.owner });

    chatCollection.doc(party.uid).snapshots().listen((datasnapshot) async {
      chatCollection.doc(currentUserID).snapshots().listen((datasnapshot) async {
        if (datasnapshot.exists) {
          return;
        } else {
          await chatCollection.doc(currentUserID).set({
            'userid': FieldValue.arrayUnion(emptyList),
          });
        }
      });
      if (datasnapshot.exists) {
        await chatCollection.doc(party.uid).update({
          'userid': FieldValue.arrayUnion(currentUIDList),
        }).then((value) {
          chatCollection.doc(currentUserID).update({
            'userid': FieldValue.arrayUnion(otherUIDList),
          }).then((value) {
            Navigator.push(context, 
            MaterialPageRoute(builder: (context) => ChatPage(otherUserUID, otherUserName: party.owner)));
          });
        });
      } else {
        await chatCollection.doc(party.uid).set({
          'userid': emptyList
        }).then((value) {
          chatCollection.doc(currentUserID).set({
            'userid': emptyList
          });
        });
        
        await chatCollection.doc(party.uid).update({
          'userid': FieldValue.arrayUnion(currentUIDList),
        }).then((value) {
          chatCollection.doc(currentUserID).update({
            'userid': FieldValue.arrayUnion(otherUIDList),
          }).then((value) {
            Navigator.push(context, 
            MaterialPageRoute(builder: (context) => ChatPage(otherUserUID, otherUserName: party.owner)));
          });
        });
      }
    });
  }

  return Stack(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Container(
            height: 250,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: PRIMARY_COLOR,
            ),
            child: OpenContainer(
              closedElevation: 0,
              transitionDuration: Duration(milliseconds: 200),
              closedShape: RoundedRectangleBorder(  
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)
                )
              ),
              closedColor: Colors.white,
              openColor: Colors.white,
              closedBuilder: (context, returnValue) {
                return Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30)
                          ),
                          gradient: LinearGradient(  
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: colors
                          )
                        ),
                        child: Stack(  
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12, left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,  
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(  
                                    party.name,
                                    style: TextStyle(  
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: PRIMARY_COLOR
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: PRIMARY_COLOR,
                                      ),
                                      Text(  
                                        party.city,
                                        style: TextStyle(  
                                          color: PRIMARY_COLOR,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12, right: 12),
                                child: BlurryContainer(
                                  bgColor: Colors.red[100],
                                  width: 75,
                                  height: 90,
                                  blur: 2,
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  child: Column( 
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          "${DateFormat.MMM('fr').format(party.startTime).split(".")[0]}",
                                          style: TextStyle(  
                                            fontWeight: FontWeight.w700,
                                            color: PRIMARY_COLOR,
                                            fontSize: 19
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${DateFormat.d('fr').format(party.startTime)}",
                                        style: TextStyle(  
                                          fontWeight: FontWeight.w800,
                                          color: PRIMARY_COLOR,
                                          fontSize: 25
                                        ),
                                      )
                                    ]
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded( 
                      flex:1,
                      child: Container(
                        decoration: BoxDecoration(  
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(15)
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (listPhoto.length <= 3) (
                                Row(children: listPhoto)
                              ) else if (listPhoto.length > 3) (
                                Row(
                                  children: [
                                    Row(children: listPhoto1),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Container( 
                                        height: 30,
                                        decoration: BoxDecoration(  
                                          color: PRIMARY_COLOR,
                                          borderRadius: BorderRadius.circular(25)
                                        ),
                                        child: Center(
                                          child: Text(  
                                            "  +${listPhoto.length - 3}  ",
                                            style: TextStyle(  
                                              fontSize: 16,
                                              color: SECONDARY_COLOR
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ),
                              Container( 
                                margin: EdgeInsets.only(top: 6, bottom: 6, right: 24),
                                width: 120, 
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration( 
                                  color: SECONDARY_COLOR,
                                  borderRadius: BorderRadius.all(Radius.circular(30))
                                ),
                                child: Center(
                                  child: Text(
                                    'Rejoindre',
                                    style: TextStyle(
                                      color: PRIMARY_COLOR,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700
                                    )
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },  
              openBuilder: (context, returnValue) {
                return BlocProvider(
                  create: (context) => UserCubit()..loadData(),
                  child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                    User user = state.user;

                    return CustomSliverCard(
                      color: colors,
                      name: party.name,
                      date: '${DateFormat.E('fr').format(party.startTime).inCaps} ${DateFormat.d('fr').format(party.startTime)} ${DateFormat.MMMM('fr').format(party.startTime)}',
                      location: party.city,
                      body: SizedBox.expand(
                        child: SingleChildScrollView(
                          child: CardBody(
                            nombre: party.number,
                            desc: party.desc != null
                            ? party.desc
                            : '',
                            nomOrganisateur: party.owner,
                            avis: '4.9 / 5 - 0 avis',
                            animal: party.animals,
                            smoke: party.smoke,
                            list: list,
                            nameList: nameList,
                            contacter: () => contacter(),
                          ),
                        ),
                      ),
                      bottomNavigationBar: CardBNB(
                        prix: party.price,
                        heureDebut: "${DateFormat.Hm('fr').format(party.startTime).split(":")[0]}h${DateFormat.Hm('fr').format(party.startTime).split(":")[1]}",
                        heureFin: "${DateFormat.Hm('fr').format(party.endTime).split(':')[0]}h${DateFormat.Hm('fr').format(party.endTime).split(':')[1]}",  
                        onTap: user == null
                        ? () {
                          final snackBar = SnackBar(  
                            content: const Text("Vous n'êtes pas connecté"),
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        : () async {
                          if (party.price == '0') {
                            final _db = FirebaseFirestore.instance
                                .collection('parties')
                                .doc(party.id);

                            final name = user.name;
                            final uid = user.id;
                            List waitList = [];

                            waitList.add({"name": name, "uid": uid});

                            await _db.update({
                              "wait list": FieldValue.arrayUnion(waitList),
                            });

                            Navigator.push( context,
                              MaterialPageRoute(
                                builder: (context) => JoinWaitList()));

                          } else {
                            Navigator.push( context,
                              MaterialPageRoute(
                                builder: (context) => ExistingCard()));
                            }
                        }
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ),
    ],
  );
}
 

class CustomSliverCard extends StatefulWidget {
  final List<Color> color;
  final Widget body, titleText, bottomNavigationBar;
  final String name, date, location;
  
  const CustomSliverCard({
    this.color, 
    this.body, 
    this.titleText, 
    this.name,
    this.date,
    this.location,
    this.bottomNavigationBar,
    Key key 
    }) 
    : super(key: key);

  @override
  _CustomSliverCardState createState() => _CustomSliverCardState();
}

class _CustomSliverCardState extends State<CustomSliverCard> {
  double _size, _barSizeWidth, _barSizeHeight, _borderRadius;
  Brightness _brightness;
  Color _toolbarColor;
  bool _headerName, _headerLocation, _headerDate;

  @override
  void initState() {
    setState(() {
      _size = 300;
      _toolbarColor = Colors.transparent;
      _brightness = Brightness.dark;
      _barSizeWidth = 350;
      _barSizeHeight = 150;
      _headerName = true;
      _headerLocation = true;
      _headerDate = true;
      _borderRadius = 60;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSliver(
      backgroundColor: PRIMARY_COLOR,
      brightness: _brightness,
      toolbarColor: _toolbarColor,
      appBar: Container(  
        height: _size,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(  
          gradient: LinearGradient(  
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.color
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60),
            bottomRight: Radius.circular(60)
          )
        ),
      ),
      body:  widget.body, 
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
                  icon: Icon(Icons.arrow_back_sharp),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          Column(
          children: [
            SizedBox(height: (_size - 80) > 50 ? _size - 80 : 50),
            Center(
              child: Container(
                width: _barSizeWidth,
                height: _barSizeHeight,
                decoration: BoxDecoration(  
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_borderRadius),
                    bottomRight: Radius.circular(_borderRadius),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)
                  )
                ),
                child: Container(
                  child: _headerName == true
                  ? Padding(
                    padding: const EdgeInsets.only(top: 27.5, left: 27.5),
                    child: Column(  
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            widget.name,
                            style: TextStyle(  
                              fontSize: 22,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _headerDate == true
                          ? Row( 
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  color: SECONDARY_COLOR,
                                ),
                              ),
                              Text(
                                widget.date,
                                style: TextStyle(  
                                  color: SECONDARY_COLOR
                                )
                              )
                            ],
                          )
                          : Container()
                        ),
                        _headerLocation == true
                        ? Row( 
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.place_outlined,
                                color: SECONDARY_COLOR,
                              ),
                            ),
                            Text(
                              widget.location,
                              style: TextStyle(  
                                color: SECONDARY_COLOR,
                              ),
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
                          icon: Icon(Icons.arrow_back_sharp, color: ICONCOLOR)
                        ),
                      ),
                      Center(
                        child: Text( 
                          widget.name,
                          style: TextStyle(  
                            fontSize: 22,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  )
                )
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
              _brightness = Brightness.dark;
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

            } else if (_pixels > 200) {
              _size = 100;
              _brightness = Brightness.light;
              _toolbarColor = PRIMARY_COLOR;
              _headerName = false;
            } 
          }
        });

        return true;
      },
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}

class CardBody extends StatelessWidget {
  final String desc, nomOrganisateur, avis, animal, smoke, nombre;
  final List nameList, list;
  final void Function() contacter;

  const CardBody({ Key key, 
  this.desc, 
  this.nomOrganisateur, 
  this.avis, 
  this.animal, 
  this.smoke,
  this.nameList,
  this.list,
  this.nombre,
  this.contacter,
  }) 
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(  
          height: 420,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16,bottom: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(  
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  this.nomOrganisateur != null
                  ?Text(
                    this.nomOrganisateur,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: SECONDARY_COLOR
                    )
                  )
                  :Text(''),
                  Opacity(
                    opacity: 0.7,
                    child: Row(
                      children:[
                        Icon(Icons.star_border_outlined, color: ICONCOLOR),
                        Text(
                          this.avis,
                          style: TextStyle(  
                            fontSize: 16,
                            color: SECONDARY_COLOR
                          ),
                        ),
                      ]
                    ),
                  )
                ],
              ),
              Container(  
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, 
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/roundBlankProfilPicture.png"
                      )
                    )
                ),
              )
            ]
          ),
        ),
        this.desc != ""
        ? Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: DescriptionTextWidget(
              text: this.desc
            ),
          ),
        )
        : Container(height: 0,),
        Padding(
          padding: this.desc == "" 
          ? const EdgeInsets.only(left: 8) 
          : const EdgeInsets.only(left: 8, top: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              child: Text(
                this.nomOrganisateur != null
                ?"contacter ${this.nomOrganisateur.split(" ")[0]}"
                :'Contacter',
                style: TextStyle(  
                  color: Colors.blue,
                  fontSize: 16
                )
              ),
              onPressed: this.contacter,
            )
          ),
        ),
        HorzontalSeparator(),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    this.animal == 'Oui'
                    ? Icon(Icons.pets_outlined)
                    : Stack(
                      children: [
                        Icon(Icons.pets_outlined),
                        Positioned(
                          left: -5,
                          child: Transform.rotate(
                            angle: 45,
                            child: Icon(Icons.horizontal_rule_outlined, size: 35, color: Colors.red,)
                          ),
                        )
                      ]
                    ),
                    this.animal == 'Oui'
                    ? Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        "Les animaux sont autorisés",
                        style: TextStyle(  
                          fontSize: 17,
                          color: SECONDARY_COLOR
                        ),
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        'Les animaux sont interdits',
                        style: TextStyle(  
                          fontSize: 17,
                          color: SECONDARY_COLOR
                        ),
                      ),
                    )
                  ]
                ),
              ),
              Row(  
                children: [
                  if (this.smoke == "A l'intérieur") (
                    Icon(Icons.smoking_rooms_outlined)
                  ) else if (this.smoke == "Dans un fumoir") (
                    Icon(Icons.smoking_rooms_outlined) 
                  ) else if (this.smoke == 'Dehors') (
                     Stack(
                      children: [
                        Icon(Icons.smoking_rooms_outlined),
                        Positioned(
                          left: -5,
                          child: Transform.rotate(  
                            angle: 45,
                            child: Icon(Icons.horizontal_rule_outlined, size: 35, color: Colors.red,),
                          ),
                        )
                      ]
                    )
                  ),
                  if (this.smoke == "A l'intérieur") Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: (
                      Text(
                        "Vous pouvez fumer à l'intérieur",
                        style: TextStyle(  
                          fontSize: 17,
                          color: SECONDARY_COLOR
                        ),
                      )
                    ),
                  ) else if (this.smoke == "Dans un fumoir") Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: (
                      Text(
                        "Vous pouvez fumer dans un fumoir",
                        style: TextStyle(  
                          fontSize: 17,
                          color: SECONDARY_COLOR
                        ),
                      )
                    ),
                  ) else if (this.smoke == "Dehors") Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: (
                      Text(
                        "Vous devez fumer dehors",
                        style: TextStyle(  
                          fontSize: 17,
                          color: SECONDARY_COLOR
                        ),
                      )
                    ),
                  )
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
              borderRadius: BorderRadius.circular(15)
            ),
            child: Text(
              "Personnes acceptées : ${list.length}/$nombre",
              style: TextStyle(  
                color: PRIMARY_COLOR,
                fontSize: 16
              )
            )
          ),
        ),
        this.nameList.isNotEmpty
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
              Column(children: this.list)
            ],
          )
        : Opacity(
            opacity: 0.7,
            child: Text(
              "Il n'y a pas encore d'invité",
              style: TextStyle(
                fontSize: 16,
                color: SECONDARY_COLOR),
          ),
        ),
        SizedBox(height: this.list.isNotEmpty ? 34 : 50)
      ],
    );
  }
}

class CardBNB extends StatelessWidget {
  final String prix, heureDebut, heureFin;
  final void Function() onTap;

  const CardBNB({ this.prix, 
  this.onTap, 
  this.heureDebut, 
  this.heureFin, 
  Key key 
  }) 
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
                Row(  
                  children: [
                    Text(
                      this.prix,
                      style: TextStyle(  
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                      )
                    ),
                    Icon(Icons.euro_outlined, size: 20)
                  ],
                ),
                Text(  
                  'De ${this.heureDebut} à ${this.heureFin}'
                )
              ],
            ),
            GestureDetector(
              onTap: onTap,
              child: Container( 
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(  
                  color: SECONDARY_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Text(
                  'Rejoindre',
                  style: TextStyle(   
                    color: PRIMARY_COLOR,
                    fontSize: 16
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
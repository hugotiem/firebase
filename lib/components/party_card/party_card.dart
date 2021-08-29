import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pts/Model/capitalize.dart';
import 'package:pts/Model/party.dart';
import 'package:pts/Model/user.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/view/pages/search/subpage/choosepayment_page.dart';
import 'open/animalsmoke_information.dart';
import 'open/custombnb.dart';
import 'open/fab_join.dart';
import '../../../../Constant.dart';
import 'close/text_detail.dart';
import 'close/time_text.dart';
import 'close/title_text.dart';
import 'close/vertical_separator.dart';
import 'open/contact_information.dart';
import 'open/date_information.dart';
import 'open/decription_information.dart';
import 'open/horizontal_separator.dart';
import 'open/hour_information.dart';
import 'open/join_wait_list.dart';
import 'open/name_theme_information.dart';
import 'open/piechart_informartion.dart';
import 'open/piechart_legend.dart';
import 'open/price_information.dart';

Widget buildPartyCard(BuildContext context, Party party) {
  List nameList = party.validateGuestList;

  List list = nameList.map((doc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Container(
                  padding: EdgeInsets.only(top: 16, left: 16),
                  child: Text(
                    doc['name'],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: SECONDARY_COLOR),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rate_rounded,
                      color: ICONCOLOR,
                    ),
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
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            child: Padding(
                padding: EdgeInsets.only(top: 30, right: 21),
                child: Container(
                  height: 50,
                  width: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image.network(
                    'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                  ),
                )),
          ),
        )
      ],
    );
  }).toList();

  return Stack(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: OpenContainer(
              closedElevation: 0,
              transitionDuration: Duration(milliseconds: 400),
              closedColor: Colors.white,
              openColor: Colors.white,
              closedBuilder: (context, returnValue) {
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                            padding: EdgeInsets.only(left: 5),
                            alignment: Alignment.centerLeft,
                            child: TimeText(
                              heure:
                                  "${DateFormat.Hm('fr').format(party.startTime).split(':')[0]}h${DateFormat.Hm('fr').format(party.startTime).split(':')[1]}",
                              mois:
                                  "${DateFormat.MMMM('fr').format(party.startTime)}",
                              jour:
                                  "${DateFormat.E('fr').format(party.startTime)}${DateFormat.d('fr').format(party.startTime)}",
                            )),
                      ),
                      VerticalSeparator(),
                      Expanded(
                        flex: 8,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 16, bottom: 10, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  TitleText(
                                      name: party.name, theme: party.theme)
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Textdetail(
                                    headerText: 'invités',
                                    detailText: party.number,
                                  ),
                                  Textdetail(
                                      headerText: 'Prix',
                                      detailText: party.price != '0'
                                          ? '${party.price}€'
                                          : 'Gratuit'),
                                  Textdetail(
                                    headerText: 'ville',
                                    detailText: party.city,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              openBuilder: (context, returnValue) {
                return BlocProvider(
                  create: (context) => UserCubit()..loadData(),
                  child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                    User user = state.user;

                    return Scaffold(
                        appBar: PreferredSize(
                          preferredSize: Size.fromHeight(50),
                          child: BackAppBar(),
                        ),
                        bottomNavigationBar: CustomBNB(),
                        floatingActionButton: FABJoin(
                          label: 'Rejoindre',
                          onPressed: user == null
                              ? null
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
                                      "wait list":
                                          FieldValue.arrayUnion(waitList),
                                    });

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                JoinWaitList()));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChoosePayment()));
                                  }
                                },
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerDocked,
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              NameThemeInformation(
                                nom: party.name.toUpperCase(),
                                theme: party.theme,
                              ),
                              DateInformation(
                                date:
                                    '${DateFormat.E('fr').format(party.startTime).inCaps} ${DateFormat.d('fr').format(party.startTime)} ${DateFormat.MMMM('fr').format(party.startTime)}',
                              ),
                              HourInformation(
                                heuredebut:
                                    'De ${DateFormat.Hm('fr').format(party.startTime).split(":")[0]}h${DateFormat.Hm('fr').format(party.startTime).split(":")[1]}',
                                heurefin:
                                    'A ${DateFormat.Hm('fr').format(party.endTime).split(':')[0]}h${DateFormat.Hm('fr').format(party.endTime).split(':')[1]}',
                              ),
                              SizedBox(height: 50),
                              PriceInformation(
                                prix: '${party.price} €',
                              ),
                              AnimalSmokeInformation(
                                  animal: party.animals, smoke: party.smoke),
                              HorzontalSeparator(),
                              DescriptionInformation(
                                  nomOrganisateur: party.owner,
                                  avis: '4.9 / 5 - 0 avis',
                                  description:
                                      party.desc != null ? party.desc : ''),
                              ContactInformation(
                                onPressed: () {},
                                contact:
                                    'contacter ${party.owner.split(' ')[0]}',
                              ),
                              HorzontalSeparator(),
                              nameList.isNotEmpty
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
                                        Column(children: list)
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
                              SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        ));
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

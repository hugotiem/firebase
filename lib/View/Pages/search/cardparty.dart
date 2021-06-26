import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pts/Model/components/back_appbar.dart';
import 'package:pts/Model/components/text_materials.dart';

import '../../../Constant.dart';

class CardParty extends StatefulWidget {
  const CardParty({ Key key }) : super(key: key);

  @override
  _CardPartyState createState() => _CardPartyState();
}

class _CardPartyState extends State<CardParty> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30, left: 20),
            child: BoldText(text: "Dernières créées"),
          ),
          SizedBox(
            height: 250,
              child: StreamBuilder(
                stream: getPartyStreamSnapshot(context),
                builder:  (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');
                  return PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.docs.length,
                    controller: PageController(viewportFraction: 0.85),
                    onPageChanged: (int index) =>
                      setState(() => _index = index),
                      itemBuilder: (BuildContext context, int index) => 
                        buildPartyCard(context, snapshot.data.docs[index])
                      );
                    }
                  ),
                ),
              ],
            )
          );

  }

  Stream<QuerySnapshot> getPartyStreamSnapshot(BuildContext context) async* {
    yield* FirebaseFirestore.instance
    .collection('party')
    .snapshots();
  }
  

  Widget buildPartyCard(BuildContext context, DocumentSnapshot party) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            margin: EdgeInsets.only(right: 15),
            height: 250,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: OpenContainer(
              closedElevation: 0,
              transitionDuration: Duration(milliseconds: 400),
              closedColor: Colors.white,
              openColor: Colors.white,
              closedBuilder: (context, returnValue) {
                return Container(
                  child: Stack(
                    children: [ 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(
                                      party['Name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(),
                                    child: Opacity(
                                      opacity: 0.7,
                                      child: Text(
                                        party['city'],
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0, left: 5),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.network(
                                          'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, top: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              "Jean",
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.star_rate_rounded,
                                              color: ICONCOLOR,
                                              ),
                                              Text('4.9')
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8, right: 8),
                            alignment: Alignment.topRight,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 8, bottom: 8),
                                  child: Text(
                                    party['Price'],
                                    style: TextStyle(  
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text( 
                                    '€',
                                    style: TextStyle(  
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ]
                  ),
                );
              },


              openBuilder: (context, returnValue) {
                return Scaffold(  
                  appBar: PreferredSize(  
                    preferredSize: Size.fromHeight(50),
                    child: BackAppBar(),
                  ),
                  body: SingleChildScrollView(
                    child: Column(  
                      children: [
                        SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 60,
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 21),
                                      child: Text(
                                        DateFormat.MMMMEEEEd('fr').format(party['Date'].toDate()),
                                        style: TextStyle(  
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700,
                                          color: SECONDARY_COLOR
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(  
                                    height: 40,
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 21),
                                      child: Opacity(
                                        opacity: 0.7,
                                        child: Text(
                                          "${party['Hour'].split(":")[0]}h${party['Hour'].split(":")[1]}",
                                          style: TextStyle(  
                                            fontSize: 16,
                                            color: SECONDARY_COLOR
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 21),
                                child: Container(
                                  height: 60,
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    party['city'],
                                    style: TextStyle(  
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: SECONDARY_COLOR
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 21),
                            child: Container(
                              decoration: BoxDecoration(
                              ),
                              alignment: Alignment.topLeft,
                              child: Text(
                                party['Theme'],
                                style: TextStyle(  
                                  fontSize: 25,
                                  color: SECONDARY_COLOR,
                                  fontWeight: FontWeight.w700
                                ),
                              )
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          child: Stack(
                            children: [
                              Container( 
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(  
                                      width: 1.75,
                                      color: FOCUS_COLOR
                                    ),
                                    bottom: BorderSide(  
                                      width: 1.75,
                                      color: FOCUS_COLOR
                                    )
                                  )
                                ),
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 21),
                                  child: Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      "Prix d'entré pour 1 personne",
                                      style: TextStyle(  
                                        fontSize: 16,
                                        color: SECONDARY_COLOR
                                      ),
                                    ),
                                  ),
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 21),
                                child: Container( 
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "${party['Price']} €",
                                    style: TextStyle(  
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: SECONDARY_COLOR
                                    ),
                                  ),
                                ),
                              )
                            ]
                          )
                        ),
                        SizedBox(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child:Padding(
                                        padding: const EdgeInsets.only(left: 16, top: 30),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 5.0),
                                              child: Opacity(
                                                opacity: 0.9,
                                                child: Text(
                                                  "Jean",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: SECONDARY_COLOR
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Opacity(
                                              opacity: 0.7,
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
                                                      color: SECONDARY_COLOR
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  ),
                                  Container(
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 30.0, right: 21),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.network(
                                            'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                                          ),
                                        ),
                                      ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30, left: 21, right: 21),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.topLeft,
                                  child: Opacity( 
                                    opacity: 0.7,
                                    child: Text(
                                      party['Description'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: SECONDARY_COLOR
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 30),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.topLeft,
                            child: TextButton( 
                              onPressed: () {},
                              child: Text(
                                'Contacter Jean',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 50, left: 21, right: 21),
                          child: Container(
                            decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(  
                                width: 1.75,
                                color: FOCUS_COLOR
                              )
                              )
                            )
                          ),
                        ),
                        // graphique pourcentage homme/femme
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(  
                              sections: [
                                PieChartSectionData(
                                  value: 50,
                                  color: Colors.blue,
                                  title: '50 %',
                                  radius: 50
                                ) ,
                                PieChartSectionData(
                                  value: 50,
                                  color: Colors.pink,
                                  title: '50 %',
                                  radius: 50
                                ) ,
                              ] 
                            )
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(30)
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Femme',
                                    style: TextStyle(  
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30)
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Homme',
                                    style: TextStyle(  
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // faire la liste des invités
                        SizedBox(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Container(
                                          padding: EdgeInsets.only(top: 16, left: 16),
                                          child: Text(
                                            'Jean',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: SECONDARY_COLOR
                                            ),
                                          )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
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
                                                color: SECONDARY_COLOR
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
                                      padding: const EdgeInsets.only(top: 30.0, right: 21),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.network(
                                          'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        SizedBox( 
                          height: 50,
                        )
                      ],
                    ),
                  )
                );
              },
            ),
          ),
        ), 
      ],
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/Constant.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/components/party_card/party_card.dart';

class GetPartyData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(  
        length: 2,
        child: Scaffold(  
          appBar: PreferredSize(  
            preferredSize: Size.fromHeight(110),
            child: new BackAppBar(
              leading: CupertinoButton(
                child: Icon(
                  Icons.arrow_back_sharp,
                  color: ICONCOLOR,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Padding(  
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Soirées',
                  style: TextStyle(  
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.bold
                  ),
                )
              ),
              bottom: TabBar(  
                indicatorColor: SECONDARY_COLOR,
                indicatorWeight: 1.2,
                tabs: [
                  TabText(
                    text: 'Rejoints',
                  ),
                  TabText(  
                    text: 'Créées',
                  )
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              PartyJoin(),
              PartyCreate()
            ]
          )
        ),
      )
    );
  }
}

class PartyJoin extends StatelessWidget {
  const PartyJoin({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PartiesCubit()..fetchPartiesWithWhereArrayContains(
        'validate guest list', 
        AuthService.currentUser.displayName.split(' ')[0],  
        AuthService.currentUser.uid
      ),
      child: BlocBuilder<PartiesCubit, PartiesState>(
        builder: (context, state) {
          if (state.parties == null) return Center(child: const CircularProgressIndicator());
          return ListView.builder(
            itemCount: state.parties.length,
            itemBuilder: (BuildContext context, int index) =>
            buildPartyCard(context, state.parties[index]),
          );
        }
      ),
    );
  }

  // Stream<QuerySnapshot> getStream(BuildContext context) async* {
  //   final _db = FirebaseFirestore.instance.collection('party');
  //   Map _uid = {
  //     'Name': AuthService.currentUser.displayName.split(' ')[0],
  //     'uid': AuthService.currentUser.uid
  //   };

  //   yield* _db
  //       .where('validate guest list', arrayContains: _uid)
  //       .snapshots();
  // }
}


class PartyCreate extends StatelessWidget {
  const PartyCreate({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PartiesCubit()..fetchPartiesWithWhereIsEqualTo(
        'uid', 
        AuthService.currentUser.uid
      ),
      child: BlocBuilder<PartiesCubit, PartiesState>(
        builder: (context, state) {
          if (state.parties == null) return Center(child: const CircularProgressIndicator());
          return ListView.builder(
            itemCount: state.parties.length,
            itemBuilder: (BuildContext context, int index) =>
            buildPartyCard(context, state.parties[index]),
          );
        }
      ),
    );
  }

  // Stream<QuerySnapshot> getPartyStreamSnapshots(BuildContext context) async* {
  //   final _db = FirebaseFirestore.instance.collection('party');
    
  //   yield* _db
  //       .where('UID', isEqualTo: AuthService.currentUser.uid)
  //       .snapshots();
  // }
}


class TabText extends StatelessWidget {
  final String text;
  const TabText({
    this.text, 
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Center(
        child: Text(
          this.text,
          style: TextStyle(  
            color: SECONDARY_COLOR,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }
}
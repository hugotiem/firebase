import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/const.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/party_card.dart';

class MyParty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(110),
            child: new BackAppBar(
              leading: CupertinoButton(
                child: Icon(
                  Ionicons.arrow_back_outline,
                  color: ICONCOLOR,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: TitleAppBar('Soirées'),
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
          body: BlocProvider(
            create: (context) => UserCubit()..init(),
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                
                var user = state.user;
                if (user == null) {
                  return Center(child: CircularProgressIndicator(),);
                }
                
                return TabBarView(
                  children: [
                    PartyJoin(user.name, user.id),
                    PartyCreate(user.id),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PartyJoin extends StatelessWidget {
  final String? name;
  final String? token;
  const PartyJoin(this.name, this.token, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PartiesCubit()
        ..fetchPartiesWithWhereArrayContains('validate guest list', token),
      child: BlocBuilder<PartiesCubit, PartiesState>(builder: (context, state) {
        if (state.parties == null)
          return Center(child: const CircularProgressIndicator());
        return ListView.builder(
          itemCount: state.parties!.length,
          itemBuilder: (BuildContext context, int index) =>
              SizedBox(height: 270, child: PartyCard(party: state.parties![index])),
        );
      }),
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
  final String? token;
  const PartyCreate(this.token, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PartiesCubit()..fetchPartiesWithWhereIsEqualTo('party owner', token),
      child: BlocBuilder<PartiesCubit, PartiesState>(builder: (context, state) {
        if (state.parties == null)
          return Center(child: const CircularProgressIndicator());
        return ListView.builder(
          itemCount: state.parties!.length,
          itemBuilder: (BuildContext context, int index) =>
              SizedBox(height: 270, child: PartyCard(party: state.parties![index])),
        );
      }),
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
  final String? text;
  const TabText({this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Center(
        child: Text(
          this.text!,
          style: TextStyle(color: SECONDARY_COLOR, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

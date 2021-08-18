import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/Constant.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/Model/services/auth_service.dart';
import 'package:pts/components/party_card/party_card.dart';

class PartyWaitList extends StatelessWidget {
  const PartyWaitList({ 
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(  
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          title: Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              'Soirées en attentes',
              style: TextStyle(  
                color: SECONDARY_COLOR,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ),
      ),
      body: BlocProvider(
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
      )
    );
  }

  // Stream<QuerySnapshot> getPartyWaitList(BuildContext context) async* {
  //   Map _uid = {
  //     'Name': AuthService.currentUser.displayName.split(' ')[0],
  //     'uid': AuthService.currentUser.uid
  //   };
  //   yield* FirebaseFirestore.instance
  //       .collection('party')
  //       .where('wait list', arrayContains: _uid)
  //       .snapshots();
  // }
}
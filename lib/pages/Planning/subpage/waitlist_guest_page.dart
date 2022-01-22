import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/custom_container.dart';

import 'package:pts/const.dart';
import 'package:pts/models/party.dart';
import 'package:pts/models/services/firestore_service.dart';
import '../../profil/Profil_page.dart';

class GuestWaitList extends StatelessWidget {
  GuestWaitList({Key? key}) : super(key: key);

  final FireStoreServices services = FireStoreServices("parties");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(title: TitleAppBar("Invités en attentes")),
      ),
      body: BlocProvider(
        create: (context) => UserCubit()..init(),
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state.user == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return BlocProvider(
              create: (context) => PartiesCubit()
                ..fetchPartiesWithWhereIsEqualTo("party owner", state.token)
                ..fetchPartiesWithWhereArrayContains("waitList", state.token),
              child: BlocBuilder<PartiesCubit, PartiesState>(
                builder: (context, state) {
                  if (state.parties == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.parties!.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildValidationCard(
                            context, state.parties![index], services),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget buildValidationCard(
    BuildContext context, Party party, FireStoreServices services) {
  String? partyName = party.name;
  List? idList = party.waitList;

  List list = idList!.map((doc) {
    var infos = party.waitListInfo[doc];
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 22),
                // Widget profilePage()
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                    "assets/roundBlankProfilPicture.png",
                  ),
                ),
              ),
              Container(
                height: 70,
                child: Center(
                  child: Text(
                    infos['name'],
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () async {
                    infos['id'] = doc;
                    await BlocProvider.of<PartiesCubit>(context)
                        .addUserInValidatedList(infos, party);
                  },
                  icon: Icon(
                    Ionicons.checkmark_outline,
                    color: Colors.green,
                  )),
              IconButton(
                onPressed: () async {
                  await BlocProvider.of<PartiesCubit>(context)
                      .removeUserFromWaitList(party, doc);
                },
                icon: Icon(
                  Ionicons.close_outline,
                  color: Colors.red,
                ),
              )
            ],
          )
        ],
      ),
    );
  }).toList();

  return Stack(
    children: [
      Center(
        child: PTSBox(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleTextProfil(text: partyName),
              idList.isNotEmpty
                  ? Column(
                      children: list as List<Widget>,
                    )
                  : Center(
                      child: Opacity(
                        opacity: 0.75,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Tu n'as pas encore reçu de demande",
                            style:
                                TextStyle(fontSize: 17, color: SECONDARY_COLOR),
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      )
    ],
  );
}

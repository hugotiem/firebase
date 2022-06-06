import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/const.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/party_card/party_card.dart';
import 'package:pts/widgets/widgets_export.dart';

class MyParty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Soirées",
        onPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR])),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
          child: DefaultTabController(
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                    indicatorColor: SECONDARY_COLOR,
                    indicatorWeight: 1.2,
                    tabs: [
                      TabText(text: "Rejoints"),
                      TabText(text: "Créées"),
                    ]),
                BlocProvider(
                  create: (context) => UserCubit()..init(),
                  child: BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      var user = state.user;
                      if (user == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Expanded(
                        child: TabBarView(
                          children: [
                            PartyJoin(user.name, user.id),
                            PartyCreate(user.id),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
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
        ..fetchPartiesWithWhereArrayContains('validatedList', token),
      child: BlocBuilder<PartiesCubit, PartiesState>(builder: (context, state) {
        if (state.parties == null)
          return Center(child: const CircularProgressIndicator());
        return ListView.builder(
          itemCount: state.parties!.length,
          itemBuilder: (BuildContext context, int index) => SizedBox(
              height: 270,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: PartyCard(party: state.parties![index]),
              )),
        );
      }),
    );
  }
}

class PartyCreate extends StatelessWidget {
  final String? token;
  const PartyCreate(this.token, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PartiesCubit()..fetchPartiesWithWhereIsEqualTo('ownerId', token),
      child: BlocBuilder<PartiesCubit, PartiesState>(builder: (context, state) {
        if (state.parties == null)
          return Center(child: const CircularProgressIndicator());
        return ListView.builder(
          itemCount: state.parties!.length,
          itemBuilder: (BuildContext context, int index) => SizedBox(
              height: 270,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: PartyCard(party: state.parties![index]),
              )),
        );
      }),
    );
  }
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/const.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/party_card.dart';

class PartyWaitList extends StatelessWidget {
  const PartyWaitList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(title: TitleAppBar('Soirées en attentes')),
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
            print(state.token);
            return BlocProvider(
              create: (context) => PartiesCubit()
                ..fetchPartiesWithWhereArrayContains(
                    'validate guest list', state.token),
              child: BlocBuilder<PartiesCubit, PartiesState>(
                builder: (context, state) {
                  if (state.parties == null)
                    return Center(child: const CircularProgressIndicator());
                  return ListView.builder(
                    itemCount: state.parties!.length,
                    itemBuilder: (BuildContext context, int index) =>
                        PartyCard(party: state.parties![index]),
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

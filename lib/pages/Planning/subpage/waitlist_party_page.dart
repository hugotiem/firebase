import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/const.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/party_card/party_card.dart';
import 'package:pts/widgets/widgets_export.dart';

class PartyWaitList extends StatelessWidget {
  const PartyWaitList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: CustomAppBar(
        title: "Soirées en attentes",
        onPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: BoxDecoration(  
          gradient: LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR])
        ),
        child: Container(
          decoration: BoxDecoration(  
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40))
          ),
          child: BlocProvider(
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
                        'waitList', state.token),
                  child: BlocBuilder<PartiesCubit, PartiesState>(
                    builder: (context, state) {
                      if (state.parties == null)
                        return Center(child: const CircularProgressIndicator());
                      return ListView.builder(
                        itemCount: state.parties!.length,
                        itemBuilder: (BuildContext context, int index) =>
                            SizedBox(height: 270, child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: PartyCard(party: state.parties![index]),
                            )),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => UserCubit()..init(),
          child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
            var token = state.token;
            if (token == null) {
              return Container();
            }
            return BlocProvider(
              create: (context) => PartiesCubit()
                ..fetchPartiesWithWhereArrayContains(
                    "validatedList", token,
                    userLink: true),
              child: BlocBuilder<PartiesCubit, PartiesState>(
                  builder: (context, state) {
                var parties = state.parties;
                print(parties);
                if (state.status != PartiesStatus.loaded) {
                  return Center(child: CircularProgressIndicator());
                } else if (parties == null) {
                  return Center(
                    child: Text("pas de soirées de prévu"),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    children: parties.map<Widget>((e) {
                      return QrImage(data: e.userLink!);
                    }).toList(),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}

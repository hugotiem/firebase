import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/form/custom_ttf_form.dart';
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
            if (state.token == null) {
              return Container();
            }
            print("user token = $token");
            return BlocProvider(
              create: (context) => PartiesCubit()
                ..fetchPartiesWithWhereArrayContains(
                    "validate guest list", state.token),
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
                      print(
                          "link = app.pts.com?token=${e.validateGuestList?.where((element) => (element as Map).containsValue(token)).toList()[0]['token']}");
                      return QrImage(
                          data:
                              "app.pts.com?token=${e.validateGuestList?.where((element) => (element as Map).containsValue(token)).toList()[0]['token']}");
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

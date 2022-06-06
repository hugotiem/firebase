import 'package:pts/components/party_card/party_export.dart';
import 'package:pts/widgets/widgets_export.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "QR code",
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
            child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
              var token = state.token;
              if (token == null) {
                return Container();
              }
              return BlocProvider(
                create: (context) => PartiesCubit()
                  ..fetchPartiesWithWhereArrayContains("validatedList", token,
                      userLink: true),
                child: BlocBuilder<PartiesCubit, PartiesState>(
                    builder: (context, state) {
                  var parties = state.parties;
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
                        print(e.userLink);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: OpenContainer(
                                closedBuilder: (context, returnValue) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Text(e.name ?? ""),
                              );
                            }, openBuilder: (context, returnValue) {
                              return Container();
                            }),
                          ),
                        ); //QrImage(data: e.userLink!);
                      }).toList(),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ),
    );
  }
}

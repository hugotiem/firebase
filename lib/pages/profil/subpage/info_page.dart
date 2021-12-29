import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/components_creation/headertext_one.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/const.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/models/user.dart';

class InformationPage extends StatefulWidget {
  final User user;
  const InformationPage(this.user, {Key? key}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  String? _name = '';
  String? _surname = "";

  TextEditingController? _nameController;
  TextEditingController? _surnameController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.user.name)
      ..addListener(() {
        _name = _nameController!.text.trim();
      });
    _surnameController = TextEditingController(text: widget.user.surname)
      ..addListener(() {
        _surname = _surnameController!.text.trim();
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..init(),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          User? user = state.user;
          bool? verified = user?.verified;

          if (user == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (verified == true) {
            return Text("verifié");
          } else {
            return Scaffold(
              backgroundColor: PRIMARY_COLOR,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: BackAppBar(
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: CText('sauvegarder'),
                    )
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText1(
                          text: 'Modifie tes informations personnelles'),
                      ttf("Prénom", _nameController),
                      ttf('Nom', _surnameController),
                      hintText1('genre'),
                      hintText1('date de naissance'),
                      hintText1('addresse mail'),
                      hintText1('téléphone'),
                      TextButton(
                          onPressed: () => print("$_name $_surname"), child: Text('test'))
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget ttf(String text, TextEditingController? controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Stack(
        children: [
          Opacity(opacity: 0.65, child: CText(text)),
          TextFormField(
            textAlignVertical: TextAlignVertical.bottom,
            cursorColor: SECONDARY_COLOR,
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: SECONDARY_COLOR),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget hintText1(String text) {
    return Opacity(opacity: 0.65, child: CText(text));
  }
}

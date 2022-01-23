import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/user/user_cubit.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/components/form/selectable_items.dart';
import 'package:pts/const.dart';
import 'package:pts/models/services/firestore_service.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/appbar.dart';

class DescriptionPage extends StatefulWidget {
  final void Function()? onNext;
  final void Function()? onPrevious;

  const DescriptionPage({Key? key, this.onNext, this.onPrevious});
  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  bool? _smoke;
  bool? _animals;
  String _description = "";
  final db = FireStoreServices("party");
  final databaseReference = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..init(),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: FORMBACKGROUNDCOLOR,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: BackAppBar(
                  onPressed: () {
                    widget.onPrevious!();
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                  heroTag: 'description',
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    // Soiree.setDataDescriptionPage(
                    //   _animals,
                    //   _smoke,
                    //   _description
                    // );

                    BlocProvider.of<BuildPartiesCubit>(context)
                      // ..addItem('uid', AuthService.currentUser.uid)
                      // ..addItem('owner', AuthService.currentUser.displayName)
                      ..addItem('timeStamp', DateTime.now())
                      ..addItem("animals", _animals)
                      ..addItem("smoke", _smoke)
                      ..addItem("desc", _description)
                      ..addItem("waitList", [])
                      ..addItem("isActive", true)
                      ..addItem("party owner", state.user!.id);

                    await BlocProvider.of<BuildPartiesCubit>(context)
                        .addToFireStore();

                    FocusScope.of(context).unfocus();

                    // await db.add(
                    //   data: {
                    //     'Name': Soiree.nom.trimRight().trimLeft().inCaps,
                    //     'Theme': Soiree.theme,
                    //     'Date': Soiree.date,
                    //     'Number': Soiree.nombre,
                    //     'Price': Soiree.prix,
                    //     'Description': Soiree.description,
                    //     'adress': Soiree.adresse.trimRight().trimLeft().inCaps,
                    //     'city': Soiree.ville.trimRight().trimLeft().inCaps,
                    //     'postal code': Soiree.codepostal,
                    //     'UID': AuthService.currentUser.uid,
                    //     'NameOganizer': AuthService.currentUser.displayName,
                    //     'timestamp': DateTime.now(),
                    //     'StartTime': Soiree.datedebut,
                    //     'EndTime': Soiree.datefin,
                    //     'wait list': FieldValue.arrayUnion(waitList),
                    //     'validate guest list': FieldValue.arrayUnion(validateGuestList),
                    //     'smoke': Soiree.smoke,
                    //     'animals': Soiree.animals
                    //   },
                    // );

                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) => EndPage()));
                  },
                  backgroundColor: SECONDARY_COLOR,
                  elevation: 0,
                  label: Text(
                    'Publier la soirée',
                    style: TextStyle(fontSize: 15),
                  )),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(children: [
                  HeaderText1(text: 'Pour tes invités'),
                  HeaderText2(text: 'Peut-on fumer ?'),
                  SingleSelectableItemsWidget<bool>(
                    onSelected: (bool? value) => setState(() {
                      _smoke = value;
                    }),
                    items: [
                      {"title": "oui", "selected": true},
                      {"title": "non", "selected": false},
                    ],
                    selected: _smoke,
                  ),
                  HeaderText2(
                      text: "Indique s'il y a des animaux chez toi",
                      padding: EdgeInsets.only(bottom: 20, top: 40)),
                  SingleSelectableItemsWidget<bool>(
                    onSelected: (bool? value) => setState(() {
                      _animals = value;
                    }),
                    items: [
                      {"title": "oui", "selected": true},
                      {"title": "non", "selected": false},
                    ],
                    selected: _animals,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  HeaderText1(
                    text: "Un dernier mot pour tes invités ? (Facultatif)",
                  ),
                  Center(
                    child: Container(
                      height: 226,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                            onChanged: (value) {
                              _description = value;
                            },
                            style: TextStyle(
                              fontSize: TEXTFIELDFONTSIZE,
                            ),
                            maxLength: 500,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 10,
                            decoration: InputDecoration(
                                hintText: 'ex: Ambiance boîte de nuit !!',
                                border: InputBorder.none,
                                counterStyle: TextStyle(height: 1))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  )
                ])),
              ));
        },
      ),
    );
  }
}

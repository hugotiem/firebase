import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/services/firestore_service.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/components/components_creation/headertext_one.dart';
import 'package:pts/components/components_creation/headertext_two.dart';

class DescriptionPage extends StatefulWidget {
  final void Function()? onNext;
  final void Function()? onPrevious;

  const DescriptionPage({Key? key, this.onNext, this.onPrevious});
  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  String? _smoke;
  String? _animals;
  String _description = "";
  final db = FireStoreServices("party");
  final databaseReference = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            // Soiree.setDataDescriptionPage(
            //   _animals,
            //   _smoke,
            //   _description
            // );

            List waitList = [];
            List validateGuestList = [];

            BlocProvider.of<BuildPartiesCubit>(context)
              // ..addItem('uid', AuthService.currentUser.uid)
              // ..addItem('owner', AuthService.currentUser.displayName)
              ..addItem('timeStamp', DateTime.now())
              ..addItem("animals", _animals)
              ..addItem("smoke", _smoke)
              ..addItem("desc", _description)
              ..addItem("wait list", FieldValue.arrayUnion(waitList))
              ..addItem("validate guest list",
                  FieldValue.arrayUnion(validateGuestList));

            await BlocProvider.of<BuildPartiesCubit>(context).addToFireStore();

            widget.onNext!();

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: [
          HeaderText1(text: 'Pour vos invités'),
          HeaderText2(text: 'Où peut-on fumer ?'),
          Center(
            child: Container(
              height: HEIGHTCONTAINER,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Center(
                  child: DropdownButtonFormField<String>(
                    value: _smoke,
                    items: ["A l'intérieur", 'Dans un fumoir', 'Dehors']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: TEXTFIELDFONTSIZE),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      'Choisissez un lieu',
                      style: TextStyle(fontSize: TEXTFIELDFONTSIZE),
                    ),
                    elevation: 0,
                    onChanged: (String? value) {
                      setState(() {
                        _smoke = value;
                      });
                    },
                    decoration: InputDecoration(
                        errorStyle: TextStyle(
                          height: 0,
                          background: Paint()..color = Colors.transparent,
                        ),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent))),
                    validator: (value) {
                      if (value == null) {
                        return 'Vous devez faire un choix';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          HeaderText2(
              text: "Y aura-t'il des animaux ?",
              padding: EdgeInsets.only(bottom: 20, top: 40)),
          Center(
            child: Container(
              height: HEIGHTCONTAINER,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Center(
                  child: DropdownButtonFormField<String>(
                    value: _animals,
                    items: [
                      "Oui",
                      'Non',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: TEXTFIELDFONTSIZE),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      'Cliquer pour choisir',
                      style: TextStyle(fontSize: TEXTFIELDFONTSIZE),
                    ),
                    elevation: 0,
                    onChanged: (String? value) {
                      setState(() {
                        _animals = value;
                      });
                    },
                    decoration: InputDecoration(
                        errorStyle: TextStyle(
                          height: 0,
                          background: Paint()..color = Colors.transparent,
                        ),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent))),
                    validator: (value) {
                      if (value == null) {
                        return 'Vous devez faire un choix';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          HeaderText1(
            text: "Un mot à ajouter pour décrire votre soirée ?",
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
      ),
    );
  }
}

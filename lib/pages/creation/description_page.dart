import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/application/application_cubit.dart';
import 'package:pts/components/form/background_form.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/const.dart';
import 'package:pts/models/party.dart';
import 'package:pts/pages/creation/end_page.dart';
import 'package:pts/services/firestore_service.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';

class DescriptionPage extends StatefulWidget {
  final void Function(BuildContext)? onNext;
  final void Function(BuildContext)? onPrevious;

  const DescriptionPage({Key? key, this.onNext, this.onPrevious});
  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  SmokeState? _smoke;
  AnimalState? _animals;
  String _description = "";
  final db = FireStoreServices("party");
  final databaseReference = FirebaseFirestore.instance;

  Widget _selectItemSmoke(BuildContext context, SmokeState data) {
    bool _selected = _smoke == data;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Opacity(
          opacity: _selected ? 1 : 0.6,
          child: AnimatedContainer(
            padding: EdgeInsets.all(12),
            duration: Duration(milliseconds: 100),
            decoration: BoxDecoration(
              color: _selected ? ICONCOLOR : PRIMARY_COLOR,
              border: Border.all(width: 1, color: ICONCOLOR),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                Party.getTitleByState(data),
                style: TextStyle(
                  color: _selected ? PRIMARY_COLOR : ICONCOLOR,
                  fontWeight: FontWeight.w300,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      ),
      onTap: (() => setState(() {
            _smoke = data;
          })),
    );
  }

  Widget _selectItemAnimal(BuildContext context, AnimalState data) {
    bool _selected = _animals == data;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Opacity(
          opacity: _selected ? 1 : 0.6,
          child: AnimatedContainer(
            width: MediaQuery.of(context).size.width * 0.4,
            padding: EdgeInsets.all(12),
            duration: Duration(milliseconds: 100),
            decoration: BoxDecoration(
              color: _selected ? ICONCOLOR : PRIMARY_COLOR,
              border: Border.all(width: 1, color: ICONCOLOR),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                data == AnimalState.allowed ? "Oui" : "Non",
                style: TextStyle(
                  color: _selected ? PRIMARY_COLOR : ICONCOLOR,
                  fontWeight: FontWeight.w300,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      ),
      onTap: (() => setState(() {
            _animals = data;
          })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundForm(
      heroTag: "description",
      onPrevious: () => widget.onPrevious!(context),
      onPressedFAB: () async {
        var user = context.read<ApplicationCubit>().state.user;
        BlocProvider.of<BuildPartiesCubit>(context)
          ..setAnimals(_animals!)
          ..setSmoke(_smoke!)
          ..setDesc(_description)
          ..setOwnerId(user!.id)
          ..setWaitList()
          ..setisActive()
          ..setComment();

        // BlocProvider.of<BuildPartiesCubit>(context)
        // ..addItem('uid', AuthService.currentUser.uid)
        // ..addItem('owner', AuthService.currentUser.displayName)
        // ..addItem('timeStamp', DateTime.now())
        // ..addItem("animals", _animals?.index)
        // ..addItem("smoke", _smoke?.index)
        // ..addItem("desc", _description)
        // ..addItem("waitList", [])
        // ..addItem("isActive", true)
        // ..addItem("party owner", state.user!.id)
        // ..addItem("commentIdList", [])
        // ..addItem("comment", {});

        await BlocProvider.of<BuildPartiesCubit>(context).addToFireStore();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EndPage()));
      },
      children: [
        HeaderText1Form(text: "Informations complémentaires"),
        HeaderText2Form("PEUT-ON FUMER ?"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(child: _selectItemSmoke(context, SmokeState.outside)),
              Expanded(child: _selectItemSmoke(context, SmokeState.inside))
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 30),
          child: _selectItemSmoke(context, SmokeState.notAllowed),
        ),
        HeaderText2Form("Y'A-T-IL DES ANIMAUX CHEZ TOI ?"),
        Padding(
          padding: const EdgeInsets.only(right: 24, left: 24, bottom: 30),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AnimalState.values
                  .map<Widget>((e) => _selectItemAnimal(context, e))
                  .toList(),
            ),
          ),
        ),
        HeaderText2Form("UN DERNIER MOT POUR TES INVITÉS ?"),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 24, left: 24, bottom: 70),
            child: Container(
              height: 226,
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                border: Border.all(color: ICONCOLOR),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  onChanged: (value) {
                    _description = value;
                  },
                  style: TextStyle(fontSize: 22, color: ICONCOLOR),
                  maxLength: 500,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 10,
                  decoration: InputDecoration(
                    counterText: "",
                    hintStyle: TextStyle(
                        color: ICONCOLOR.withOpacity(0.65), fontSize: 22),
                    hintText: 'ex: Ambiance boîte de nuit !!',
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: 1),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
    // return Scaffold(
    //     backgroundColor: FORMBACKGROUNDCOLOR,
    //     appBar: PreferredSize(
    //       preferredSize: Size.fromHeight(50),
    //       child: BackAppBar(
    //         onPressed: () {
    //           widget.onPrevious!();
    //         },
    //       ),
    //     ),
    //     floatingActionButton: FloatingActionButton.extended(
    //         heroTag: 'description',
    //         onPressed: () async {
    //           if (!_formKey.currentState!.validate()) {
    //             return;
    //           }
    //           // Soiree.setDataDescriptionPage(
    //           //   _animals,
    //           //   _smoke,
    //           //   _description
    //           // );

    // BlocProvider.of<BuildPartiesCubit>(context)
    //   // ..addItem('uid', AuthService.currentUser.uid)
    //   // ..addItem('owner', AuthService.currentUser.displayName)
    //   ..addItem('timeStamp', DateTime.now())
    //   ..addItem("animals", _animals)
    //   ..addItem("smoke", _smoke)
    //   ..addItem("desc", _description)
    //   ..addItem("waitList", [])
    //   ..addItem("isActive", true)
    //   ..addItem("party owner", state.user!.id)
    //   ..addItem("commentIdList", [])
    //   ..addItem("comment", {});

    // await BlocProvider.of<BuildPartiesCubit>(context)
    //     .addToFireStore();

    //           FocusScope.of(context).unfocus();

    //           // await db.add(
    //           //   data: {
    //           //     'Name': Soiree.nom.trimRight().trimLeft().inCaps,
    //           //     'Theme': Soiree.theme,
    //           //     'Date': Soiree.date,
    //           //     'Number': Soiree.nombre,
    //           //     'Price': Soiree.prix,
    //           //     'Description': Soiree.description,
    //           //     'adress': Soiree.adresse.trimRight().trimLeft().inCaps,
    //           //     'city': Soiree.ville.trimRight().trimLeft().inCaps,
    //           //     'postal code': Soiree.codepostal,
    //           //     'UID': AuthService.currentUser.uid,
    //           //     'NameOganizer': AuthService.currentUser.displayName,
    //           //     'timestamp': DateTime.now(),
    //           //     'StartTime': Soiree.datedebut,
    //           //     'EndTime': Soiree.datefin,
    //           //     'wait list': FieldValue.arrayUnion(waitList),
    //           //     'validate guest list': FieldValue.arrayUnion(validateGuestList),
    //           //     'smoke': Soiree.smoke,
    //           //     'animals': Soiree.animals
    //           //   },
    //           // );

    //           // Navigator.push(
    //           //     context, MaterialPageRoute(builder: (context) => EndPage()));
    //         },
    //         backgroundColor: SECONDARY_COLOR,
    //         elevation: 0,
    //         label: Text(
    //           'Publier la soirée',
    //           style: TextStyle(fontSize: 15),
    //         )),
    //     floatingActionButtonLocation:
    //         FloatingActionButtonLocation.centerFloat,
    //     body: Form(
    //       key: _formKey,
    //       child: SingleChildScrollView(
    //           child: Column(children: [
    //         HeaderText1(text: 'Pour tes invités'),
    //         HeaderText2(text: 'Peut-on fumer ?'),
    //         SingleSelectableItemsWidget<bool>(
    //           onSelected: (bool? value) => setState(() {
    //             _smoke = value;
    //           }),
    //           items: [
    //             {"title": "oui", "selected": true},
    //             {"title": "non", "selected": false},
    //           ],
    //           selected: _smoke,
    //         ),
    //         HeaderText2(
    //             text: "Indique s'il y a des animaux chez toi",
    //             padding: EdgeInsets.only(bottom: 20, top: 40)),
    //         SingleSelectableItemsWidget<bool>(
    //           onSelected: (bool? value) => setState(() {
    //             _animals = value;
    //           }),
    //           items: [
    //             {"title": "oui", "selected": true},
    //             {"title": "non", "selected": false},
    //           ],
    //           selected: _animals,
    //         ),
    //         SizedBox(
    //           height: 30,
    //         ),
    //         HeaderText1(
    //           text: "Un dernier mot pour tes invités ? (Facultatif)",
    //         ),
    // Center(
    //   child: Container(
    //     height: 226,
    //     width: MediaQuery.of(context).size.width * 0.9,
    //     decoration: BoxDecoration(
    //         color: PRIMARY_COLOR,
    //         borderRadius: BorderRadius.circular(15)),
    //     child: Padding(
    //       padding: const EdgeInsets.only(left: 16, right: 16),
    //       child: TextFormField(
    //           onChanged: (value) {
    //             _description = value;
    //           },
    //           style: TextStyle(
    //             fontSize: TEXTFIELDFONTSIZE,
    //           ),
    //           maxLength: 500,
    //           keyboardType: TextInputType.multiline,
    //           minLines: 1,
    //           maxLines: 10,
    //           decoration: InputDecoration(
    //               hintText: 'ex: Ambiance boîte de nuit !!',
    //               border: InputBorder.none,
    //               counterStyle: TextStyle(height: 1))),
    //     ),
    //   ),
    //         ),
    //         SizedBox(
    //           height: 70,
    //         )
    //       ])),
    //     ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/Constant.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/Model/capitalize.dart';
import 'package:pts/components/components_creation/fab_form.dart';
import 'package:pts/components/components_creation/headertext_one.dart';
import 'package:pts/components/components_creation/headertext_two.dart';
import 'package:pts/components/components_creation/tff_text.dart';

import 'guestnumber_price_page.dart';

class LocationPage extends StatefulWidget {
  final void Function() onNext;

  const LocationPage({Key key, this.onNext}) : super(key: key);
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _adresse;
  String _ville;
  String _codepostal;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FORMBACKGROUNDCOLOR,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(),
      ),
      floatingActionButton: FABForm(
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          }

          BlocProvider.of<BuildPartiesCubit>(context)
            ..addItem("address", _adresse.trimRight().trimLeft().inCaps)
            ..addItem("city", _ville.trimRight().trimLeft().inCaps)
            ..addItem("postal code", _codepostal);

          widget.onNext();

          // Soiree.setDataLocationPage(
          //   _adresse,
          //   _ville,
          //   _codepostal
          // );
          // Navigator.push(context,
          //   MaterialPageRoute(builder: (context) => GuestNumber())
          // );
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText1(
                text: "Où se déroulera-t'elle ?",
              ),
              HeaderText2(
                text: "Adresse",
              ),
              TFFText(
                onChanged: (value) {
                  _adresse = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Vous devez remplir l'adresse";
                  } else {
                    return null;
                  }
                },
                hintText: 'ex: 7 avenue des champs élysés',
              ),
              HeaderText2(
                  text: "Ville", padding: EdgeInsets.only(bottom: 20, top: 40)),
              TFFText(
                onChanged: (value) {
                  _ville = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Vous devez remplir la ville";
                  } else {
                    return null;
                  }
                },
                hintText: 'ex: Paris',
              ),
              HeaderText2(
                  text: "Code postal",
                  padding: EdgeInsets.only(bottom: 20, top: 40)),
              TFFText(
                  onChanged: (value) {
                    _codepostal = value;
                  },
                  hintText: 'ex: 75008',
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Vous devez remplir le code postal";
                    } else if (value.length < 5) {
                      return "Ce code n'existe pas";
                    } else {
                      return null;
                    }
                  },
                  maxLength: 5,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ]),
              SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}

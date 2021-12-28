import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/const.dart';
import 'package:pts/models/address.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/models/capitalize.dart';
import 'package:pts/components/components_creation/fab_form.dart';
import 'package:pts/components/components_creation/headertext_one.dart';
import 'package:pts/components/components_creation/headertext_two.dart';
import 'package:pts/components/components_creation/tff_text.dart';

class LocationPage extends StatefulWidget {
  final void Function()? onNext;
  final void Function()? onPrevious;

  const LocationPage({Key? key, this.onNext, this.onPrevious})
      : super(key: key);
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _postCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Address? address;

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
      floatingActionButton: FABForm(
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          BlocProvider.of<BuildPartiesCubit>(context)
            ..addItem("address",
                _addressController.text.trimRight().trimLeft().inCaps)
            ..addItem(
                "city", _cityController.text.trimRight().trimLeft().inCaps)
            ..addItem("postal code", _postCodeController.text)
            ..addItem("coordinates", [address?.longitude, address?.latitude]);

          widget.onNext!();
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText1(
                text: "Ajoute l'adresse de ta soirée !",
              ),
              HeaderText2(
                text: "Adresse",
              ),
              TypeAheadTFFText(
                controller: _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vous devez remplir l'adresse";
                  } else {
                    return null;
                  }
                },
                hintText: 'ex: 7 avenue des champs élysés',
                suggestionsCallback: (value) {
                  if (value.length > 2) {
                    return BlocProvider.of<BuildPartiesCubit>(context)
                        .searchAddress(value);
                  }
                  return Future(() => {});
                },
                itemBuilder: (BuildContext context, items) {
                  return ListTile(
                    title: Text((items as Address).label!),
                  );
                },
                transitionBuilder: (context, widget, controller) {
                  return widget;
                },
                onSuggestionSelected: (suggestion) {
                  address = suggestion as Address;
                  setState(() {
                    _addressController.text =
                        address!.streetNumber! + " " + address!.streetName!;
                    _cityController.text = address!.city!;
                    _postCodeController.text = address!.postalCode!;
                  });
                },
              ),
              HeaderText2(
                  text: "Ville", padding: EdgeInsets.only(bottom: 20, top: 40)),
              TFFText(
                controller: _cityController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
                  controller: _postCodeController,
                  hintText: 'ex: 75008',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
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

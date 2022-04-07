import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/components/form/background_form.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/components/form/custom_ttf_form.dart';
import 'package:pts/models/address.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/models/capitalize.dart';

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
    return BackgroundForm(
      heroTag: "location",
      onPrevious: () => widget.onPrevious!(),
      onPressedFAB: () {
        if (!_formKey.currentState!.validate()) return;

        BlocProvider.of<BuildPartiesCubit>(context)
          ..addItem(
              "address", _addressController.text.trimRight().trimLeft().inCaps)
          ..addItem("city", _cityController.text.trimRight().trimLeft().inCaps)
          ..addItem("postal code", _postCodeController.text)
          ..addItem("coordinates", [address?.longitude, address?.latitude]);

        widget.onNext!();
      },
      formkey: _formKey,
      children: [
        HeaderText1Form(text: "Le lieu"),
        HeaderText2Form("ADRESSE"),
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
        HeaderText2Form("VILLE"),
        TFFForm(
          "ex: Paris",
          controller: _cityController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Vous devez remplir la ville";
            } else {
              return null;
            }
          },
        ),
        HeaderText2Form("CODE POSTAL"),
        TFFForm(
          "ex: 75008",
          controller: _postCodeController,
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
          ],
        ),
      ],
    );
  }
}

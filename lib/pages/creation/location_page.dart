import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/components/form/background_form.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/widgets/app_text_field.dart';
import 'package:pts/models/address.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';

class LocationPage extends StatefulWidget {
  final void Function(BuildContext)? onNext;
  final void Function(BuildContext)? onPrevious;
  final Address? address;

  const LocationPage({Key? key, this.onNext, this.onPrevious, this.address})
      : super(key: key);
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postCodeController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Address? _address;

  @override
  void initState() {
    _address = widget.address;

    print("OKK $_address");

    _addressController = TextEditingController(
        text: streetnameParser(_address?.streetNumber, _address?.streetName));
    _cityController = TextEditingController(text: _address?.city);
    _postCodeController = TextEditingController(text: _address?.postalCode);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundForm(
      heroTag: "location",
      onPrevious: () => widget.onPrevious!(context),
      onPressedFAB: () {
        if (!_formKey.currentState!.validate()) return;

        BlocProvider.of<BuildPartiesCubit>(context).setAddress(_address!);

        // BlocProvider.of<BuildPartiesCubit>(context)
        //   ..addItem(
        //       "address", _addressController.text.trimRight().trimLeft().inCaps)
        //   ..addItem("city", _cityController.text.trimRight().trimLeft().inCaps)
        //   ..addItem("postal code", _postCodeController.text)
        //   ..addItem("coordinates", [address?.longitude, address?.latitude]);

        widget.onNext!(context);
      },
      formkey: _formKey,
      children: [
        HeaderText1Form(text: "Le lieu"),
        HeaderText2Form("ADRESSE"),
        AppTypeAheadFormField(
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
            _address = suggestion as Address;
            setState(() {
              var parser = streetnameParser(
                  _address!.streetNumber, _address!.streetName);
              if (parser != null) {
                _addressController.text = parser;
                _cityController.text = _address!.city!;
                _postCodeController.text = _address!.postalCode!;
              }
            });
          },
        ),
        HeaderText2Form("VILLE"),
        AppTextFormField(
          hintText: "ex: Paris",
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
        AppTextFormField(
          hintText: "ex: 75008",
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

  String? streetnameParser(String? number, String? street) {
    if (street == null) {
      return null;
    }
    if (number != null) {
      return number + " " + street;
    }

    return street;
  }
}

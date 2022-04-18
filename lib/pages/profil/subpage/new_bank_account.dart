import 'package:flutter/material.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/fab_join.dart';
import 'package:pts/components/form/custom_ttf_form.dart';
import 'package:pts/const.dart';
import 'package:pts/models/address.dart';
import 'package:pts/models/user.dart';
import 'package:pts/services/payment_service.dart';

class NewBankAccount extends StatelessWidget {
  final User user;
  NewBankAccount({required this.user, Key? key}) : super(key: key);

  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final PaymentService _paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(title: TitleAppBar("Ajouter un compte en banque")),
      ),
      floatingActionButton: FABJoin(
        label: 'Ajouter',
        onPressed: () async {
          // if (!_formKey.currentState!.validate()) {
          //   return;
          // }
          print(user.mangoPayId);
          Address _address = Address(
            streetName: _addressLineController.text,
            city: _cityController.text,
            postalCode: _postalCodeController.text,
            country: _countryController.text,
          );
          await _paymentService.addIBANBankAccount(user.mangoPayId!,
              _accountNameController.text, _address, _ibanController.text);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextNewBankAccount(text: "Titulaire du compte"),
            TFFText(
              hintText: "ex: Martin Morel",
              controller: _accountNameController,
              validator: (value) {
                return null;
              },
            ),
            TextNewBankAccount(text: "IBAN"),
            TFFText(
              hintText: "FR12 XXXX XXXX XXXX XXXX XXXX XXX",
              controller: _ibanController,
              validator: (value) {
                return null;
              },
            ),
            TextNewBankAccount(text: "Rue et numéro"),
            TFFText(
              hintText: "7 avenue des champs élysés",
              controller: _addressLineController,
              validator: (value) {
                return null;
              },
            ),
            TextNewBankAccount(text: "Ville"),
            TFFText(
              hintText: "Paris",
              controller: _cityController,
              validator: (value) {
                return null;
              },
            ),
            TextNewBankAccount(text: "Code postal"),
            TFFText(
              hintText: "75008",
              controller: _postalCodeController,
              validator: (value) {
                return null;
              },
            ),
            TextNewBankAccount(text: "Pays"),
            TFFText(
              hintText: "France",
              controller: _countryController,
              validator: (value) {
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TextNewBankAccount extends StatelessWidget {
  final String? text;
  const TextNewBankAccount({this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 21, top: 16, bottom: 8),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Opacity(
          opacity: 0.7,
          child: Text(
            this.text!,
            style: TextStyle(
                color: SECONDARY_COLOR,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

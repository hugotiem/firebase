import 'package:flutter/material.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/fab_join.dart';
import 'package:pts/components/form/custom_ttf_form.dart';
import 'package:pts/const.dart';

class NewBankAccount extends StatelessWidget {
  const NewBankAccount({Key? key}) : super(key: key);

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
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          TextNewBankAccount(text: "Titulaire du compte"),
          TFFText(
            hintText: "ex: Martin Morel",
            validator: (value) {},
          ),
          TextNewBankAccount(text: "IBAN"),
          TFFText(
            hintText: "FR12 XXXX XXXX XXXX XXXX XXXX XXX",
            validator: (value) {},
          ),
          TextNewBankAccount(text: "Rue et numéro"),
          TFFText(
            hintText: "7 avenue des champs élysés",
            validator: (value) {},
          ),
          TextNewBankAccount(text: "Ville"),
          TFFText(
            hintText: "Paris",
            validator: (value) {},
          ),
          TextNewBankAccount(text: "Code postal"),
          TFFText(
            hintText: "75008",
            validator: (value) {},
          ),
          TextNewBankAccount(text: "Pays"),
          TFFText(
            hintText: "France",
            validator: (value) {},
          ),
        ],
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

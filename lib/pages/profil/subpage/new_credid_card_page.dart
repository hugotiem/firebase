import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts/components/appbar.dart';
import 'package:pts/components/components_creation/tff_text.dart';
import 'package:pts/components/fab_join.dart';

import '../../../../const.dart';

class NewCreditCard extends StatefulWidget {
  const NewCreditCard({Key? key}) : super(key: key);

  @override
  _NewCreditCardState createState() => _NewCreditCardState();
}

class _NewCreditCardState extends State<NewCreditCard> {
  String? _holderName;
  String? _endDate;
  String? _cvv;
  String? _cardNumber;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: BackAppBar(
          title: TitleAppBar('Ajouter une carte'),
        ),
      ),
      floatingActionButton: FABJoin(
        label: 'Ajouter',
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          print(_cardNumber);
          print(_endDate);
          print(_cvv);
          print(_holderName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextNewCreditCard(text: 'Titulaire de la carte'),
              TFFText(
                hintText: 'ex: Martin Morel',
                onChanged: (value) {
                  _holderName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrer le nom du propriétaire de la carte';
                  } else {
                    return null;
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextNewCreditCard(
                          text: "Date d'expiration",
                        ),
                      ),
                      TFFText(
                        width: MediaQuery.of(context).size.width * 0.4,
                        hintText: 'XX/XX',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MaskedTextInputFormatter(
                              mask: 'XX/XX', separator: '/')
                        ],
                        onChanged: (value) {
                          _endDate = value;
                        },
                        validator: (value) {
                          if (value != null) {
                            if (value.length < 5) {
                              return 'Date invalide';
                            } else {
                              return null;
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextNewCreditCard(
                          text: "CVV",
                        ),
                      ),
                      TFFText(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        width: MediaQuery.of(context).size.width * 0.4,
                        hintText: 'XXX',
                        maxLength: 3,
                        onChanged: (value) {
                          _cvv = value;
                        },
                        validator: (value) {
                          if (value != null) {
                            if (value.length < 3) {
                              return 'CVV invalide';
                            } else {
                              return null;
                            }
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
              TextNewCreditCard(text: 'Numéro de carte'),
              TFFText(
                textCapitalization: TextCapitalization.characters,
                hintText: 'XXXX XXXX XXXX XXXX',
                onChanged: (value) {
                  _cardNumber = value;
                },
                inputFormatters: [
                  MaskedTextInputFormatter(
                      mask: 'XXXX XXXX XXXX XXXX', separator: ' ')
                ],
                validator: (value) {
                  if (value != null) {
                    if (value.length < 19) {
                      return 'Numéro de carte invalide';
                    } else {
                      return null;
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextNewCreditCard extends StatelessWidget {
  final String? text;
  const TextNewCreditCard({this.text, Key? key}) : super(key: key);

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


class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/components/form/fab_form.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/components/form/selectable_items.dart';
import 'package:pts/components/form/custom_ttf_form.dart';
import 'package:pts/const.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/appbar.dart';

enum RadioChoix { Gratuit, Cinq, Dix, Quinze, Vingt }

class GuestNumber extends StatefulWidget {
  final void Function()? onNext;
  final void Function()? onPrevious;

  const GuestNumber({Key? key, this.onNext, this.onPrevious}) : super(key: key);
  @override
  _GuestNumberState createState() => _GuestNumberState();
}

class _GuestNumberState extends State<GuestNumber> {
  String _nombre = '20';
  double _prix = 5;
  double? _revenu;

  changText() {
    double _nombre1 = double.parse(_nombre);
    double _prix1 = _prix;

    setState(() {
      if (_prix1 == 0) {
        _revenu = 0;
      } else {
        _revenu = (_nombre1 * _prix1) * (1 - (0.17 + 0.014)) - 0.25;
      }
    });
  }

  WidgetSpan _buildWidgetSpan(BuildContext context, String title,
      bool isSelected, void Function() onSelect, void Function() onClose) {
    return WidgetSpan(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.only(
              right: 15,
              top: isSelected ? 0 : 15,
              bottom: isSelected ? 0 : 15,
              left: isSelected ? 0 : 15,
            ),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Colors.grey.withOpacity(0.2) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  IconButton(onPressed: onClose, icon: Icon(Icons.close)),
                Text(title),
              ],
            ),
          ),
          onTap: onSelect,
        ),
      ),
    );
  }

  bool isCustomPrice = false;
  bool isFree = false;

  List<Map<String, dynamic>> prices = [
    {'title': 'gratuit', 'id': false},
    {'title': '5€', 'id': 5},
    {'title': '10€', 'id': 10},
    {'title': '20€', 'id': 20},
    {'title': 'personnaliser', 'id': 'custom'}
  ];

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
        tag: 'guest',
        onPressed: () {
          BlocProvider.of<BuildPartiesCubit>(context)
            ..addItem("number", _nombre)
            ..addItem("price", _prix);

          widget.onNext!();

          //   Soiree.setDataNumberPricePage(
          //     _nombre,
          //     _prix
          //   );
          //   Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => DescriptionPage())
          //   );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText1(
              text: "Combien de personnes souhaites tu inviter ?",
            ),
            Row(
              children: [
                TFFNumber(
                    onChanged: (value) {
                      _nombre = value;
                    },
                    hintText: '20'),
                HintText(text: 'invités')
              ],
            ),
            SizedBox(
              height: 30,
            ),
            HeaderText1(
              text: "Parlons argent, choisis un prix d'entrée !",
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: PriceSelectableItemsWidget(
                initialPrice: 5,
                items: prices,
                onSelected: (double value, bool isCustom) => setState(() {
                  _prix = value;
                  isCustomPrice = isCustom;
                }),
              ),
            ),
            if (isCustomPrice)
              HeaderText2(
                  text: 'Personnalise le prix',
                  padding: EdgeInsets.only(bottom: 20, top: 40)),
            if (isCustomPrice)
              Row(
                children: [
                  TFFNumber(
                    onChanged: (value) {
                      _prix = double.parse(value);
                    },
                    hintText: '10',
                  ),
                  HintText(
                    text: '€',
                  )
                ],
              ),
            SizedBox(
              height: 30,
            ),
            HeaderText1(text: 'Revenu estimé'),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: Row(children: [
                OutlinedButton(
                    onPressed: () => changText(),
                    child: Text(
                      'Simuler',
                      style: TextStyle(
                          color: SECONDARY_COLOR,
                          wordSpacing: 1.5,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    _revenu == null ? '' : '${_revenu!.toStringAsFixed(2)}',
                    style: TextStyle(
                        wordSpacing: 1.5,
                        fontSize: 22,
                        color: SECONDARY_COLOR,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                HintText(text: _revenu == null ? '' : '€')
              ]),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class RadioAndText extends StatelessWidget {
  final dynamic value;
  final dynamic groupValue;
  final void Function(dynamic) onChanged;
  final String text;

  const RadioAndText(
      {required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.text,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
            activeColor: SECONDARY_COLOR,
            value: this.value,
            groupValue: this.groupValue,
            onChanged: this.onChanged),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Container(
            child: Opacity(
              opacity: 0.7,
              child: Text(
                this.text,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

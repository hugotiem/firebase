import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/Constant.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';
import 'package:pts/components/back_appbar.dart';
import 'package:pts/Model/soiree.dart';
import 'package:pts/components/components_creation/fab_form.dart';
import 'package:pts/components/components_creation/headertext_one.dart';
import 'package:pts/components/components_creation/headertext_two.dart';
import 'package:pts/components/components_creation/hint_text.dart';
import 'package:pts/components/components_creation/tff_number.dart';
import 'package:pts/view/pages/creation/description_page.dart';

enum RadioChoix { Gratuit, Cinq, Dix, Quinze, Vingt }

class GuestNumber extends StatefulWidget {
  final void Function() onNext;

  const GuestNumber({Key key, this.onNext}) : super(key: key);
  @override
  _GuestNumberState createState() => _GuestNumberState();
}

class _GuestNumberState extends State<GuestNumber> {
  var _nombre = '20';
  var _prix = '10';
  RadioChoix _choixRadio = RadioChoix.Dix;

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
          BlocProvider.of<BuildPartiesCubit>(context)
            ..addItem("number", _nombre)
            ..addItem("price", _prix);

          widget.onNext();

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
              text: "Combien de personnes souhaitez-vous inviter ?",
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
              text: "A combien fixez-vous le prix d'entré ?",
            ),
            HeaderText2(text: 'Prédéfini'),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RadioAndText(
                      value: RadioChoix.Gratuit,
                      groupValue: _choixRadio,
                      onChanged: (value) {
                        setState(() {
                          _choixRadio = value;
                          _prix = '0';
                        });
                      },
                      text: 'Gratuit'),
                  RadioAndText(
                      value: RadioChoix.Cinq,
                      groupValue: _choixRadio,
                      onChanged: (value) {
                        setState(() {
                          _choixRadio = value;
                          _prix = '5';
                        });
                      },
                      text: '5 €'),
                  RadioAndText(
                      value: RadioChoix.Dix,
                      groupValue: _choixRadio,
                      onChanged: (value) {
                        setState(() {
                          _choixRadio = value;
                          _prix = '10';
                        });
                      },
                      text: '10 €'),
                  RadioAndText(
                      value: RadioChoix.Quinze,
                      groupValue: _choixRadio,
                      onChanged: (value) {
                        setState(() {
                          _choixRadio = value;
                          _prix = '15';
                        });
                      },
                      text: '15 €'),
                  RadioAndText(
                      value: RadioChoix.Vingt,
                      groupValue: _choixRadio,
                      onChanged: (value) {
                        setState(() {
                          _choixRadio = value;
                          _prix = '20';
                        });
                      },
                      text: '20 €'),
                ],
              ),
            ),
            HeaderText2(
                text: 'Custom', padding: EdgeInsets.only(bottom: 20, top: 40)),
            Row(
              children: [
                TFFNumber(
                  onChanged: (value) {
                    _prix = value;
                  },
                  hintText: '10',
                ),
                HintText(
                  text: '€',
                )
              ],
            ),
            SizedBox(
              height: 50,
            )
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
      {@required this.value,
      @required this.groupValue,
      @required this.onChanged,
      @required this.text,
      Key key})
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

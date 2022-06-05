import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/components/form/background_form.dart';
import 'package:pts/components/form/custom_text_form.dart';
import 'package:pts/widgets/app_text_field.dart';
import 'package:pts/const.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';

class GuestNumber extends StatefulWidget {
  final void Function(BuildContext)? onNext;
  final void Function(BuildContext)? onPrevious;

  const GuestNumber({Key? key, this.onNext, this.onPrevious}) : super(key: key);
  @override
  _GuestNumberState createState() => _GuestNumberState();
}

class _GuestNumberState extends State<GuestNumber> {
  double? prix;
  int number = 0;

  bool isCustomPrice = false;
  bool isFree = false;

  late EdgeInsetsGeometry margin;
  late double width;

  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 20);

  List<Map<String, dynamic>> prices = [
    {'title': 'Gratuit', 'id': 0.0},
    {'title': '5€', 'id': 5.0},
    {'title': '10€', 'id': 10.0},
    {'title': '20€', 'id': 20.0},
    {'title': 'Personnaliser', 'id': 21.0}
  ];

  Widget _buildPriceSelector(BuildContext context, Map<String, dynamic> data) {
    bool _selected = prix == data['id'];
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
              child: Text(
                data['title'],
                style: TextStyle(
                  color: _selected ? PRIMARY_COLOR : ICONCOLOR,
                  fontWeight: FontWeight.w300,
                  fontSize: 26,
                ),
              ),
            ),
          ),
        ),
        onTap: () => setState(() {
              prix = (data['id']).toDouble();
            }));
  }

  @override
  Widget build(BuildContext context) {
    if (number < 100) {
      margin = EdgeInsets.only(top: 92, left: 65);
      width = 94;
    } else if (number < 1000) {
      margin = EdgeInsets.only(top: 92, left: 45);
      width = 135;
    } else {
      margin = EdgeInsets.only(top: 92, left: 35);
      width = 155;
    }

    return BackgroundForm(
      heroTag: "guest number price",
      onPrevious: () => widget.onPrevious!(context),
      onPressedFAB: () {
        if (prix == null) return;

        BlocProvider.of<BuildPartiesCubit>(context)
          ..setPrice(prix!)
          ..setNumber(number);

        // BlocProvider.of<BuildPartiesCubit>(context)
        //   ..addItem("number", number)
        //   ..addItem("price", prix);

        widget.onNext!(context);
      },
      children: [
        HeaderText1Form(text: "Les invités"),
        HeaderText2Form("COMBIEN DE PERSONNES SOUHAITES-TU INVITER ?"),
        Stack(
          children: [
            FittedBox(
              child: Padding(
                padding: EdgeInsets.only(top: 92, left: 200),
                child: Text(
                  "invités",
                  style: TextStyle(
                      fontSize: 60,
                      color: ICONCOLOR,
                      fontWeight: FontWeight.w900,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              height: 250,
              width: MediaQuery.of(context).size.width * 0.55,
              child: ListWheelScrollView.useDelegate(
                physics: FixedExtentScrollPhysics(),
                controller: _scrollController,
                squeeze: 1.1,
                onSelectedItemChanged: (value) {
                  setState(() {
                    number = value;
                  });
                },
                itemExtent: 70,
                perspective: 0.001,
                childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 10000,
                    builder: (BuildContext context, int i) {
                      return Opacity(
                        opacity: number == i ? 1 : 0.5,
                        child: Text(
                          i.toString(),
                          style: TextStyle(
                              fontSize: 60, //number == i ? 60 : 45,
                              color: ICONCOLOR,
                              fontWeight: FontWeight.w900),
                        ),
                      );
                    }),
              ),
            ),
            Hero(
              tag: "price",
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: margin,
                  height: 70,
                  width: width,
                  decoration: BoxDecoration(
                      border: Border.all(color: ICONCOLOR, width: 1.2),
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(onTap: () => dialogPopup()),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        HeaderText2Form("CHOISI UN PRIX D'ENTRÉE"),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildPriceSelector(context, prices[0]),
                    _buildPriceSelector(context, prices[1]),
                    _buildPriceSelector(context, prices[2]),
                    _buildPriceSelector(context, prices[3]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 75),
                child: Row(
                  children: [
                    _buildPriceSelector(context, prices[4]),
                    if (prix == 21)
                      Row(
                        children: [
                          TFFNumber(
                            onChanged: (value) {
                              prix = double.parse(value);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              "€",
                              style: TextStyle(
                                color: ICONCOLOR,
                                fontSize: 30,
                              ),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void dialogPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetAnimationDuration: Duration(milliseconds: 200),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 80,
            width: 0,
            constraints: BoxConstraints(minWidth: 10),
            decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: ICONCOLOR)),
            child: Center(
              child: TextFormField(
                initialValue: number.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                  fontSize: 60,
                  color: ICONCOLOR,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
                onFieldSubmitted: (value) {
                  _scrollController.jumpToItem(int.parse(value));
                  Navigator.pop(context);
                },
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        );
      },
    );
  }
}

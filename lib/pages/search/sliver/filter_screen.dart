import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/form/selectable_items.dart';

class FilterScreen extends StatefulWidget {
  final ScrollController sc;
  final BuildContext context;
  final String currentCity;

  final DateTime? currentDate;
  FilterScreen(
      {Key? key,
      required this.sc,
      required this.context,
      required this.currentCity,
      this.currentDate})
      : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<Map<String, dynamic>> themes = [
    {'title': 'Festive', 'selected': false},
    {'title': 'Gaming', 'selected': false},
    {'title': 'Jeux de société', 'selected': false},
    {'title': 'Thème', 'selected': false}
  ];

  // price filter
  List<Map<String, dynamic>> prices = [
    {'title': 'gratuit', 'id': false},
    {'title': 'moins de 5€', 'id': 5},
    {'title': 'moins de 10€', 'id': 10},
    {'title': 'moins de 20€', 'id': 20},
    {'title': 'moins de 50€', 'id': 50},
    {'title': 'séléctionner', 'id': 'custom'}
  ];

  double _currentPrice = 0;
  bool isCustomPrice = false;
  bool isFree = false;

  bool? isAnimals;
  bool? isSmokeAllowed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Map<String, dynamic> filters = {};
                        filters['city'] = widget.currentCity.split(",")[0];
                        if (widget.currentDate != null) {
                          filters['date'] = widget.currentDate;
                        }

                        themes.forEach((element) {
                          if (element['selected']) {
                            if (filters['theme'] == null) {
                              filters['theme'] = [];
                            }
                            (filters['theme'] as List).add(element['title']);
                          }
                        });
                        if (isFree || _currentPrice != 0)
                          filters['price'] = _currentPrice;

                        if (isAnimals != null) {
                          filters['animals'] = isAnimals;
                        }

                        if (isSmokeAllowed != null) {
                          filters['smoke'] = isSmokeAllowed;
                        }

                        print(filters);

                        BlocProvider.of<PartiesCubit>(context)
                            .applyFilters(filters);
                      },
                      child: Text("Appliquer"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    controller: widget.sc,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text("Par thèmes :"),
                            ),
                            Container(
                              child: MultipleSelectableItemsWidget(
                                items: themes,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text("Par prix :"),
                            ),
                            Container(
                              child: PriceSelectableItemsWidget(
                                initialPrice: 0,
                                items: prices,
                                onSelected: (double value, bool isCustom) =>
                                    setState(() {
                                  _currentPrice = value;
                                  isCustomPrice = isCustom;
                                }),
                              ),
                            ),
                            if (isCustomPrice)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                        "moins de ${_currentPrice < 101 ? _currentPrice.toInt() : "100+"}€"),
                                  ),
                                  Container(
                                    child: Slider(
                                      onChanged: (double value) {
                                        setState(() {
                                          _currentPrice = value;
                                        });
                                      },
                                      min: 0,
                                      max: 101,
                                      value: _currentPrice,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text("Animaux :"),
                            ),
                            Container(
                              child: SingleSelectableItemsWidget<bool>(
                                onSelected: (bool? value) => setState(() {
                                  isAnimals = value;
                                }),
                                items: [
                                  {"title": "oui", "selected": true},
                                  {"title": "non", "selected": false},
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text("Fumer à la soirée possible :"),
                            ),
                            Container(
                              child: SingleSelectableItemsWidget<bool>(
                                onSelected: (bool? value) => setState(() {
                                  isSmokeAllowed = value;
                                }),
                                items: [
                                  {"title": "oui", "selected": true},
                                  {"title": "non", "selected": false},
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

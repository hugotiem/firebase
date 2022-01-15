import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/components/form/selectable_items.dart';

class FilterScreen extends StatefulWidget {
  final ScrollController sc;
  final BuildContext context;
  FilterScreen({Key? key, required this.sc, required this.context})
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

  List<WidgetSpan> _buildThemeWidgetSpan(
      BuildContext context, List<Map<String, dynamic>> items) {
    return items.map<WidgetSpan>((e) {
      return _buildWidgetSpan(
        context,
        e['title'],
        e['selected'],
        () => setState(() {
          e['selected'] = true;
        }),
        () => setState(() {
          e['selected'] = false;
        }),
      );
    }).toList();
  }

  List<WidgetSpan> _buildPriceWidgetSpan(
      BuildContext context, List<Map<String, dynamic>> items) {
    return items.map<WidgetSpan>((e) {
      bool _isCustomPrice = e['id'] == 'custom';
      bool _isFree = e['id'] is bool;
      if (_isFree) {
        e['id'] = isFree;
      }
      return _buildWidgetSpan(
        context,
        e['title'],
        _isCustomPrice
            ? isCustomPrice
            : _isFree
                ? e['id']
                : _currentPrice == e['id'],
        () => setState(() {
          if (_isCustomPrice) {
            _currentPrice = 0;
            isCustomPrice = true;
            isFree = false;
          } else if (_isFree) {
            _currentPrice = 0;
            isFree = true;
          } else {
            isCustomPrice = false;
            _currentPrice = (e['id'] as int).toDouble();
            isFree = false;
          }
        }),
        () => setState(() {
          if (_isCustomPrice) {
            isCustomPrice = false;
          }
          if (_isFree) {
            isFree = false;
          }
          _currentPrice = 0;
        }),
      );
    }).toList();
  }

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
                        themes.forEach((element) {
                          if (element['selected']) {
                            if (filters['themes'] == null) {
                              filters['themes'] = [];
                            }
                            (filters['themes'] as List).add(element['title']);
                          }
                        });
                        if (isFree || _currentPrice != 0)
                          filters['price'] = _currentPrice;

                        if (isAnimals != null) {
                          filters['animals'] = isAnimals;
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
                              child: RichText(
                                text: TextSpan(
                                  children: _buildThemeWidgetSpan(
                                    context,
                                    themes,
                                  ),
                                ),
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
                              child: RichText(
                                text: TextSpan(
                                  children:
                                      _buildPriceWidgetSpan(context, prices),
                                ),
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
                              child: Text("Par prix :"),
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

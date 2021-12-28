import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final ScrollController sc;
  FilterScreen({Key? key, required this.sc}) : super(key: key);

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

  List<Map<String, dynamic>> prices = [
    {'title': 'moins de 5€', 'selected': false, 'id': 5},
    {'title': 'moins de 10€', 'selected': false, 'id': 10},
    {'title': 'moins de 20€', 'selected': false, 'id': 20},
    {'title': 'moins de 50€', 'selected': false, 'id': 50},
    {'title': 'custom', 'selected': false}
  ];

  double? _currentPrice = 0;

  List<WidgetSpan> _buildWidgetSpan(
      BuildContext context, List<Map<String, dynamic>> items,
      {String? key}) {
    return items.map<WidgetSpan>((e) {
      bool? cond;
      if (key != null && e['id'] == _currentPrice) {
        cond = true;
      }
      return WidgetSpan(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.only(
                right: 15,
                top: cond ?? e['selected'] ? 0 : 15,
                bottom: cond ?? e['selected'] ? 0 : 15,
                left: cond ?? e['selected'] ? 0 : 15,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
                color:
                    cond ?? e['selected'] ? Colors.grey.withOpacity(0.2) : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cond ?? e['selected'])
                    IconButton(
                        onPressed: () => setState(() {
                              cond != null
                                  ? _currentPrice = e['id']
                                  : e['selected'] = false;
                            }),
                        icon: Icon(Icons.close)),
                  Text(e['title']),
                ],
              ),
            ),
            onTap: () => setState(() {
              cond != null ? _currentPrice = e['id'] : e['selected'] = true;
            }),
          ),
        ),
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
        body: SingleChildScrollView(
          controller: widget.sc,
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                          children: _buildWidgetSpan(
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
                            children: _buildWidgetSpan(context, prices)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text("Custom : ${_currentPrice?.toInt()}€"),
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
                        value: _currentPrice ?? 0,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

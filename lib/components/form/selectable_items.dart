import 'package:flutter/material.dart';
import 'package:pts/const.dart';

WidgetSpan _buildWidgetSpan(BuildContext context, String title, bool isSelected,
    void Function() onSelect, void Function() onClose,
    {bool showIcon = true}) {
  return WidgetSpan(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.only(
            right: 15,
            top: isSelected && showIcon ? 0 : 15,
            bottom: isSelected && showIcon ? 0 : 15,
            left: isSelected && showIcon ? 0 : 15,
          ),
          decoration: BoxDecoration(
            border: isSelected
                ? null
                : Border.all(color: Colors.grey.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? SECONDARY_COLOR : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected && showIcon)
                IconButton(onPressed: onClose, icon: Icon(Icons.close)),
              Text(
                title,
                style: TextStyle(
                    color: isSelected ? Colors.white : SECONDARY_COLOR),
              ),
            ],
          ),
        ),
        onTap: onSelect,
      ),
    ),
  );
}

class SingleSelectableItemsWidget<T> extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final void Function(T?) onSelected;
  const SingleSelectableItemsWidget(
      {Key? key, required this.onSelected, this.selected, required this.items})
      : super(key: key);

  final T? selected;

  List<WidgetSpan> _buildSingleWidgetSpan(
      BuildContext context, List<Map<String, dynamic>> items) {
    String selector = T == bool ? "selected" : "title";
    return items.map<WidgetSpan>((e) {
      bool isSelected = selected != null ? selected == e[selector] : false;
      return _buildWidgetSpan(
        context,
        e["title"],
        isSelected,
        () => onSelected(e[selector]),
        () => onSelected(null),
        showIcon: false,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: _buildSingleWidgetSpan(context, items)));
  }
}

class PriceSelectableItemsWidget extends StatefulWidget {
  final double initialPrice;
  final List<Map<String, dynamic>> items;
  final void Function(double, bool) onSelected;

  const PriceSelectableItemsWidget(
      {Key? key,
      required this.initialPrice,
      required this.items,
      required this.onSelected})
      : super(key: key);

  @override
  _PriceSelectableItemsWidgetState createState() =>
      _PriceSelectableItemsWidgetState();
}

class _PriceSelectableItemsWidgetState
    extends State<PriceSelectableItemsWidget> {
  bool isCustomPrice = false;
  bool isFree = false;
  late double _price;

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
                : _price == e['id'],
        () => setState(() {
          if (_isCustomPrice) {
            _price = 0;
            isCustomPrice = true;
            isFree = false;
          } else if (_isFree) {
            _price = 0;
            isFree = true;
            isCustomPrice = false;
          } else {
            isCustomPrice = false;
            _price = (e['id'] as int).toDouble();
            isFree = false;
          }
          widget.onSelected(_price, isCustomPrice);
        }),
        () => setState(() {
          if (_isCustomPrice) {
            isCustomPrice = false;
          }
          if (_isFree) {
            isFree = false;
          }
          widget.onSelected(_price, isCustomPrice);
        }),
        showIcon: false,
      );
    }).toList();
  }

  @override
  void initState() {
    _price = widget.initialPrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: _buildPriceWidgetSpan(context, widget.items)));
  }
}

class MultipleSelectableItemsWidget extends StatefulWidget {
  MultipleSelectableItemsWidget({Key? key}) : super(key: key);

  @override
  _MultipleSelectableItemsWidgetState createState() =>
      _MultipleSelectableItemsWidgetState();
}

class _MultipleSelectableItemsWidgetState
    extends State<MultipleSelectableItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

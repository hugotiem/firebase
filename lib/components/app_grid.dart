import 'package:flutter/material.dart';

class AppGrid extends StatelessWidget {
  final int col;
  final int? itemCount;
  final List<Widget> children;
  final double? verticalSpacing;
  final double? horizontalSpacing;
  final Widget Function(BuildContext, int)? builder;
  const AppGrid(
      {Key? key,
      required this.col,
      this.builder,
      this.itemCount,
      this.children = const <Widget>[],
      this.verticalSpacing,
      this.horizontalSpacing})
      : super(key: key);

  List<Widget> _getRows(BuildContext context, {int from = 0}) {
    List<Widget> rowChildren = [];
    for (int i = 0; i < col; i++) {
      if (i + from >= (itemCount ?? children.length)) {
        if ((itemCount ?? children.length) % 2 != 0) {
          rowChildren.add(Expanded(child: Container()));
        }
        return rowChildren;
      }

      rowChildren.add(builder != null
          ? Expanded(child: builder!(context, i + from))
          : Expanded(child: children[i + from]));

      if (i < col - 1) {
        rowChildren.add(SizedBox(width: horizontalSpacing));
      }
    }
    return rowChildren;
  }

  List<Widget> _getCols(BuildContext context) {
    List<Widget> colChildren = [];
    for (int i = 0; i < ((itemCount ?? children.length) / col).round(); i++) {
      if (i != 0) {
        colChildren.add(SizedBox(height: verticalSpacing));
      }
      colChildren.add(Row(children: _getRows(context, from: i * col)));
    }
    return colChildren;
  }

  AppGrid.builder(
      {required final int col,
      final int? itemCount,
      final double? horizontalSpacing,
      final double? verticalSpacing,
      required final Widget Function(BuildContext, int) builder})
      : this(
            col: col,
            itemCount: itemCount,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            builder: builder);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: col > 1 ? _getCols(context) : _getRows(context),
    );
  }
}

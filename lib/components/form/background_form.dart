import 'package:flutter/material.dart';
import 'package:pts/const.dart';
import 'package:pts/widgets/widgets_export.dart';

class BackgroundForm extends StatelessWidget {
  final List<Widget> children;
  final void Function() onPressedFAB;
  final Key? formkey;
  final void Function()? onPrevious;
  final String? heroTag;
  final bool validate;
  final bool isScrollable;
  const BackgroundForm(
      {required this.children,
      required this.onPressedFAB,
      this.formkey,
      this.onPrevious,
      this.heroTag,
      this.validate = true,
      this.isScrollable = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onPressed:
            onPrevious != null ? onPrevious : () => Navigator.pop(context),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: heroTag,
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "SUIVANT",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
        onPressed: onPressedFAB,
        elevation: 0,
        backgroundColor:
            validate == true ? ICONCOLOR : ICONCOLOR.withOpacity(0.4),
      ),
      body: Form(
        key: formkey,
        child: Container(
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                SECONDARY_COLOR,
                ICONCOLOR,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.0, 1.0],
            ),
          ),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

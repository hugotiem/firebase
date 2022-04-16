import 'package:flutter/material.dart';
import 'package:pts/const.dart';

class BackgroundForm extends StatelessWidget {
  final List<Widget> children;
  final void Function() onPressedFAB;
  final Key? formkey;
  final void Function()? onPrevious;
  final String? heroTag;
  final bool validate;
  const BackgroundForm(
      {required this.children,
      required this.onPressedFAB,
      this.formkey,
      this.onPrevious,
      this.heroTag,
      this.validate = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: validate == true ? ICONCOLOR : ICONCOLOR.withOpacity(0.4),
      ),
      body: Form(
        key: formkey,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [SECONDARY_COLOR, ICONCOLOR]),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  left: MediaQuery.of(context).size.width * 0.05,
                ),
                child: InkWell(
                  onTap: onPrevious != null
                      ? onPrevious
                      : () => Navigator.pop(context),
                  child: Image(
                    image: AssetImage("assets/RETOUR.png"),
                    alignment: Alignment.topLeft,
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.88,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/const.dart';
import 'package:pts/pages/login/login.dart';

class Connect extends StatelessWidget {
  final BuildContext context;
  const Connect(this.context, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Vous n'etes pas connecté",
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => LoginPage(),
                      fullscreenDialog: true),
                );
                // showModalBottomSheet(
                //   context: context,
                //   builder: (context) => LoginPage(),
                //   isScrollControlled: true,
                // );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ICONCOLOR,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: BoldText(
                  text: "Se connecter",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

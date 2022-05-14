import 'package:flutter/material.dart';
import 'package:pts/components/custom_text.dart';
import 'package:pts/const.dart';
import 'package:pts/pages/login/login.dart';

class Connect extends StatelessWidget {
  final bool? text;
  final void Function(bool)? onLogin;
  const Connect({
    this.text = true,
    Key? key,
    this.onLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              this.text == true
                  ? Container(
                      child: Text(
                        "Tu n'es pas connecté",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                        builder: (context) => LoginPage(),
                        fullscreenDialog: true),
                  )
                      .then((value) {
                    if (onLogin != null) {
                      onLogin!(value ?? false);
                    }
                  });
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
                  child: CText(
                    "Se connecter",
                    color: PRIMARY_COLOR,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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

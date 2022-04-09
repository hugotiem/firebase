import 'package:flutter/material.dart';
import 'package:pts/components/components_export.dart';
import 'package:pts/const.dart';

class EndPage extends StatelessWidget {
  const EndPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "fin",
        backgroundColor: ICONCOLOR,
        elevation: 0,
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "FIN",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
        onPressed: () =>  Navigator.of(context).popUntil((route) => route.isFirst),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [SECONDARY_COLOR, ICONCOLOR],
              ),
            ),
          ),
          Center(
            child: BlurryContainer(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(20),
              bgColor: Colors.blueGrey[50],
              blur: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlurryContainer(
                    kBorderRadius: BorderRadius.circular(20),
                    bgColor: Colors.blueGrey[50],
                    child: Text(
                      "VOUS VENEZ DE PUBLIER VOTRE SOIRÉE !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PRIMARY_COLOR,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Vous pouvez dès maintenant recevoir des demandes.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: PRIMARY_COLOR, fontSize: 22, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

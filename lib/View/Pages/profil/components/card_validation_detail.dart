import 'package:flutter/material.dart';
import 'package:pts/Model/components/ProfilPhoto.dart';
import 'package:pts/Model/components/pts_box.dart';

class CardValidation extends StatelessWidget {
  final String name;

  const CardValidation({ 
    this.name,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PTSBox(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProfilPhoto(),
                      ),
                      Text(
                        this.name
                      )
                    ],
                  ),
                )
              ],
            ),
          ]
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'package:pts/const.dart';

class JoinWaitList extends StatelessWidget {
  const JoinWaitList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SECONDARY_COLOR,
      floatingActionButton: FloatingActionButton.extended(  
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        backgroundColor: ICONCOLOR,
        elevation: 0,
        label: Text(
          'OK',
          style: TextStyle(  
            fontSize: 15
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              "Vous venez de rejoindre la liste d'attente de la soirée !",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                height: 1.4,
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ]
      ),
    );
  }
}
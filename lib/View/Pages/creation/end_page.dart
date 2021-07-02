import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class EndPage extends StatelessWidget {
  const EndPage({ Key key }) : super(key: key);

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
              'Vous venez de publier votre soirée ! Vous pouvez dès maintenant recevoir des demandes.',
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
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';

class NameThemeInformation extends StatelessWidget {
  final String nom;
  final String theme;

  const NameThemeInformation({ 
    this.nom,
    this.theme,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            this.nom,
            style: TextStyle(  
              color: SECONDARY_COLOR,
              fontWeight: FontWeight.w800,
              fontSize: 40
            ),
          ),
          Opacity(
            opacity: 0.7,
            child: Text(
              this.theme,
              style: TextStyle(  
                fontSize: 20,
                color: SECONDARY_COLOR,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ],
      ),
    );
  }
}
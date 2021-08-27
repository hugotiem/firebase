import 'package:flutter/material.dart';
import 'package:pts/constant.dart';

class AnimalSmokeInformation extends StatelessWidget {
  final String animal;
  final String smoke;

  const AnimalSmokeInformation({ 
    this.animal,
    this.smoke,
    Key key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // animaux
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    this.animal == 'Oui'
                    ? Icon(Icons.pets_outlined)
                    : Icon(Icons.pets_outlined),
                  ],
                ),
              ),
              
              this.animal == 'Oui'
              ? Text(
                'Les animaux sont autorisés',
                style: TextStyle(  
                  fontSize: 17,
                  color: SECONDARY_COLOR
                ),
              )
              : Text('Les animaux ne sont pas autorisés',
                style: TextStyle(  
                  fontSize: 17,
                  color: SECONDARY_COLOR
                ),
              ),
            ],
          ),
        ),
        // fumette
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    if (this.smoke == "A l'intérieur")(
                      Icon(Icons.smoking_rooms_outlined)
                    ) else if (this.smoke == 'Dans un fumoir') (
                      Icon(Icons.smoking_rooms_outlined)
                    ) else if (this.smoke == 'Dehors') (
                      Icon(Icons.smoke_free_outlined)
                    ),
                  ],
                ),
              ),
              
              
              if (this.smoke == "A l'intérieur")(
                Text(
                  "Vous pouvez fumer à l'intérieur",
                  style: TextStyle(  
                    fontSize: 17,
                    color: SECONDARY_COLOR
                  ),
                )
              ) else if (this.smoke == 'Dans un fumoir') (
                Text(
                  "Vous pouvez fumer dans un fumoir",
                  style: TextStyle(  
                    fontSize: 17,
                    color: SECONDARY_COLOR
                  ),
                )
              ) else if (this.smoke == 'Dehors') (
                Text(
                  "Il est interdit de fumer à l'intérieur",
                  style: TextStyle(  
                    fontSize: 17,
                    color: SECONDARY_COLOR
                  ),
                )
              )
            ],
          ),
        )
      ],
    );
  }
}
import 'package:flutter/material.dart';

import 'citybox.dart';

class GridViewCity extends StatefulWidget {
  @override
  _GridViewCityState createState() => _GridViewCityState();
}

class _GridViewCityState extends State<GridViewCity> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          SizedBox(
            height: 182,
            child: Container(
              child: Row(
                children: [
                  Column(
                    children: [
                      CityBox(
                        text: 'Paris',
                      ),
                      CityBox(
                        text: 'Marseille',
                      )
                    ]
                  ),
                  Column(
                    children: [
                      CityBox(
                        text: 'Lyon',
                      ),
                      CityBox(
                        text: 'Toulouse',
                      )
                    ]
                  ),
                  Column(
                    children: [
                      CityBox(
                        text: 'Nice',
                      ),
                      CityBox(
                        text: 'Nantes',
                      )
                    ]
                  ),
                  Column(
                    children: [
                      CityBox(
                        text: 'Strasbourg',
                      ),
                      CityBox(
                        text: 'Montpellier',
                      )
                    ]
                  ),
                  Column(
                    children: [
                      CityBox(
                        text: 'Bordeaux',
                      ),
                      CityBox(
                        text: 'Lille',
                      )
                    ]
                  ),
                  SizedBox(
                    width: 32
                  )
                ]
              )
            ),
          ),
        ],
      ),
    );
  }
}
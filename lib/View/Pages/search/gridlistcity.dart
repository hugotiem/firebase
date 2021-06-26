import 'package:flutter/material.dart';
import 'package:pts/Model/components/text_materials.dart';

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
          Container(
            margin: EdgeInsets.only(top: 70, left: 20),
            child: BoldText(
              text: 'Villes'
            ),
          ),
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

class CityBox extends StatelessWidget {
  final String text;
  const CityBox({
    @required this.text,
    Key key 
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, top: 16),
        child: Container(
          height: 75,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
            ),
          child: Center(
            child: Text(
              this.text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:pts/Constant.dart';
import 'package:pts/Model/components/text_materials.dart';

class GridListThemes extends StatefulWidget {
  const GridListThemes({ Key key }) : super(key: key);

  @override
  _GridListThemesState createState() => _GridListThemesState();
}

class _GridListThemesState extends State<GridListThemes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, bottom: 20),
            child: BoldText(
              text: 'Thèmes'
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(  
                  children: [
                    ThemeBox(
                      text: 'Classiques', 
                      colors: [
                        Color(0xFFf12711),
                        Color(0xFFf5af19)
                      ]
                    ),
                    ThemeBox(  
                      text: 'Gamings',
                      colors: [
                        Color(0xFF1c92d2),
                        Color(0xFFf2fcfe)
                      ],
                    )
                  ]
                ),
                Row(
                  children: [
                    ThemeBox(
                      text: 'Jeux de sociétés', 
                      colors: [
                        Color(0xFFa8ff78),
                        Color(0xFF78ffd6)
                      ]
                    ),
                    ThemeBox(  
                      text: 'Soirées à thèmes',
                      colors: [
                        Color(0xFFb24592),
                        Color(0xFFf15f79)
                      ],
                    )
                  ],
                )
              ]
            ),
          )
        ],
      ),
    );
  }
}


class ThemeBox extends StatelessWidget {
  final List<Color> colors;
  final String text;
  const ThemeBox({
    @required this.text,
    @required this.colors,
    Key key 
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 40, right: 10),
      height: 145,
      width: 145,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: this.colors
        )
      ),
      child: Center(
        child: Text(
          this.text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
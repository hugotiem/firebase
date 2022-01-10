import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartInformation extends StatelessWidget {
  final double? valueHomme;
  final double? valueFemme;
  final double? valueAutre;
  final String? titleHomme;
  final String? titleFemme;
  final String? titleAutre;

  const PieChartInformation({
    this.titleAutre,
    this.titleFemme,
    this.titleHomme,
    this.valueAutre,
    this.valueFemme,
    this.valueHomme,
    Key? key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(  
          sections: [
            PieChartSectionData(  
              value: this.valueHomme,
              color: Colors.blue,
              title: this.titleHomme,
              radius: 50,
            ),
            PieChartSectionData(  
              value: this.valueFemme,
              color: Colors.pink,
              title: this.titleFemme,
              radius: 50,
            ),
            PieChartSectionData(  
              value: this.valueAutre,
              color: Colors.grey,
              title: this.titleAutre,
              radius: 50,
            ),
          ]
        )
      ),
    );
  }
}

class PieChartLegend extends StatelessWidget {
  const PieChartLegend({ 
    Key? key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: EdgeInsets.only(bottom: 16, top: 16),
        child: Column(  
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleLegend(
                  color: Colors.pink
                ),
                TextLegend(
                  legend: 'Femme'
                ),
                CircleLegend(
                  color: Colors.blue
                ),
                TextLegend(
                  legend: 'Homme'
                ),
              ]
            ),
            Row(  
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleLegend(
                  color: Colors.grey
                ),
                TextLegend(
                  legend: 'Autre'
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CircleLegend extends StatelessWidget {
  final Color? color;

  const CircleLegend({ 
    this.color,
    Key? key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(  
        color: this.color,
        borderRadius: BorderRadius.circular(30)
      ),
    );
  }
}

class TextLegend extends StatelessWidget {
  final String? legend;

  const TextLegend({ 
    this.legend,
    Key? key 
    }) 
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 4, top: 4),
      child: Text(
        this.legend!,
        style: TextStyle(  
          fontSize: 15,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
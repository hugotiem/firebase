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
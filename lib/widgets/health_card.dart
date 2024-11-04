import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/chart_data.dart';

class HealthCard extends StatelessWidget {
  final String title;
  final dynamic value;
  final String unit;
  final List<ChartData> data;

  HealthCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title: ${value ?? 'N/A'} $unit',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(isVisible: true),
                  primaryYAxis: NumericAxis(isVisible: true),
                  series: <ChartSeries>[
                    LineSeries<ChartData, double>(
                      dataSource: data,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      animationDuration: 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

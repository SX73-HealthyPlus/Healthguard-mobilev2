import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/home/ChartWidget.dart';
import 'chart_data.dart';

class DataCard extends StatelessWidget {
  final String title;
  final List<ChartData> data;
  final dynamic currentValue;
  final double minY;
  final double maxY;

  DataCard({
    required this.title,
    required this.data,
    required this.currentValue,
    required this.minY,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(title),
            subtitle: Text('Valor Actual: $currentValue'),
          ),
          Container(
            height: 200,
            child: ChartWidget(data: data, minY: minY, maxY: maxY),
          ),
        ],
      ),
    );
  }
}
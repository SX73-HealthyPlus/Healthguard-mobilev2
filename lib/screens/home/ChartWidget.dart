import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/chart_data.dart';

class ChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final double minY;
  final double maxY;

  ChartWidget({required this.data, required this.minY, required this.maxY});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Añadir espacio con respecto a los bordes
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Ocultar títulos izquierdos
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Ocultar títulos superiores
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, // Mostrar títulos derechos
                interval: (maxY - minY) / 5, // Ajustar intervalo para la leyenda derecha
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Ocultar títulos inferiores
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          minX: 0,
          maxX: 8, // Ajustar para mostrar solo hasta la posición 8
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: data.take(9).map((point) => FlSpot(point.x, point.y)).toList(), // Mostrar solo hasta la posición 8
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
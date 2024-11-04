import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home/HealthDataProvider.dart';
import 'health_card.dart';

class HealthMonitor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HealthDataProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage.isNotEmpty) {
          return Center(child: Text(provider.errorMessage));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HealthCard(
                  title: 'Body Temperature',
                  value: provider.healthData['bodyTemperature'],
                  unit: '°C',
                  data: provider.bodyTemperatureData,
                ),
                HealthCard(
                  title: 'Breath Rate',
                  value: provider.healthData['breathRate'],
                  unit: 'bpm',
                  data: provider.breathRateData,
                ),
                HealthCard(
                  title: 'Heart Rate',
                  value: provider.healthData['heartRate'],
                  unit: 'bpm',
                  data: provider.heartRateData,
                ),
                HealthCard(
                  title: 'Oxygen Level',
                  value: provider.healthData['oxygenLevel'],
                  unit: '%',
                  data: provider.oxygenLevelData,
                ),
                Text('Last Updated: ${provider.healthData['time'] ?? 'N/A'}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

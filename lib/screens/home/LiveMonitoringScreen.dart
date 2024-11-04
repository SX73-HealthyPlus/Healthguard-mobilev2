import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/DataCard.dart';
import 'HealthDataProvider.dart';

class LiveMonitoringScreen extends StatelessWidget {
  final int iotDataId;
  final int patientId;
  LiveMonitoringScreen({required this.iotDataId, required this.patientId});

  @override
  Widget build(BuildContext context) {
    print('Initializing LiveMonitoringScreen with iotDataId: $iotDataId');
    return ChangeNotifierProvider(
      create: (context) => HealthDataProvider(iotDataId: iotDataId, patientId: patientId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Monitoreo en Vivo'),
        ),
        body: Consumer<HealthDataProvider>(
          builder: (context, healthDataProvider, child) {
            if (healthDataProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (healthDataProvider.errorMessage.isNotEmpty) {
              return Center(child: Text(healthDataProvider.errorMessage));
            } else {
              return ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('Información del Paciente'),
                    subtitle: Text('Nombre: ${healthDataProvider.patientData['firstName']} ${healthDataProvider.patientData['lastName']}\n'
                        'DNI: ${healthDataProvider.patientData['dni']}\n'
                        'Edad: ${healthDataProvider.patientData['age']}\n'
                        'Género: ${healthDataProvider.patientData['gender']}'),
                  ),
                  DataCard(
                    title: 'Frecuencia Cardiaca',
                    data: healthDataProvider.heartRateData,
                    currentValue: healthDataProvider.healthData['heartRate'] ?? 'N/A',
                    minY: 0,
                    maxY: 200,
                  ),
                  DataCard(
                    title: 'Temperatura Corporal',
                    data: healthDataProvider.bodyTemperatureData,
                    currentValue: healthDataProvider.healthData['temperature'] ?? 'N/A',
                    minY: 0,
                    maxY: 100,
                  ),
                  DataCard(
                    title: 'Nivel de Oxígeno',
                    data: healthDataProvider.oxygenLevelData,
                    currentValue: healthDataProvider.healthData['oximeter'] ?? 'N/A',
                    minY: 0,
                    maxY: 100,
                  ),
                  DataCard(
                    title: 'Frecuencia Respiratoria',
                    data: healthDataProvider.breathRateData,
                    currentValue: healthDataProvider.healthData['respiratoryRate'] ?? 'N/A',
                    minY: 0,
                    maxY: 50,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
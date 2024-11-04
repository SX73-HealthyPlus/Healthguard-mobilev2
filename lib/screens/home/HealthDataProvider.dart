import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/chart_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthDataProvider extends ChangeNotifier {
  final int iotDataId;
  final int patientId;
  final String firebaseUrl = 'https://funda-aad4f-default-rtdb.firebaseio.com/.json';
  Map<String, dynamic> healthData = {};
  Map<String, dynamic> patientData = {};
  bool isLoading = true;
  String errorMessage = '';
  Timer? _timer;

  List<ChartData> bodyTemperatureData = List.generate(9, (index) => ChartData(index.toDouble(), 0));
  List<ChartData> breathRateData = List.generate(9, (index) => ChartData(index.toDouble(), 0));
  List<ChartData> heartRateData = List.generate(9, (index) => ChartData(index.toDouble(), 0));
  List<ChartData> oxygenLevelData = List.generate(9, (index) => ChartData(index.toDouble(), 0));

  HealthDataProvider({required this.iotDataId, required this.patientId}) {
    _savePatientIdToStorage();
    fetchData();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fetchData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _savePatientIdToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('patientId', patientId);
  }

  Future<int?> _getPatientIdFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('patientId');
  }

  Future<void> fetchData() async {
    await fetchIoTData(); // Primero obtenemos los datos de IoT
    await fetchHealthDataFromFirebase(); // Luego obtenemos los datos de Firebase
    await fetchPatientData(); // Finalmente obtenemos los datos del paciente
  }

  Future<void> fetchHealthDataFromFirebase() async {
    try {
      final response = await http.get(Uri.parse(firebaseUrl));
      if (response.statusCode == 200) {
        final firebaseData = json.decode(response.body);
        healthData = {
          "temperature": firebaseData["HealthData"]["bodyTemperature"],
          "respiratoryRate": firebaseData["HealthData"]["breathRate"],
          "heartRate": firebaseData["HealthData"]["heartRate"],
          "oximeter": firebaseData["HealthData"]["oxygenLevel"],
        };
        updateChartData(bodyTemperatureData, healthData['temperature'].toDouble());
        updateChartData(breathRateData, healthData['respiratoryRate'].toDouble());
        updateChartData(heartRateData, healthData['heartRate'].toDouble());
        updateChartData(oxygenLevelData, healthData['oximeter'].toDouble());
        isLoading = false;
        notifyListeners();
      } else {
        errorMessage = 'Failed to load data from Firebase: ${response.statusCode}';
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchIoTData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/iotdata/$iotDataId'));
      if (response.statusCode == 200) {
        final iotData = json.decode(response.body);
        print('Fetched IoT data with iotDataId: $iotDataId');
        await updateLocalServer(iotData);
      } else {
        errorMessage = 'Failed to load IoT data: ${response.statusCode}';
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
      notifyListeners();
    }
  }

  Future<void> updateLocalServer(Map<String, dynamic> iotData) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/iotdata/values/$iotDataId'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "temperature": healthData["temperature"],
          "oximeter": healthData["oximeter"],
          "heartRate": healthData["heartRate"],
          "respiratoryRate": healthData["respiratoryRate"]
        }),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        errorMessage = 'Failed to update local server: ${response.statusCode}';
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
      notifyListeners();
    }
  }

  Future<void> fetchPatientData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/patients/$patientId'));
      if (response.statusCode == 200) {
        patientData = json.decode(response.body);
        notifyListeners();
      } else {
        errorMessage = 'Failed to load patient data: ${response.statusCode}';
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
      notifyListeners();
    }
  }

  void updateChartData(List<ChartData> data, double value) {
    // Desplazar todos los puntos un lugar hacia la izquierda
    for (int i = 0; i < data.length - 1; i++) {
      data[i] = ChartData(i.toDouble(), data[i + 1].y);
    }
    // Añadir el nuevo valor en la posición 8
    data[data.length - 1] = ChartData((data.length - 1).toDouble(), value);
    notifyListeners();
  }
}

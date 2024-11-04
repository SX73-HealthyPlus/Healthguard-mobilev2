import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/patient.dart';
import 'EditPatientScreen.dart';
import 'AddPatientScreen.dart'; // Importa la nueva pantalla

class PatientScreen extends StatefulWidget {
  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  List<Patient> patients = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/patients'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          patients = data.map((patient) => Patient.fromJson(patient)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load patients';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> deletePatient(int id) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:8080/api/patients/$id'));
      if (response.statusCode == 204) {
        setState(() {
          patients.removeWhere((patient) => patient.id == id);
        });
      } else {
        throw Exception('Failed to delete patient');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void refreshPatients() {
    fetchPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/patient_placeholder.png'), // Añade una imagen de placeholder en assets
              ),
              title: Text('ID: ${patients[index].id}'),
              subtitle: Text(
                'Nombre: ${patients[index].firstName} ${patients[index].lastName}\n'
                    'DNI: ${patients[index].dni}\nEdad: ${patients[index].age}\nGénero: ${patients[index].gender}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPatientScreen(patient: patients[index]),
                        ),
                      );
                      if (result == 'updated') {
                        refreshPatients(); // Refresca la lista de pacientes
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deletePatient(patients[index].id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPatientScreen()),
          );
          if (result == 'added') {
            refreshPatients(); // Refresca la lista de pacientes después de agregar uno nuevo
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

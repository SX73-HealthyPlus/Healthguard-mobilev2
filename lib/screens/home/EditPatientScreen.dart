import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/patient.dart';

class EditPatientScreen extends StatefulWidget {
  final Patient patient;

  EditPatientScreen({required this.patient});

  @override
  _EditPatientScreenState createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _dni;
  late int _age;
  late String _gender;
  late int _id;

  @override
  void initState() {
    super.initState();
    _firstName = widget.patient.firstName;
    _lastName = widget.patient.lastName;
    _dni = widget.patient.dni;
    _age = widget.patient.age;
    _gender = widget.patient.gender;
    _id = widget.patient.id; // Asegurarse de pasar el ID del paciente
  }

  Future<void> updatePatient() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Patient updatedPatient = Patient(
        id: _id, // Incluir el ID del paciente
        firstName: _firstName,
        lastName: _lastName,
        dni: _dni,
        age: _age,
        gender: _gender,
      );

      print('Updating patient with ID: $_id');
      print('Updated Patient Data: ${updatedPatient.toJson()}');

      final response = await http.put(
        Uri.parse('http://localhost:8080/api/patients/$_id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedPatient.toJson()),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        Navigator.pop(context, 'updated'); // Volver al apartado de pacientes y refrescar la lista
      } else {
        print('Failed to update patient: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to update patient');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Paciente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _firstName,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
                onSaved: (value) => _firstName = value!,
              ),
              TextFormField(
                initialValue: _lastName,
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el apellido';
                  }
                  return null;
                },
                onSaved: (value) => _lastName = value!,
              ),
              TextFormField(
                initialValue: _dni,
                decoration: InputDecoration(labelText: 'DNI'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el DNI';
                  }
                  return null;
                },
                onSaved: (value) => _dni = value!,
              ),
              TextFormField(
                initialValue: _age.toString(),
                decoration: InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese la edad';
                  }
                  return null;
                },
                onSaved: (value) => _age = int.parse(value!),
              ),
              TextFormField(
                initialValue: _gender,
                decoration: InputDecoration(labelText: 'Género'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el género';
                  }
                  return null;
                },
                onSaved: (value) => _gender = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updatePatient,
                child: Text('Actualizar Paciente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

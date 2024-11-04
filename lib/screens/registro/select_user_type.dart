import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Register.dart';

class SelectUserType extends StatefulWidget {
  @override
  _SelectUserTypeState createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  Future<List<UserType>> fetchUserTypes() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/typeofuser'));

    if (response.statusCode == 200) {
      List<dynamic> typesJson = jsonDecode(response.body);
      return typesJson.map((json) => UserType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user types');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select User Type'),
      ),
      body: FutureBuilder<List<UserType>>(
        future: fetchUserTypes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return buildUserTypes(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget buildUserTypes(List<UserType> userTypes) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: userTypes.map((type) => userTypeButton(type)).toList(),
        ),
      ),
    );
  }

  Widget userTypeButton(UserType type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Register(typeId: type.typeId)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              type.description == 'ADMIN' ? 'assets/admin.jpg' : 'assets/user.jpg',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 10),
            Text(
              type.description,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserType {
  final int typeId;
  final String description;

  UserType({required this.typeId, required this.description});

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(
      typeId: json['typeId'],
      description: json['description'],
    );
  }
}

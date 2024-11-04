import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/User.dart';

class ProfileScreen extends StatelessWidget {
  String getAccountType(String typeId) {
    switch (typeId) {
      case '1':
        return 'ADMIN';
      case '2':
        return 'USER';
      default:
        return 'UNKNOWN';
    }
  }

  void _logout(BuildContext context) {
    // Aquí iría la lógica para cerrar sesión (borrar usuario almacenado, etc.)
    UserMemory.clearUser(); // Por ejemplo, borrar la sesión del usuario
    Navigator.of(context).pushReplacementNamed('/login'); // Redirigir a la pantalla de login
  }

  @override
  Widget build(BuildContext context) {
    User? user = UserMemory.getUser();
    return user == null
        ? Center(child: Text('No se encontraron datos del usuario'))
     : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_placeholder.png'), // Añade una imagen de placeholder en assets
            ),
            SizedBox(height: 16),
            Text(
              '${user.firstName} ${user.lastName}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              user.email,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tipo de cuenta: ${getAccountType(user.typeId)}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: Icon(Icons.logout),
              label: Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 28,color: Colors.black),
              ),
            ),
          ],
        ),
    );
  }
}

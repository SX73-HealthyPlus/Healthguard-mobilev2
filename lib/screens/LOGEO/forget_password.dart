import 'package:flutter/material.dart';

import 'login.dart';


class ForgetPassword extends StatelessWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar Contraseña"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              "Ingrese su correo electrónico",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            const Divider(height: 18.0),
            TextField(
              enableInteractiveSelection: false,
              autofocus: true,
              decoration:  InputDecoration(
                hintText: "Correo electrónico",
                labelText: "Correo electrónico",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onSubmitted: (valor) {
                // Lógica para enviar el correo de recuperación
              },
            ),
            const Divider(height: 260.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: const Text("Continuar"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SmsForgetPassword()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9CD4E7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SmsForgetPassword extends StatelessWidget {
  const SmsForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar Contraseña"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              "Ingrese el código de recuperación",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            const Divider(height: 18.0),
            TextField(
              enableInteractiveSelection: false,
              autofocus: true,
              decoration:  InputDecoration(
                hintText: "Ingrese Código",
                labelText: "Ingrese Código",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onSubmitted: (valor) {
                // Lógica para validar el código
              },
            ),
            const Divider(height: 260.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: const Text("Continuar"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const NewPassword()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9CD4E7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewPassword extends StatelessWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar Contraseña"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              "Ingrese una nueva contraseña",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            const Divider(height: 18.0),
            TextField(
              enableInteractiveSelection: false,
              obscureText: true,
              decoration:  InputDecoration(
                hintText: "Ingrese Nueva Contraseña",
                labelText: "Ingrese Nueva Contraseña",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onSubmitted: (valor) {
                // Lógica para guardar la nueva contraseña
              },
            ),
            const Divider(height: 260.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: const Text("Finalizar"),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const Login()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9CD4E7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
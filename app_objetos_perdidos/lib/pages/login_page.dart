import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Seleccionar ingreso"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {
              Navigator.of(context).pushNamed("/home");
            }, child: const Text("Ingresar como usuario")),
            const SizedBox(height: 25),
            ElevatedButton(onPressed: () {
              Navigator.of(context).pushNamed("/home");
            }, child: const Text("Ingresar como administrador"))
          ],
        )
      ),
    );
  }
}

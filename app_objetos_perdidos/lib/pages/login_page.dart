
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<String?> _mostrarDialogoUsuario(BuildContext context) async {
  
    final TextEditingController idController = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Ingresar ID de Usuario'),
          content: TextField(
            controller: idController,
            decoration: const InputDecoration(hintText: "Escribe tu ID"),
            autofocus: true,
          ),
          actions: <Widget>[
       
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
             
                Navigator.of(dialogContext).pop(null);
              },
            ),
        
            TextButton(
              child: const Text('Ingresar'),
              onPressed: () {
                
                Navigator.of(dialogContext).pop(idController.text);
              },
            ),
          ],
        );
      },
    );
  }

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
            ElevatedButton(
              onPressed: () async {
              
                final String? idIngresado = await _mostrarDialogoUsuario(context);

                if (idIngresado != null && idIngresado.isNotEmpty) {
    
                  
                 
                  if (mounted) { 
                     Navigator.of(context).pushNamed("/home", arguments: idIngresado
                     );
                  }
                } 
              
              },
              child: const Text("Ingresar como usuario"),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
              
                Navigator.of(context).pushNamed("/admin_home");
              },
              child: const Text("Ingresar como administrador"),
            ),
          ],
        ),
      ),
    );
  }
}
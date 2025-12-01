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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.badge_outlined, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              const Text('Identificación'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Por favor ingresa tu nombre para continuar.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: "Nombre de usuario",
                  hintText: "Ej. Marcelo Leiva",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                ),
                autofocus: true,
                keyboardType: TextInputType.text,
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(null);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
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
    // Obtenemos el esquema de colores actual para mantener la paleta
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Bienvenido",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView( // Evita overflow en pantallas pequeñas
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //  Logo Principal
              Icon(
                Icons.account_circle,
                size: 100,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                "Selecciona tu perfil",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Ingresa según tus permisos",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 50),

              //. Botón de Usuario 
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text(
                    "Ingresar como Usuario",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // usar primary container si se quiere variar el tono
                    // backgroundColor: colorScheme.primaryContainer, 
                  ),
                  onPressed: () async {
                    final String? idIngresado = await _mostrarDialogoUsuario(context);

                    if (idIngresado != null && idIngresado.isNotEmpty) {
                      if (mounted) {
                        Navigator.of(context).pushNamed("/home", arguments: idIngresado);
                      }
                    }
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Divisor estético con texto "O"
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[400])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("O", style: TextStyle(color: Colors.grey[600])),
                  ),
                  Expanded(child: Divider(color: Colors.grey[400])),
                ],
              ),
              
              const SizedBox(height: 20),

              // Botón de Administrador 
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text(
                    "Ingresar como Administrador",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/admin_home");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
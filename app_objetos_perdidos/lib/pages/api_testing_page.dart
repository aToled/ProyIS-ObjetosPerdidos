
import 'package:app_objetos_perdidos/utils/gemini_api_manager.dart';

import 'package:flutter/material.dart';

class ApiTestingPage extends StatefulWidget {
  const ApiTestingPage({super.key});

  @override
  State<ApiTestingPage> createState() => _ApiTestingPageState();
}

class _ApiTestingPageState extends State<ApiTestingPage> {
  String _description1 = "";
  String _description2 = "";
  final ValueNotifier<String> _response = ValueNotifier("");

  final GeminiAPIManager _geminiAPIManager = GeminiAPIManager();

  void showLoadingIndicator() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(),
          ),
        );
      }
    );
  }

  void hideLoadingIndicator() {
    Navigator.of(context).pop();
  }

  void loadResponse() async {
    final prompt = '''
      Actúa como un sistema de coincidencia de objetos.
      Analiza semánticamente estas dos descripciones para ver si se refieren al mismo objeto físico.
      
      Objeto Perdido: "$_description1"
      Objeto Encontrado: "$_description2"
      
      Tu tarea: Retorna SOLAMENTE un número entero entre 0 y 100 que indique el porcentaje de similitud.
      Reglas estrictas:
      1. No escribas palabras.
      2. No uses el símbolo %.
      3. Si no hay similitud, responde 0.
      4. Solo devuelve el número.
    ''';
    showLoadingIndicator();
    final response = await _geminiAPIManager.generateResponse(prompt);
    hideLoadingIndicator();
    final textResponse = response.trim();
    
    final justNumbers = textResponse.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (justNumbers.isEmpty) {
      _response.value = "Error";
    } else {
      _response.value = "${int.parse(justNumbers)} % de coincidencia";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Gemini API"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Descripcion 1:"),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                _description1 = value;
              },
            ),
            Text("Descripcion 2:"),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                _description2 = value;
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loadResponse,
              child: Text("Generar")),
            const SizedBox(height: 20),
            Text("Respuesta:"),
            ValueListenableBuilder(
              valueListenable: _response,
              builder: (context, resp, _) {
                return Text(resp);
              }
            )
          ],
        )
      ),
    );
  }
}

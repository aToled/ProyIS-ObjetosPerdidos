import 'package:app_objetos_perdidos/utils/reports_handler.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ReportsHandler reportsHandler = ReportsHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Página de inicio"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {
              Navigator.of(context).pushNamed("/reportLostItem", arguments: reportsHandler);
            }, child: const Text("Reportar objeto perdido")),
            ElevatedButton(onPressed: () {
              Navigator.of(context).pushNamed("/listReportsAdmin", arguments: reportsHandler);
            }, child: const Text("Ver lista de reportes")),
          ],
        )
      ),
    );
  }
}

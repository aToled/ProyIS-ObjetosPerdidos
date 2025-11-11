import 'package:app_objetos_perdidos/pages/report_lost_item_page.dart';
import 'package:app_objetos_perdidos/pages/reportesBuscadorPage.dart';
import 'package:app_objetos_perdidos/utils/buscador.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final String userId = ModalRoute.of(context)!.settings.arguments as String;
    Buscador buscador = Buscador(userId);
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
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReportLostItemPage(
                      buscador: buscador,
                    ),
                  ),
                );
            }, child: const Text("Reportar objeto perdido")),
            ElevatedButton(onPressed: () {
               Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReportesBuscadorPage(
                      buscador: buscador,
                    ),
                  ),
                );
            }, child: const Text("Ver lista de reportes")),
          ],
        )
      ),
    );
  }
}

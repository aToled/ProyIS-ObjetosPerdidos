import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_objetos_perdidos/utils/reports_handler.dart';

class ListReportsAdminPage extends StatefulWidget {
  const ListReportsAdminPage({super.key});

  @override
  State<ListReportsAdminPage> createState() => _ListReportsAdminPageState();
}

class _ListReportsAdminPageState extends State<ListReportsAdminPage> {
  
  @override
  Widget build(BuildContext context) {
    final reportsHandler = ModalRoute.of(context)!.settings.arguments as ReportsHandler;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de reportes'),
      ),
      body: CupertinoScrollbar(
        child: ListView.builder(
          itemCount: reportsHandler.getReportes().length,
          itemBuilder: (context, index) {
            final reporte = reportsHandler.getReportes()[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/reportDetails", arguments: reporte);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8), // optional for rounded corners
                ),
                child: ListTile(
                  subtitle: Text(reporte.descripcion),
                ),
              )
            );
          },
        ),
      ),
    );
  }
}
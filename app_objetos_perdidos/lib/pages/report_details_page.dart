import 'package:flutter/material.dart';
import 'package:app_objetos_perdidos/utils/reporte.dart'; 

class ReportDetailsPage extends StatefulWidget {
  const ReportDetailsPage({super.key});

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final reporte = ModalRoute.of(context)!.settings.arguments as Reporte;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reporte.descripcion),
          ],
        ),
      ),
    );
  }
}
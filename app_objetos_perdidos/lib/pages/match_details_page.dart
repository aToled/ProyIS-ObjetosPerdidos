import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:app_objetos_perdidos/utils/usuario.dart';
import 'package:flutter/material.dart';
import 'package:app_objetos_perdidos/pages/report_details_page.dart';
import 'package:app_objetos_perdidos/utils/coincidencia.dart';

class MatchDetailsPage extends StatefulWidget {
  final Usuario usuario;
  final ReporteEncontrado reporteEncontrado;
  final ReportePerdido reportePerdido;
  final Coincidencia coincidencia;
  const MatchDetailsPage({super.key, required this.usuario, required this.reporteEncontrado, required this.reportePerdido, required this.coincidencia});

  @override
  State<MatchDetailsPage> createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  @override
  Widget build(BuildContext context) {
    Color porcentajeColor;
    // Aquí iría la implementación de la página de detalles de la coincidencia
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Coincidencia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<int>(
             future: widget.coincidencia.getNivelCoincidencia(),
             builder: (context, snapshot) {
              if (snapshot.connectionState ==
                ConnectionState.waiting) {
                return const SizedBox(
                  width: 70,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                );
              }

              final nivelCoincidencia = snapshot.data ?? 0;

              if (nivelCoincidencia >= 75) {
                porcentajeColor = Colors.green[800]!; // Verde oscuro
              } else if (nivelCoincidencia >= 50) {
                porcentajeColor =Colors.green[300]!; // Verde claro
              } else if (nivelCoincidencia >= 25) {
                porcentajeColor = Colors.orange; // Naranjo
              } else {
                porcentajeColor = Colors.red; // Rojo
              } 

              return Text(
                'Nivel de Coincidencia: $nivelCoincidencia%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..color = porcentajeColor,
                ),
              );
            }),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReportDetailsPage(
                      usuario: widget.usuario,
                      reporte: widget.reportePerdido,
                    ),
                  ),
                );
              },
              child: const Text('Objeto Perdido'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReportDetailsPage(
                      usuario: widget.usuario,
                      reporte: widget.reporteEncontrado,
                    ),
                  ),
                );
              },
              child: const Text('Objeto Encontrado'),
            ),
          ],),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Acción para rechazar la coincidencia
                  Navigator.of(context).pop();
                },
                child: const Text('Rechazar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  widget.reportePerdido.encontrado = true;
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
        ],),],),
      ),
    );
  }
}
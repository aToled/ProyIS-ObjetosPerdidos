import 'dart:io';

import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:app_objetos_perdidos/utils/usuario.dart';
import 'package:flutter/material.dart';
import 'package:app_objetos_perdidos/utils/coincidencia.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'dart:math' show cos, sqrt, asin;

class MatchDetailsPage extends StatefulWidget {
  final Usuario usuario;
  final ReporteEncontrado reporteEncontrado;
  final ReportePerdido reportePerdido;
  final Coincidencia coincidencia;
  const MatchDetailsPage(
      {super.key,
      required this.usuario,
      required this.reporteEncontrado,
      required this.reportePerdido,
      required this.coincidencia});

  @override
  State<MatchDetailsPage> createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final colorPorcentaje = _getColorPorPorcentaje(widget.coincidencia.nivelCoincidencia);
    final etiqueta = widget.reportePerdido.etiqueta;

    return Scaffold(
      appBar: AppBar(
        title: Text("Resolver coincidencia"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(etiqueta, colorPorcentaje),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Ubicación Aproximada",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInformacionUbicacion(context),

                  _buildVisualComparison(context),

                  const SizedBox(height: 20),

                  _buildInformacionReportes(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _mostrarDialogo(context, "Rechazado", "La coincidencia se ha descartado.");
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[400],
                      side: BorderSide(color: Colors.red.shade200),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Rechazar"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                       _mostrarDialogo(context, "¡Genial!", "Se ha notificado al usuario para coordinar la entrega.");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Aceptar"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(Etiqueta etiqueta, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      color: color.withValues(alpha: 0.1),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(etiqueta.iconData, size: 40, color: color),
          ),
          const SizedBox(height: 15),
          Text(
            "${widget.coincidencia.nivelCoincidencia} % de Similitud",
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "El sistema encontró una posible coincidencia",
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }

  Widget _buildComparativaRow(BuildContext context,
      {required IconData icon, required String titulo, required String datoIzq, required String datoDer}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(datoIzq, style: const TextStyle(fontWeight: FontWeight.w500)),
                    const Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
                    Text(datoDer, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInformacionUbicacion(BuildContext context) {
    final lugarPerdido = widget.reportePerdido.lugar;
    final lugarEncontrado = widget.reporteEncontrado.lugar;

    bool ubicacionNoDisponible = lugarPerdido.isNull() || lugarEncontrado.isNull();

    if (ubicacionNoDisponible) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off_outlined, color: Colors.grey[500]),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                "Ubicación no provista en uno de los reportes",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    } else {
      final int distanciaMetros = _calcularDistanciaMetros(
        lugarPerdido.latitud, lugarPerdido.longitud,
        lugarEncontrado.latitud, lugarEncontrado.longitud,
      );

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              "DISTANCIA ENTRE PUNTOS",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPuntoIcon(Icons.fmd_bad, "Perdido"),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "$distanciaMetros m",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.blue[900],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        height: 2,
                        color: Colors.blue[200],
                      ),
                      Text(
                        distanciaMetros < 100 ? "Cercano" : "Aprox.",
                        style: TextStyle(
                          fontSize: 10, 
                          color: distanciaMetros < 100 ? Colors.green : Colors.blue[600],
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),

                _buildPuntoIcon(Icons.check_circle, "Hallado"),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPuntoIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[300], size: 28),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.blue[300])),
      ],
    );
  }

  // Función matemática para calcular distancia (Fórmula Haversine)
  // Retorna entero redondeado en metros
  int _calcularDistanciaMetros(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295; // Math.PI / 180
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + 
            c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    
    // 12742 es el diámetro de la tierra. El resultado es en KM, multiplicamos por 1000 para metros
    double distanciaKm = 12742 * asin(sqrt(a));
    return (distanciaKm * 1000).round();
  }

  Color _getColorPorPorcentaje(int porcentaje) {
    if (porcentaje >= 80) return Colors.green[700]!;
    if (porcentaje >= 50) return Colors.orange[700]!;
    return Colors.red[700]!;
  }

  void _mostrarDialogo(BuildContext context, String titulo, String mensaje) {
      showDialog(context: context, builder: (_) => AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
      ));
  }

  Widget _buildVisualComparison(BuildContext context) {
    final String? rutaPerdido = widget.reportePerdido.imagenRuta;
    final String? rutaEncontrado = widget.reporteEncontrado.imagenRuta;

    if (rutaPerdido == null || rutaEncontrado == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Comparación Visual",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 220,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildSingleImageBox(
                  rutaImagen: rutaPerdido,
                  titulo: "Foto objeto perdido",
                  colorBase: Colors.red,
                  isLeft: true,
                ),
              ),
              Expanded(
                child: _buildSingleImageBox(
                  rutaImagen: rutaEncontrado,
                  titulo: "Foto objeto encontrado",
                  colorBase: Colors.green,
                  isLeft: false,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSingleImageBox({
    required String rutaImagen,
    required String titulo,
    required Color colorBase,
    required bool isLeft,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: isLeft ? 20 : 5,
        right: isLeft ? 5 : 20
      ),
      decoration: BoxDecoration(
        color: colorBase.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorBase.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              titulo.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colorBase,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(11)),
              child: Image.file(
                File(rutaImagen),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image_outlined, color: Colors.grey[400]),
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformacionReportes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildComparativaRow(
            context,
            icon: Icons.calendar_today,
            titulo: "Fecha",
            datoIzq: _formatDate(widget.reportePerdido.fechaPerdida),
            datoDer: _formatDate(widget.reporteEncontrado.fechaEncuentro),
          ),
          const Divider(),
          _buildComparativaRow(
            context,
            icon: Icons.location_city,
            titulo: "Campus",
            datoIzq: widget.reportePerdido.campus.visibleName,
            datoDer: widget.reporteEncontrado.campus.visibleName,
          ),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Descripción objeto perdido:", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(widget.reportePerdido.descripcion, style: TextStyle(color: Colors.grey[800])),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Descripción objeto encontrado:", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(widget.reporteEncontrado.descripcion, style: TextStyle(color: Colors.grey[800])),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


// _buildReportCard(
//   title: 'Objeto Perdido',
//   icon: Icons.person_search,
//   color: Colors.blue[700]!,
//   descripcion: widget.reportePerdido.descripcion,
//   fecha: widget.reportePerdido.fechaPerdida,
//   onTap: () {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ReportDetailsPage(
//           usuario: widget.usuario,
//           reporte: widget.reportePerdido,
//         ),
//       ),
//     );
//   },
// ),

// const SizedBox(height: 10),

// // Tarjeta de Objeto Encontrado
// _buildReportCard(
//   title: 'Objeto Encontrado',
//   icon: Icons.search,
//   color: Colors.green[700]!,
//   descripcion: widget.reporteEncontrado.descripcion,
//   fecha: widget.reporteEncontrado.fechaEncuentro,
//   onTap: () {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ReportDetailsPage(
//           usuario: widget.usuario,
//           reporte: widget.reporteEncontrado,
//         ),
//       ),
//     );
//   },
// ),

// const SizedBox(height: 40),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   children: [
//     ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.red,
//         foregroundColor: Colors.white,
//       ),
//       onPressed: () {
//         // Acción para rechazar la coincidencia
//         ReportsHandler().rechazarCoincidencia(keyCoincidencia, widget.coincidencia);
//         Navigator.of(context).pop();
//       },
//       child: const Text('Rechazar'),
//     ),
//     ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       onPressed: () {

//         widget.reportePerdido.encontrado = true;
//         widget.reporteEncontrado.encontrado=true;
//         widget.reporteEncontrado.save();
//         widget.reportePerdido.save();
//         ReportsHandler().eliminarCoincidencia(keyCoincidencia);

//         String title = "¡Objeto recuperado!";
//         String body = "Puedes pasar a retirar tu objeto perdido '[${widget.reportePerdido.etiqueta.visibleName}]: ${widget.reportePerdido.descripcion.substring(10)}${(widget.reportePerdido.descripcion.length > 10) ? "..." : ""}'";
//         NotificationsManager().showNotification(title, body);

//         Navigator.of(context).pop();
//       },
//       child: const Text('Aceptar'),
//     ),
//   ],
// ),

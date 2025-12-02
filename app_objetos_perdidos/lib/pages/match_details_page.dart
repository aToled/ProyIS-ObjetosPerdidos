import 'dart:io';

import 'package:app_objetos_perdidos/utils/notifications_manager.dart';
import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:app_objetos_perdidos/utils/reports_handler.dart';
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
    String keyCoincidencia= "${widget.reportePerdido.id}_${widget.reporteEncontrado.id}";

    return Scaffold(
      appBar: AppBar(
        title: Text("Resolver coincidencia"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
  Widget _buildReportCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required String descripcion,
    required DateTime fecha,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 20, color: color),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.open_in_new, size: 16, color: Colors.grey[400]),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(height: 1),
              ),
              Text(
                descripcion,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 15,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(fecha),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String keyCoincidencia = "${widget.reportePerdido.id}_${widget.reporteEncontrado.id}";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Análisis de Coincidencia'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
<<<<<<< HEAD
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
=======
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // future builder para el porcentaje
                  FutureBuilder<int>(
                    future: widget.coincidencia.getNivelCoincidencia(),
                    builder: (context, snapshot) {
                      
                      // 1. CARGANDO
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 100,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final nivelCoincidencia = snapshot.data ?? 0;

                    
                      // Si hay error o devuelve -1, mostramos el Wifi Off y NO el porcentaje
                      if (snapshot.hasError || nivelCoincidencia == -1) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wifi_off, size: 50, color: Colors.red[700]),
                            const SizedBox(height: 10),
                            Text(
                              'Error de conexión',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'No se pudo verificar la coincidencia',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        );
                      }

                      // si se tiene el nivel se muesta con colores con un diseño circular
                      Color porcentajeColor;
                       if (nivelCoincidencia >= 75) {
                                      porcentajeColor =
                                          Colors.green[800]!; // Verde oscuro
                                    } else if (nivelCoincidencia >= 50) {
                                      porcentajeColor =
                                          Colors.green[300]!; // Verde claro
                                    } else if (nivelCoincidencia >= 25) {
                                      porcentajeColor = Colors.orange; // Naranjo
                                    } else {
                                      porcentajeColor = Colors.red; // Rojo
                                    }

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: nivelCoincidencia / 100,
                              strokeWidth: 10,
                              backgroundColor: Colors.grey[200],
                              color: porcentajeColor,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$nivelCoincidencia%',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: porcentajeColor,
                                ),
                              ),
                              const Text(
                                "Match",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),

                  // Widgets de los reportes que son navegables a sus detalles pero tambien muestran una breve descripcion
                  
                  _buildReportCard(
                    context: context,
                    title: 'OBJETO PERDIDO',
                    icon: Icons.person_search_rounded,
                    color: Colors.blue[700]!,
                    descripcion: widget.reportePerdido.descripcion,
                    fecha: widget.reportePerdido.fechaPerdida,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReportDetailsPage(
                            usuario: widget.usuario,
                            reporte: widget.reportePerdido,
                          ),
                        ),
                      );
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Icon(Icons.link, color: Colors.grey[400], size: 30),
                  ),

                  _buildReportCard(
                    context: context,
                    title: 'OBJETO ENCONTRADO',
                    icon: Icons.check_circle_outline_rounded,
                    color: Colors.green[700]!,
                    descripcion: widget.reporteEncontrado.descripcion,
                    fecha: widget.reporteEncontrado.fechaEncuentro,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReportDetailsPage(
                            usuario: widget.usuario,
                            reporte: widget.reporteEncontrado,
                          ),
                        ),
                      );
                    },
                  ),
>>>>>>> main
                ],
              ),
            ),
          ),
<<<<<<< HEAD
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
=======

          // Botones de aceptar y rechazar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
>>>>>>> main
              ],
            ),
            child: Row(
              children: [
                Expanded(
<<<<<<< HEAD
                  child: OutlinedButton(
                    onPressed: () {
                      // Acción para rechazar la coincidencia
                      ReportsHandler().rechazarCoincidencia(keyCoincidencia, widget.coincidencia);
                      Navigator.of(context).pop();
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
                      widget.reportePerdido.encontrado = true;
                      widget.reporteEncontrado.encontrado=true;
                      ReportsHandler().saveReporteEncontradoByCopy(widget.reporteEncontrado);
                      ReportsHandler().saveReportePerdidoByCopy(widget.reportePerdido);
                      ReportsHandler().eliminarCoincidencia(keyCoincidencia);

                      String title = "¡Objeto recuperado!";
                      String body = "Puedes pasar a retirar tu objeto perdido '[${widget.reportePerdido.etiqueta.visibleName}]: ${widget.reportePerdido.descripcion.substring(0, 10)}${(widget.reportePerdido.descripcion.length > 10) ? "..." : ""}'";
                      NotificationsManager().showNotification(title, body);

                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Aceptar"),
=======
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.red[300]!),
                      foregroundColor: Colors.red[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      ReportsHandler().rechazarCoincidencia(keyCoincidencia, widget.coincidencia);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("Rechazar"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      widget.reportePerdido.encontrado = true;
                      widget.reporteEncontrado.encontrado = true;
                      widget.reporteEncontrado.save();
                      widget.reportePerdido.save();
                      ReportsHandler().eliminarCoincidencia(keyCoincidencia);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Confirmar"),
>>>>>>> main
                  ),
                ),
              ],
            ),
<<<<<<< HEAD
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
      child: FutureBuilder<int>(
        future: widget.coincidencia.getNivelCoincidencia(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
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

          final resultado = asyncSnapshot.data ?? 0;

          if (asyncSnapshot.hasError || resultado == -1) {
            return Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.wifi_off, size: 40, color: Colors.red[700]),
                ),
                const SizedBox(height: 15),
                Text(
                  "Error conexión",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            );
          }
          
          return Column(
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
          );
        }
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
=======
>>>>>>> main
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD

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
}
>>>>>>> main

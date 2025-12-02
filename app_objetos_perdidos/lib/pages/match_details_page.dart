import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:app_objetos_perdidos/utils/reports_handler.dart';
import 'package:app_objetos_perdidos/utils/usuario.dart';
import 'package:flutter/material.dart';
import 'package:app_objetos_perdidos/pages/report_details_page.dart';
import 'package:app_objetos_perdidos/utils/coincidencia.dart';

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
                ],
              ),
            ),
          ),

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
              ],
            ),
            child: Row(
              children: [
                Expanded(
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
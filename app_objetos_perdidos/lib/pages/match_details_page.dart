import 'package:app_objetos_perdidos/utils/notifications_manager.dart';
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
  // Función auxiliar para formatear fechas
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  // Widget reutilizable para mostrar las tarjetas de reporte
  Widget _buildReportCard({
    required String title,
    required IconData icon,
    required Color color,
    required String descripcion,
    required DateTime fecha,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2.0,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 24,
                color: color,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descripcion,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(fecha),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color porcentajeColor;
   String keyCoincidencia= "${widget.reportePerdido.id}_${widget.reporteEncontrado.id}"; 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Coincidencia'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<int>(
                  future: widget.coincidencia.getNivelCoincidencia(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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

                    // Validación de error (-1 o error general)
                    if (snapshot.hasError || nivelCoincidencia == -1) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wifi_off,
                              size: 50, color: Colors.red[700]),
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

                    if (nivelCoincidencia >= 75) {
                      porcentajeColor = Colors.green[800]!; // Verde oscuro
                    } else if (nivelCoincidencia >= 50) {
                      porcentajeColor = Colors.green[300]!; // Verde claro
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
              const SizedBox(height: 30),

              // Tarjeta de Objeto Perdido
              _buildReportCard(
                title: 'Objeto Perdido',
                icon: Icons.person_search,
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

              const SizedBox(height: 10),

              // Tarjeta de Objeto Encontrado
              _buildReportCard(
                title: 'Objeto Encontrado',
                icon: Icons.search,
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
                     ReportsHandler().rechazarCoincidencia(keyCoincidencia, widget.coincidencia);
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
                      widget.reporteEncontrado.encontrado=true;
                      widget.reporteEncontrado.save();
                      widget.reportePerdido.save();
                      ReportsHandler().eliminarCoincidencia(keyCoincidencia);

                      String title = "¡Objeto recuperado!";
                      String body = "Puedes pasar a retirar tu objeto perdido '[${widget.reportePerdido.etiqueta.visibleName}]: ${widget.reportePerdido.descripcion.substring(10)}${(widget.reportePerdido.descripcion.length > 10) ? "..." : ""}'";
                      NotificationsManager().showNotification(title, body);

                      Navigator.of(context).pop();
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
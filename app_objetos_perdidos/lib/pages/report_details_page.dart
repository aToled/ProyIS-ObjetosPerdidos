import 'dart:io';

import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:app_objetos_perdidos/utils/usuario.dart';
import 'package:flutter/material.dart';
import 'package:app_objetos_perdidos/utils/reporte.dart'; 

class ReportDetailsPage extends StatefulWidget {
  final Usuario usuario;
  final Reporte reporte;
  const ReportDetailsPage({super.key, required this.usuario, required this.reporte});

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  Widget _getStateAndDescriptionWidget(Reporte reporte, bool? encontrado, String formattedDateCreacion, String formattedDateEvento) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chip de estado (Encontrado / Perdido)
        
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Chip(
                  label: Text(
                    reporte.encontrado ? 'Encontrado' : 'Aún perdido',
                    style: TextStyle(
                      color: reporte.encontrado ? Colors.green[800] : Colors.orange[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: reporte.encontrado ? Colors.green.shade100 : Colors.orange.shade100,
                  avatar: Icon(
                    reporte.encontrado ? Icons.check_circle_outline : Icons.help_outline,
                    color: reporte.encontrado ? Colors.green[800] : Colors.orange[800],
                  ),
                  side: BorderSide.none,
                ),
              ),
          
          // Descripción
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(reporte.descripcion),
          ),

          // Fecha del evento (perdida o encontrado)
          ListTile(
            leading: const Icon(Icons.event_outlined),
            title: Text(
              encontrado == null ? 'Fecha de encuentro' : (encontrado ? 'Fecha de encuentro' : 'Fecha de pérdida'),
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
            subtitle: Text(formattedDateEvento),
          ),

          // Fecha de creación del reporte
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Fecha del reporte', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(formattedDateCreacion),
          ),
        ],
      ),
    );
  }

  Widget _getLocationWidget(Reporte reporte, bool locationAvailable, bool lugarEspecificoIngresado) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              'Ubicación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Campus'),
            subtitle: Text(reporte.campus.visibleName),
          ),
          if (locationAvailable)
            ListTile(
              leading: const Icon(Icons.map_outlined),
              title: const Text('Lugar'),
              subtitle: Text('Lat: ${reporte.lugar.latitud}, Lng: ${reporte.lugar.longitud}'),
            ),
          if(lugarEspecificoIngresado)
          ListTile(
              leading: const Icon(Icons.map_outlined),
              title: const Text('Lugar Específico'),
              subtitle: Text(reporte.lugarEspecifico ?? ''),
            ),
        ],
      ),
    );
  }

  Widget _getPictureWidget(Reporte reporte) {
    if (reporte.imagenRuta == null || reporte.imagenRuta!.isEmpty) {
      return const SizedBox();
    }

    if (!File(reporte.imagenRuta!).existsSync()) {
      return const SizedBox();
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              'Imagen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          reporte.getImagenWidget()
        ],
      ),
    );
  }

  Widget _getContactWidget(Reporte reporte) {
    ReportePerdido? reportePerdido;
    if (reporte is ReportePerdido) {
      reportePerdido = reporte;
    } else {
      return const SizedBox();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              'Contacto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Nombre'),
            subtitle: Text(reportePerdido.creadorId),
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Correo'),
            subtitle: Text(reportePerdido.correo),
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: const Text('Teléfono'),
            subtitle: Text(reportePerdido.numTel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDateCreacion = "${widget.reporte.fechaCreacion.day}/${widget.reporte.fechaCreacion.month}/${widget.reporte.fechaCreacion.year}";
    
    String formattedDateEvento;
    if (widget.reporte is ReportePerdido) {
      final reportePerdido = widget.reporte as ReportePerdido;
      formattedDateEvento = "${reportePerdido.fechaPerdida.day}/${reportePerdido.fechaPerdida.month}/${reportePerdido.fechaPerdida.year}";
    } else if (widget.reporte is ReporteEncontrado) {
      final reporteEncontrado = widget.reporte as ReporteEncontrado;
      formattedDateEvento = "${reporteEncontrado.fechaEncuentro.day}/${reporteEncontrado.fechaEncuentro.month}/${reporteEncontrado.fechaEncuentro.year}";
    } else {
      formattedDateEvento = formattedDateCreacion;
    }
    
    final String etiquetaNombre = widget.reporte.etiqueta.visibleName;
    final bool locationAvailable = !widget.reporte.lugar.isNull();
    final bool lugarEspecificoIngresado = widget.reporte.lugarEspecifico != null && widget.reporte.lugarEspecifico!.isNotEmpty;

    bool? encontrado =
      (widget.reporte is ReportePerdido) ? (widget.reporte as ReportePerdido).encontrado : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(etiquetaNombre), // Título dinámico
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Tarjeta 1: Estado y Descripción ---
              _getStateAndDescriptionWidget(widget.reporte, encontrado, formattedDateCreacion, formattedDateEvento),
              // --- Tarjeta 2: Detalles de Ubicación ---
              _getLocationWidget(widget.reporte, locationAvailable, lugarEspecificoIngresado),

              // --- Tarjeta 3: Imagen del objeto ---
              // --- Tarjeta 3: Imagen del objeto ---
              _getPictureWidget(widget.reporte),

              // --- Tarjeta 4: Información de Contacto ---
              _getContactWidget(widget.reporte),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ElevatedButton(
                  onPressed: () => _mostrarDialogoConfirmacion(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.delete),
                      const SizedBox(width: 15),
                      const Text("Eliminar reporte"),
                    ],
                  )),
              )
            ],
          ),
        ),
      ),
    );
  }
  void _mostrarDialogoConfirmacion(BuildContext context) async {
    final bool? confirmado = await showDialog<bool>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este reporte?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmado == true) {
      widget.usuario.deleteReporte(widget.reporte);
  
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reporte eliminado exitosamente.'),
            backgroundColor: Colors.green, 
            duration: Duration(seconds: 2),
          ),
        );
       Navigator.of(context).pop(); 
      }
    }
  }
}

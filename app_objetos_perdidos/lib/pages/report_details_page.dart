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
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reporte ID: ${widget.reporte.id}"),
            Text("ID Creador Reporte: ${widget.reporte.creadorId}"),
            Text("Etiqueta: ${widget.reporte.etiqueta}"),
             Text("Descripción: ${widget.reporte.descripcion}"),
             Text("Campus: ${widget.reporte.campus}"),
            Text("Lugar (coordenadas): ${widget.reporte.lugar}"),
            Text("Fecha: ${widget.reporte.fecha}"),
            ElevatedButton.icon(
          icon: const Icon(Icons.delete_forever),
          label: const Text('Eliminar Reporte'),
          onPressed: () {
            _mostrarDialogoConfirmacion(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, 
            foregroundColor: Colors.white,
          ),
        ),


          ],
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
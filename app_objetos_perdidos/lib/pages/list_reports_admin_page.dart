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
        title: const Text('Lista de reportes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: CupertinoScrollbar(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: reportsHandler.getReportes().length,
          itemBuilder: (context, index) {
            final reporte = reportsHandler.getReportes()[index];

            // --- Formateo de datos ---

            // 1. Formateo de Fecha
            final String formattedDate = "${reporte.fecha.day}/${reporte.fecha.month}/${reporte.fecha.year}";

            // 2. Nombre del Campus
            final String campusName = reporte.campus.visibleName;

            // 3. Texto de la Etiqueta 
            final String etiquetaNombre = reporte.etiqueta.visibleName;

            return Card(
              // Margen para separar las tarjetas
              margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                
                // 1. Icono a la izquierda (Leading)
                leading: Icon(
                  Icons.label_outline, 
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),

                // 2. Título principal
                title: Text(
                  etiquetaNombre,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                // 3. Subtítulo (con más detalles)
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      reporte.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$campusName - $formattedDate',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),

                // 4. Icono a la derecha (Trailing)
                trailing: Icon(
                  reporte.encontrado ? Icons.check_circle : Icons.help_outline,
                  color: reporte.encontrado ? Colors.green : Colors.orange,
                  size: 28,
                ),

                // 5. Acción al tocar
                onTap: () {
                  Navigator.of(context).pushNamed("/reportDetails", arguments: reporte);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:app_objetos_perdidos/pages/report_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_objetos_perdidos/utils/administrador.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';

class ListReportsEncontradosAdminPage extends StatefulWidget {
  const ListReportsEncontradosAdminPage({super.key});

  @override
  State<ListReportsEncontradosAdminPage> createState() => _ListReportsEncontradosAdminPage();
}

class _ListReportsEncontradosAdminPage extends State<ListReportsEncontradosAdminPage> {
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final admin = ModalRoute.of(context)!.settings.arguments as Administrador;
    final reportList = admin.getReportesEncontrados();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Reportes'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: CupertinoScrollbar(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          itemCount: reportList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          
          itemBuilder: (context, index) {
            final reporte = reportList[index];

            final String formattedDate = _formatDate(reporte.fechaEncuentro) ;
            final String campusName = reporte.campus.visibleName;
            final Etiqueta etiqueta = reporte.etiqueta;
            final String etiquetaNombre = reporte.etiqueta.visibleName;
            
            final IconData leadingIcon = etiqueta.iconData;

            final statusChip = Chip(
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
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0),
              labelPadding: const EdgeInsets.only(left: 4.0, right: 2.0),
            );

            return Card(
              elevation: 2.0,
              shadowColor: Colors.black.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReportDetailsPage(
                        usuario: admin,
                        reporte: reporte,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Icono dinámico (CircleAvatar)
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.5),
                        child: Icon(
                          leadingIcon,
                          color: colorScheme.onPrimaryContainer,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // 2. Contenido principal (Título, Descripción, Metadatos)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título (Etiqueta)
                            Text(
                              etiquetaNombre,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            
                            // Descripción
                            Text(
                              reporte.descripcion,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Metadatos (Campus y Fecha)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Fila para el Campus
                                Row(
                                  children: [
                                    Icon(Icons.school_outlined, size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    // Usamos Expanded para que ocupe el espacio y corte con '...'
                                    // solo si el nombre es más largo que la tarjeta misma.
                                    Expanded(
                                      child: Text(
                                        campusName,
                                        style: textTheme.bodySmall,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4), // Pequeño espacio entre líneas
                                
                                // Fila para la Fecha
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      formattedDate,
                                      style: textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // 3. Chip de Estado
                      statusChip,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:app_objetos_perdidos/utils/reporte.dart';
import 'package:url_launcher/url_launcher.dart'; 

class ReportDetailsPage extends StatefulWidget {
  const ReportDetailsPage({super.key});

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  // --- Métodos de ayuda para 'url_launcher' ---

  // Abre la app de mapas con las coordenadas
  Future<void> _launchMaps(double lat, double lon) async {
    final Uri mapUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (await canLaunchUrl(mapUri)) {
      await launchUrl(mapUri);
    } else {
      print('No se pudo abrir el mapa.');
    }
  }

  // Abre la app de teléfono
  Future<void> _launchCall(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Teléfono no válido'),
        action: SnackBarAction(
          label: 'Quitar',
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
        ),
      ));
    }
  }

  // Abre la app de correo
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Mail no válido'),
        action: SnackBarAction(
          label: 'Quitar',
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final reporte = ModalRoute.of(context)!.settings.arguments as Reporte;
    final String formattedDate = "${reporte.fecha.day}/${reporte.fecha.month}/${reporte.fecha.year}";
    final String etiquetaNombre = reporte.etiqueta.visibleName;
    final bool locationAvailable = !reporte.lugar.isNull();

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
              Card(
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

                    // Fecha
                    ListTile(
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: const Text('Fecha del reporte', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(formattedDate),
                    ),
                  ],
                ),
              ),

              // --- Tarjeta 2: Detalles de Ubicación ---
              Card(
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
                      subtitle: Text(reporte.campus.visibleName), // Asume enum .name
                    ),
                    Opacity(
                      opacity: locationAvailable ? 1.0 : 0.0,
                      child: ListTile(
                        leading: const Icon(Icons.map_outlined),
                        title: const Text('Lugar Específico'),
                        subtitle: const Text('Tocar para ver en el mapa'),
                        trailing: const Icon(Icons.open_in_new, size: 20),
                        onTap: () {
                          if (!locationAvailable) {
                            return;
                          }
                          // Llama al método para abrir Google Maps
                          _launchMaps(reporte.lugar.latitud, reporte.lugar.longitud);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // --- Tarjeta 3: Información de Contacto ---
              Card(
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
                      leading: const Icon(Icons.email_outlined),
                      title: const Text('Correo'),
                      subtitle: Text(reporte.correo),
                      trailing: const Icon(Icons.launch, size: 20),
                      onTap: () {
                        // Llama al método para abrir app de email
                        _launchEmail(reporte.correo);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone_outlined),
                      title: const Text('Teléfono'),
                      subtitle: Text(reporte.numTel),
                      trailing: const Icon(Icons.launch, size: 20),
                      onTap: () {
                        // Llama al método para abrir app de teléfono
                        _launchCall(reporte.numTel);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

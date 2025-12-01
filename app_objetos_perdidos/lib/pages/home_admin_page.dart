import 'package:app_objetos_perdidos/pages/report_found_item.dart';
import 'package:app_objetos_perdidos/utils/administrador.dart';
import 'package:flutter/material.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  late Administrador admin;

  @override
  void initState() {
    super.initState();
    admin = Administrador();
  }

  // Widget auxiliar para crear las tarjetas del menú y evitar repetir código
  Widget _buildAdminOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimaryAction = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: isPrimaryAction ? 4 : 1,
      margin: const EdgeInsets.only(bottom: 16),
      // Si es la acción principal, le damos un color suave de fondo, si no, blanco/surface
      color: isPrimaryAction ? colorScheme.primaryContainer : colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isPrimaryAction 
                      ? colorScheme.primary 
                      : colorScheme.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isPrimaryAction 
                      ? colorScheme.onPrimary 
                      : colorScheme.primary,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // Fondo limpio
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Panel de Administración"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de bienvenida
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0, left: 4),
              child: Text(
                "Gestión de Objetos",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 1. Acción Principal (Destacada)
            _buildAdminOption(
              context: context,
              title: "Reportar Hallazgo",
              subtitle: "Registrar un objeto encontrado en custodia",
              icon: Icons.add_location_alt_outlined,
              isPrimaryAction: true, // Esto la hace resaltar
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReportFoundItemPage(
                      admin: admin,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 20),
            
            // Subtítulo de listas
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, left: 4),
              child: Text(
                "Base de Datos",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),

            // 2. Ver Perdidos
            _buildAdminOption(
              context: context,
              title: "Objetos Perdidos",
              subtitle: "Ver reportes de usuarios",
              icon: Icons.search_off,
              onTap: () {
                Navigator.of(context).pushNamed("/listReportesPerdidosAdmin", arguments: admin);
              },
            ),

            // 3. Ver Encontrados
            _buildAdminOption(
              context: context,
              title: "Objetos Encontrados",
              subtitle: "Inventario en custodia",
              icon: Icons.check_circle_outline,
              onTap: () {
                Navigator.of(context).pushNamed("/listReportesEncontradosAdmin", arguments: admin);
              },
            ),

            // 4. Ver Coincidencias
            _buildAdminOption(
              context: context,
              title: "Coincidencias (Match)",
              subtitle: "Analizar posibles entregas",
              icon: Icons.compare_arrows_rounded,
              onTap: () {
                Navigator.of(context).pushNamed("/listCoincidencias", arguments: admin);
              },
            ),
          ],
        ),
      ),
    );
  }
}
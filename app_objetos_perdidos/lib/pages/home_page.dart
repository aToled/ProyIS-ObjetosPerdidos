import 'package:app_objetos_perdidos/pages/report_lost_item_page.dart';
import 'package:app_objetos_perdidos/pages/reportesBuscadorPage.dart';
import 'package:app_objetos_perdidos/utils/buscador.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Widget  para las tarjetas
  Widget _buildHomeCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
    bool isUrgent = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: isUrgent ? 4 : 2,
      shadowColor: isUrgent ? colorScheme.shadow.withOpacity(0.4) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // Si es urgente (reportar), usamos un color más destacado pero suave 
      color: isUrgent ? colorScheme.primaryContainer : colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isUrgent ? colorScheme.primary : colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isUrgent ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ID y creamos el buscador 
    final String userId = ModalRoute.of(context)!.settings.arguments as String;
    Buscador buscador = Buscador(userId);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // Fondo limpio
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        title: const Text("Objetos Perdidos UdeC"), // Título 
        centerTitle: true,
        actions: [
          // Un icono de perfil estético 
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text(
                userId.isNotEmpty ? userId[0].toUpperCase() : "U",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de Bienvenida
              Text(
                "Hola, $userId",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "¿Perdiste algo en el campus? Estamos para ayudarte a encontrarlo.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 40),

              // Opción Reportar (Destacada)
              _buildHomeCard(
                context: context,
                title: "Reportar Objeto Perdido",
                description: "Completa el formulario para que podamos buscar tu objeto.",
                icon: Icons.search_off_rounded, // Icono de 'no encontrado'
                isUrgent: true, // Esto le da el color de énfasis
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReportLostItemPage(
                        buscador: buscador,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Opción Ver mis reportes
              _buildHomeCard(
                context: context,
                title: "Mis Reportes",
                description: "Revisa el estado de tus objetos reportados anteriormente.",
                icon: Icons.receipt_long_rounded, // Icono de lista
                isUrgent: false,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReportesBuscadorPage(
                        buscador: buscador,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              // Pie de página informativo (Decorativo)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[400], size: 20),
                    const SizedBox(height: 8),
                    Text(
                      "Si encuentras un objeto, busca a un administrador en la facultad más cercana.",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
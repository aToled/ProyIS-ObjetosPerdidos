import 'package:app_objetos_perdidos/utils/administrador.dart';
import 'package:app_objetos_perdidos/utils/coincidencia.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_objetos_perdidos/pages/match_details_page.dart';

class ListCoincidenciasPage extends StatefulWidget {
  const ListCoincidenciasPage({super.key});

  @override
  State<ListCoincidenciasPage> createState() => _ListCoincidenciasPageState();
}

class _ListCoincidenciasPageState extends State<ListCoincidenciasPage> {
  // Ahora la lista guarda el objeto y un estado de "nivel" que puede ser nulo (cargando)
  List<Map<String, dynamic>> _listaVisual = [];
  bool _datosCargados = false;
  late Administrador _admin;

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_datosCargados) {
      try {
        _admin = ModalRoute.of(context)!.settings.arguments as Administrador;
        _iniciarCarga(_admin);
        _datosCargados = true;
      } catch (e) {
        debugPrint("Error argumentos: $e");
      }
    }
  }

  // Mostrar lo que tenemos localmente 
  void _iniciarCarga(Administrador admin) {
    final rawList = admin.getCoincidencias();

    // Creamos la lista visual INMEDIATAMENTE con nivel null mientras carga
    final listaInicial = rawList.map((c) {
      return <String, dynamic>{ 
  'coincidencia': c,
  'nivel': null, 
};
    }).toList();

   
    if (mounted) {
      setState(() {
        _listaVisual = listaInicial;
      });
    }

    // PASO 2: Llamar a la API en segundo plano
    _calcularPorcentajesBackground();
  }

  // PASO 2: Lógica asíncrona que no bloquea la UI
  Future<void> _calcularPorcentajesBackground() async {
    // Recorremos la lista que ya estamos mostrando
    for (int i = 0; i < _listaVisual.length; i++) {
      final item = _listaVisual[i];
      final coincidencia = item['coincidencia'] as Coincidencia;

      try {
        // Llamada a la API 
        int nivel = await coincidencia.getNivelCoincidencia();
        
        // Actualizamos SOLO este item si el widget sigue vivo
        if (mounted) {
          setState(() {
            _listaVisual[i]['nivel'] = nivel;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _listaVisual[i]['nivel'] = -1; // Error
          });
        }
      }
    }

    // Reordenar por porcentaje una vez que terminamos todo
    if (mounted) {
      setState(() {
        _listaVisual.sort((a, b) {
          // Ponemos los nulls o errores al final
          int nivelA = a['nivel'] ?? -1;
          int nivelB = b['nivel'] ?? -1;
          return nivelB.compareTo(nivelA);
        });
      });
    }
  }

  Future<void> _onRefresh() async {
    // Al refrescar, reiniciamos el proceso
    _iniciarCarga(_admin);
    // Esperamos un poco para que se vea la animación, o esperamos al proceso completo
    await _calcularPorcentajesBackground();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Coincidencias'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _listaVisual.isEmpty
            // Caso sin no hay coincidencias locales
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No hay coincidencias',
                            style: textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
              )
            //  si Hay coincidencias (mostramos la lista aunque los % estén cargando)
            : CupertinoScrollbar(
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  itemCount: _listaVisual.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = _listaVisual[index];
                    final coincidencia = item['coincidencia'] as Coincidencia;
                    
                    // Aquí el nivel puede ser null (si está cargando)
                    final int? nivelCoincidencia = item['nivel'];
                    
                    final reportePerdido = coincidencia.reportePerdido;
                    final reporteEncontrado = coincidencia.reporteEncontrado;

                    final String fechaPerdido =
                        _formatDate(reportePerdido.fechaPerdida);
                    final String fechaEncontrado =
                        _formatDate(reporteEncontrado.fechaEncuentro);
                    final String campusName =
                        reportePerdido.campus.visibleName;
                    final Etiqueta etiqueta = reportePerdido.etiqueta;
                    final String etiquetaNombre = etiqueta.visibleName;
                    final IconData leadingIcon = etiqueta.iconData;

                    // Lógica visual del porcentaje
                    Widget porcentajeWidget;
                    
                    if (nivelCoincidencia == null) {
                      //  CARGANDO
                      porcentajeWidget = SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      );
                    } else if (nivelCoincidencia == -1) {
                      // ERROR
                      porcentajeWidget = Column(
                        children: [
                          Icon(Icons.wifi_off, size: 20, color: Colors.red[700]),
                          Text("Error",
                              style: textTheme.bodySmall?.copyWith(
                                  fontSize: 10, color: Colors.red[700])),
                        ],
                      );
                    } else {
                      //  mostrar nivel de coindicencia con el color indicado
                      Color color;
                      if (nivelCoincidencia >= 75) color = Colors.green[800]!;
                      else if (nivelCoincidencia >= 50) color = Colors.green[300]!;
                      else if (nivelCoincidencia >= 25) color = Colors.orange;
                      else color = Colors.red;

                      porcentajeWidget = Text(
                        '$nivelCoincidencia%',
                        style: textTheme.titleMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }

                    // Contenedor decorativo del porcentaje
                    Widget badgeContainer = Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: (nivelCoincidencia != null && nivelCoincidencia > 0)
                            ? (nivelCoincidencia >= 50 ? Colors.green : Colors.orange).withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      child: porcentajeWidget,
                    );

                    return InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MatchDetailsPage(
                              usuario: _admin,
                              reporteEncontrado: reporteEncontrado,
                              reportePerdido: reportePerdido,
                              coincidencia: coincidencia,
                            ),
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Card(
                        elevation: 2.0,
                        shadowColor: Colors.black.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: colorScheme
                                        .primaryContainer
                                        .withValues(alpha: 0.5),
                                    child: Icon(
                                      leadingIcon,
                                      color: colorScheme.onPrimaryContainer,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          etiquetaNombre,
                                          style: textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.school_outlined,
                                                size: 14,
                                                color: Colors.grey[600]),
                                            const SizedBox(width: 4),
                                            Text(campusName,
                                                style: textTheme.bodySmall),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // AQUÍ VA EL WIDGET QUE CAMBIA (Spinner o Numero)
                                  badgeContainer,
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 12),
                              // ... (Resto de tus filas de Objetos Perdido/Encontrado igual que antes)
                              _buildInfoRow(
                                  context,
                                  'Objeto Perdido',
                                  reportePerdido.descripcion,
                                  fechaPerdido,
                                  Icons.person_search,
                                  Colors.blue[700]!),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                  context,
                                  'Objeto Encontrado',
                                  reporteEncontrado.descripcion,
                                  fechaEncontrado,
                                  Icons.search,
                                  Colors.green[700]!),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  // Helper para limpiar el código del build
  Widget _buildInfoRow(BuildContext context, String title, String desc,
      String date, IconData icon, Color color) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(desc,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(date, style: textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
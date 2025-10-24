import 'package:app_objetos_perdidos/pages/map_page.dart';
import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:app_objetos_perdidos/utils/reporte.dart';
import 'package:app_objetos_perdidos/utils/reports_handler.dart';
import 'package:flutter/material.dart';

class ReportLostItemPage extends StatefulWidget {
  const ReportLostItemPage({super.key});

  @override
  State<ReportLostItemPage> createState() => _ReportLostItemPageState();
}

class _ReportLostItemPageState extends State<ReportLostItemPage> {
  bool _isReportsHandlerLoaded = false;
  late ReportsHandler _reportsHandler;

  final _formKey = GlobalKey<FormState>();

  List<Campus> campusOptions = Campus.values;
  final Lugar _lugar = Lugar(0, 0, 100);
  Campus _campus = Campus.concepcion;
  final _numTelController = TextEditingController();
  final _correoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final ValueNotifier<Etiqueta> _etiqueta = ValueNotifier(Etiqueta.otro);
  
  String _getStringFromLabel(Etiqueta label) {
    switch(label) {
      case Etiqueta.celular: return "Celular";
      case Etiqueta.llaves: return "Llaves";
      case Etiqueta.cartera: return "Cartera";
      case Etiqueta.billetera: return "Billetera";
      case Etiqueta.utiles: return "Útiles";
      case Etiqueta.documento: return "Documento";
      case Etiqueta.lentes: return "Lentes";
      case Etiqueta.botella: return "Botella";
      case Etiqueta.otro: return "Otro";
    }
  }

  String _getStringFromCampus(Campus campus) {
    switch (campus) {
      case Campus.concepcion: return "Concepción";
      case Campus.losAngeles: return "Los Ángeles";
      case Campus.chillan: return "Chillán";
    }
  }

  void placeCallback(double lat, double lng) {
    _lugar.latitud = lat;
    _lugar.longitud = lng;
  }

  Widget _getCampusWidget() {
    return DropdownButtonFormField<Campus>(
      value: _campus,
      decoration: InputDecoration(
        labelText: 'Campus',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      items: Campus.values.map<DropdownMenuItem<Campus>>((Campus value) {
        return DropdownMenuItem<Campus>(
          value: value,
          child: Text(_getStringFromCampus(value)),
        );
      }).toList(),
      onChanged: (Campus? newValue) {
        if (newValue == null) {
          return;
        }
        setState(() {
          _campus = newValue;
        });
      },
    );
  }

  Widget _getMapWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.map_outlined),
          onPressed: () {
            Navigator.of(context).pushNamed("/map", arguments: ReportMapScreenArgs(placeCallback, _campus));
          },
          label: const Text("Seleccionar lugar en mapa"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        Text(
          "* Opcional",
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }

  Widget _getPhoneWidget() {
    return TextFormField(
      controller: _numTelController,
      decoration: InputDecoration(
        labelText: 'Número de Teléfono (Contacto)',
        prefixIcon: Icon(Icons.phone),
        hintText: "Ej: 912345678",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa un número de teléfono';
        }
        final phoneRegex = RegExp(r'^\d{9}$');
        
        if (!phoneRegex.hasMatch(value)) {
          return 'Ingresa un número de 9 dígitos';
        }
        
        return null;
      },
    );
  }

  Widget _getEmailWidget() {
    return TextFormField(
      controller: _correoController,
      decoration: InputDecoration(
        labelText: 'Correo Electrónico (Contacto)',
        prefixIcon: Icon(Icons.email),
        hintText: "Ej: correo@mail.com",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa un correo';
        }
        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        
        if (!emailRegex.hasMatch(value)) {
          return 'Por favor, ingresa un correo válido';
        }
        
        return null;
      },
    );
  }

  Widget _getDescriptionWidget() {
    return TextFormField(
      controller: _descripcionController,
      decoration: InputDecoration(
        labelText: 'Descripción del objeto',
        hintText: "Color, material, marca, detalles únicos...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignLabelWithHint: true,
      ),
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa una descripción';
        }
        
        return null;
      },
      minLines: 4,
      maxLines: 8,
    );
  }

  Widget _getLabelWidget() {
    return ValueListenableBuilder(
      valueListenable: _etiqueta,
      builder: (context, etiqueta, child) {
        return DropdownButtonFormField<Etiqueta>(
          value: etiqueta,
          decoration: InputDecoration(
            labelText: 'Categoría del Objeto',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          items: Etiqueta.values.map<DropdownMenuItem<Etiqueta>>((Etiqueta value) {
            return DropdownMenuItem<Etiqueta>(
              value: value,
              child: Text(
                _getStringFromLabel(value)
              ),
            );
          }).toList(),
          onChanged: (Etiqueta? newValue) {
            if (newValue == null) {
              return;
            }
            _etiqueta.value = newValue;
          },
        );
      }
    );
  }

  Widget _getCreateReportWidget() {
    return SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Por favor, corrige los errores')),
            );
            return;
          }

          Reporte reporte = Reporte(
            DateTime.now(),
            _lugar,
            _campus,
            _numTelController.text,
            _correoController.text,
            _descripcionController.text,
            _etiqueta.value
          );

          _reportsHandler.addReport(reporte);

          Navigator.of(context).pop();
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: const Text("Reporte enviado"),
              content: const Text("El reporte ha sido enviado con éxito"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: const Text("Aceptar"))
              ]
            );
          });
        }, 
        child: const Text("Enviar reporte")
      ),
    );
  }

  @override
  void dispose() {
    _numTelController.dispose();
    _correoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReportsHandlerLoaded) {
      _reportsHandler = ModalRoute.of(context)!.settings.arguments as ReportsHandler;
      _isReportsHandlerLoaded = true;
    }
    
    for (Reporte reporte in _reportsHandler.getReportes()) {
      print("-------------------");
      print("${reporte.id} / ${reporte.numTel} / ${reporte.correo}");
      print(reporte.fecha);
      print(reporte.descripcion);
    }
    print("-------------------");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Reportar objeto perdido"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _getCampusWidget(),
                const SizedBox(height: 16),
                _getMapWidget(),
                const SizedBox(height: 16),
                _getLabelWidget(),
                const SizedBox(height: 16),
                _getDescriptionWidget(),
                const SizedBox(height: 24),
                Text(
                  "Información de Contacto",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _getPhoneWidget(),
                const SizedBox(height: 16),
                _getEmailWidget(),
                const SizedBox(height: 24),
                _getCreateReportWidget()
              ],
            ),
          ),
        ),
      )
    );
  }
}

//   String _getStringFromLabel(Etiqueta label) {
//     switch(label) {
//       case Etiqueta.celular: return "Celular";
//       case Etiqueta.llaves: return "Llaves";
//       case Etiqueta.cartera: return "Cartera";
//       case Etiqueta.billetera: return "Billetera";
//       case Etiqueta.documento: return "Documento";
//       case Etiqueta.lentes: return "Llentes";
//       case Etiqueta.botella: return "Botella";
//       case Etiqueta.otro: return "Otro";
//     }
//   }

//   void placeCallback(double lat, double lng) {
//     _lugar.latitud = lat;
//     _lugar.longitud = lng;
//   }

//   Widget _getCampusWidget() {
//     return DropdownButton<Campus>(
//       value: _campus,
//       items: Campus.values.map<DropdownMenuItem<Campus>>((Campus value) {
//         return DropdownMenuItem<Campus>(
//           value: value,
//           child: Text(
//             (value == Campus.concepcion) ? "Concepcion" : (value == Campus.losAngeles) ? "Los angeles" : "Chillan"
//           ),
//         );
//       }).toList(),
//       onChanged: (Campus? newValue) {
//         if (newValue == null) {
//           return;
//         }
//         _campus = newValue;
//       },
//     );
//   }

//   Widget _getMapWidget() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).pushNamed("/map", arguments: ReportMapScreenArgs(placeCallback, _campus));
//           },
//           child: Text("Seleccionar lugar"),
//         ),
//         const SizedBox(width: 10),
//         const Text("*opcional")
//       ],
//     );
//   }

//   Widget _getPhoneWidget() {
//     return SizedBox(
//       width: 300,
//       child: TextFormField(
//         controller: _numTelController,
//         decoration: InputDecoration(
//           labelText: 'Número de Teléfono',
//           icon: Icon(Icons.phone),
//           hintText: "Ej: 912345678"
//         ),
//         keyboardType: TextInputType.phone,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Por favor, ingresa un número de teléfono';
//           }
//           final phoneRegex = RegExp(r'^\d{9}$');
          
//           if (!phoneRegex.hasMatch(value)) {
//             return 'Ingresa un número de 9 dígitos';
//           }
          
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _getEmailWidget() {
//     return SizedBox(
//       width: 300,
//       child: TextFormField(
//         controller: _correoController,
//         decoration: InputDecoration(
//           labelText: 'Correo Electrónico',
//           icon: Icon(Icons.email),
//           hintText: "Ej: correo@mail.com"
//         ),
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Por favor, ingresa un correo';
//           }
//           final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
          
//           if (!emailRegex.hasMatch(value)) {
//             return 'Por favor, ingresa un correo válido';
//           }
          
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _getDescriptionWidget() {
//     return SizedBox(
//       width: 300,
//       child: TextFormField(
//         controller: _descripcionController,
//         decoration: InputDecoration(
//           labelText: 'Descripción del objeto',
//           hintText: "Color | material | textura | forma | tamaño | marca | detalles",
//           border: OutlineInputBorder()
//         ),
//         keyboardType: TextInputType.multiline,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Por favor, ingresa una descripción';
//           }
          
//           return null;
//         },
//         minLines: 5,
//         maxLines: null,
//       ),
//     );
//   }

//   Widget _getLabelWidget() {
//     return ValueListenableBuilder(
//       valueListenable: _etiqueta,
//       builder: (context, etiqueta, child) {
//         return DropdownButton<Etiqueta>(
//           value: etiqueta,
//           items: Etiqueta.values.map<DropdownMenuItem<Etiqueta>>((Etiqueta value) {
//             return DropdownMenuItem<Etiqueta>(
//               value: value,
//               child: Text(
//                 _getStringFromLabel(value)
//               ),
//             );
//           }).toList(),
//           onChanged: (Etiqueta? newValue) {
//             if (newValue == null) {
//               return;
//             }
//             _etiqueta.value = newValue;
//           },
//         );
//       }
//     );
//   }

//   Widget _getCreateReportWidget() {
//     return ElevatedButton(
//       onPressed: () {
//         if (!_formKey.currentState!.validate()) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Por favor, corrige los errores')),
//           );

//           return;
//         }

//         Reporte reporte = Reporte(
//           DateTime.now(),
//           _lugar,
//           _campus,
//           _numTelController.text,
//           _correoController.text,
//           _descripcionController.text,
//           _etiqueta.value
//         );

//         _reportsHandler.addReport(reporte);

//         Navigator.of(context).pop();
//         showDialog(context: context, builder: (context) {
//           return AlertDialog(
//             title: const Text("Reporte enviado"),
//             content: const Text("El reporte ha sido enviado con éxito"),
//             actions: [
//               TextButton(onPressed: () {
//                 Navigator.of(context).pop();
//               }, child: const Text("Aceptar"))
//             ]
//           );
//         });
//       }, child: const Text("Enviar reporte")
//     );
//   }

//   @override
//   void dispose() {
//     _numTelController.dispose();
//     _correoController.dispose();
//     _descripcionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isReportsHandlerLoaded) {
//       _reportsHandler = ModalRoute.of(context)!.settings.arguments as ReportsHandler;
//       _isReportsHandlerLoaded = true;
//     }
    
//     for (Reporte reporte in _reportsHandler.getReportes()) {
//       print("-------------------");
//       print("${reporte.id} / ${reporte.numTel} / ${reporte.correo}");
//       print(reporte.fecha);
//       print(reporte.descripcion);
//     }
//     print("-------------------");

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text("Reportar objeto perdido"),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 // Campus
//                 Text("Campus:"),
//                 const SizedBox(height: 8),
//                 _getCampusWidget(),
//                 const SizedBox(height: 12),
//                 _getMapWidget(),
//                 const SizedBox(height: 12),
//                 _getPhoneWidget(),
//                 const SizedBox(height: 12),
//                 _getEmailWidget(),
//                 const SizedBox(height: 12),
//                 // Descripción
//                 Text("Descripción del objeto:"),
//                 const SizedBox(height: 8),
//                 _getDescriptionWidget(),
//                 const SizedBox(height: 12),
//                 Text("Etiqueta:"),
//                 const SizedBox(height: 8),
//                 _getLabelWidget(),
//                 const SizedBox(height: 12),
//                 _getCreateReportWidget()
//               ],
//             ),
//           ),
//         )
//       ),
//     );
//   }
// }

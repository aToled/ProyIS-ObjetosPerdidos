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
  ReportsHandler? _reportsHandler;

  List<Campus> campusOptions = Campus.values;
  Campus _campus = Campus.concepcion;
  String _numTel = "";
  String _correo = "";
  String _descripcion = "";
  final ValueNotifier<Etiqueta> _etiqueta = ValueNotifier(Etiqueta.otro);
  
  String _getStringFromLabel(Etiqueta label) {
    switch(label) {
      case Etiqueta.celular: return "Celular";
      case Etiqueta.llaves: return "Llaves";
      case Etiqueta.cartera: return "Cartera";
      case Etiqueta.billetera: return "Billetera";
      case Etiqueta.documento: return "Documento";
      case Etiqueta.lentes: return "Llentes";
      case Etiqueta.botella: return "Botella";
      case Etiqueta.otro: return "Otro";
    }
  }

  @override
  Widget build(BuildContext context) {
    _reportsHandler ??= ModalRoute.of(context)!.settings.arguments as ReportsHandler;
    
    for (Reporte reporte in _reportsHandler!.getReportes()) {
      print("-------------------");
      print(reporte.id + "/" + reporte.numTel + "/" + reporte.correo);
      print(reporte.fecha);
      print(reporte.descripcion);
    }
    print("-------------------");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Reportar objeto perdido"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // TODO: Delete later
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/test");
                },
                child: Text("Seleccionar lugar"),
              ),
              // Campus
              Text("Campus:"),
              const SizedBox(height: 10),
              DropdownButton<Campus>(
                value: _campus,
                items: Campus.values.map<DropdownMenuItem<Campus>>((Campus value) {
                  return DropdownMenuItem<Campus>(
                    value: value,
                    child: Text(
                      (value == Campus.concepcion) ? "Concepcion" : (value == Campus.losAngeles) ? "Los angeles" : "Chillan"
                    ),
                  );
                }).toList(),
                onChanged: (Campus? newValue) {
                  if (newValue == null) {
                    return;
                  }
                  _campus = newValue;
                },
              ),
              const SizedBox(height: 15),
              // Número de teléfono
              Text("Número de teléfono:"),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (value) {
                    _numTel = value;
                  },
                ),
              ),
              const SizedBox(height: 15),
              // Correo
              Text("Correo:"),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (value) {
                    _correo = value;
                  },
                ),
              ),
              const SizedBox(height: 15),
              // Descripción
              Text("Descripción del objeto:"),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (value) {
                    _descripcion = value;
                  },
                  minLines: 5,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text("Etiqueta:"),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: _etiqueta,
                builder: (context, etiqueta, child) {
                  return DropdownButton<Etiqueta>(
                    value: etiqueta,
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
              ),
              const SizedBox(height: 15),
              ElevatedButton(onPressed: () {
                Reporte reporte = Reporte(
                  DateTime.now(),
                  Lugar(0, 0, 100),
                  _campus,
                  _numTel,
                  _correo,
                  _descripcion,
                  _etiqueta.value
                );

                _reportsHandler!.addReport(reporte);

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
              }, child: const Text("Enviar reporte"))
            ],
          ),
        )
      ),
    );
  }
}

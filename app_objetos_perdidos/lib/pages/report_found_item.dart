import 'package:app_objetos_perdidos/pages/map_page.dart';
import 'package:app_objetos_perdidos/utils/administrador.dart';
import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:app_objetos_perdidos/utils/reporte.dart';
import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:flutter/material.dart';

class ReportFoundItemPage extends StatefulWidget {
  final Administrador admin;
  const ReportFoundItemPage({super.key, required this.admin});

  @override
  State<ReportFoundItemPage> createState() => _ReportFoundItemPage();
}

class _ReportFoundItemPage extends State<ReportFoundItemPage> {
  

  final _formKey = GlobalKey<FormState>();

  List<Campus> campusOptions = Campus.values;
  final Lugar _lugar = Lugar(0, 0, 100);
  Campus _campus = Campus.concepcion;
  final _descripcionController = TextEditingController();
  final ValueNotifier<Etiqueta> _etiqueta = ValueNotifier(Etiqueta.otro);
  DateTime _fechaEncuentro = DateTime.now();
  
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

  Widget _getDateWidget() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _fechaEncuentro,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != _fechaEncuentro) {
          setState(() {
            _fechaEncuentro = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: '¿Cuándo se encontró?',
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          "${_fechaEncuentro.day}/${_fechaEncuentro.month}/${_fechaEncuentro.year}",
          style: TextStyle(fontSize: 16),
        ),
      ),
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

          ReporteEncontrado reporte = ReporteEncontrado(
            DateTime.now(),
            _lugar,
            _campus,
            _descripcionController.text,
            _etiqueta.value,
            "admin",
            "TM3-5",
            "correoadmin@gmail.com",
            _fechaEncuentro,
          );

          widget.admin.addReport(reporte);

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
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

   
    for (Reporte reporte in widget.admin.getReportesEncontrados()) {
      print("-------------------");
      //print("${reporte.id} / ${reporte.numTel} / ${reporte.correo}");
      print(reporte.fechaCreacion);
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
                const SizedBox(height: 16),
                _getDateWidget(),
                const SizedBox(height: 24),
                Text(
                  "Información de Contacto",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text("correoadmin@gmail.com"),
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


import 'package:app_objetos_perdidos/pages/map_page.dart';
import 'package:app_objetos_perdidos/utils/buscador.dart';
import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:app_objetos_perdidos/utils/reporte.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:flutter/material.dart';

class ReportLostItemPage extends StatefulWidget {
  final Buscador buscador;
  const ReportLostItemPage({super.key, required this.buscador});

  @override
  State<ReportLostItemPage> createState() => _ReportLostItemPageState();
}

class _ReportLostItemPageState extends State<ReportLostItemPage> {

  final _formKey = GlobalKey<FormState>();

  List<Campus> campusOptions = Campus.values;
  final Lugar _lugar = Lugar(0, 0, 100);
  Campus _campus = Campus.concepcion;
  final _numTelController = TextEditingController();
  final _correoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final ValueNotifier<Etiqueta> _etiqueta = ValueNotifier(Etiqueta.otro);
  DateTime _fechaPerdida = DateTime.now();
  
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
          child: Text(value.visibleName),
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
        prefixText: '+569 ',
        prefixStyle: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        hintText: "12345678",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: TextInputType.phone,
      maxLength: 8,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa un número de teléfono';
        }
        final phoneRegex = RegExp(r'^\d{8}$');
        
        if (!phoneRegex.hasMatch(value)) {
          return 'Ingresa un número de 8 dígitos';
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

  Widget _getDateWidget() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _fechaPerdida,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != _fechaPerdida) {
          setState(() {
            _fechaPerdida = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: '¿Cuándo se perdió?',
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          "${_fechaPerdida.day}/${_fechaPerdida.month}/${_fechaPerdida.year}",
          style: TextStyle(fontSize: 16),
        ),
      ),
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
              child: Text(value.visibleName)
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

          ReportePerdido reporte = ReportePerdido(
            DateTime.now(),
            _lugar,
            _campus,
            _descripcionController.text,
            _etiqueta.value, 
            widget.buscador.getId() , 
            '+569${_numTelController.text}',
            _correoController.text,
            _fechaPerdida,
          );

          widget.buscador.addReport(reporte);

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
    
    
    for (Reporte reporte in widget.buscador.getReportes()) {
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

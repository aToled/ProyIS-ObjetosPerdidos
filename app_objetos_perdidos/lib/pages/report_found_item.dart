import 'dart:io';

import 'package:app_objetos_perdidos/pages/map_page.dart';
import 'package:app_objetos_perdidos/utils/administrador.dart';
import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ReportFoundItemPage extends StatefulWidget {
  final Administrador admin;
  const ReportFoundItemPage({super.key, required this.admin});

  @override
  State<ReportFoundItemPage> createState() => _ReportFoundItemPage();
}

class _ReportFoundItemPage extends State<ReportFoundItemPage> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  List<Campus> campusOptions = Campus.values;
  final Lugar _lugar = Lugar(0, 0, 100);
  Campus _campus = Campus.concepcion;
  final _descripcionController = TextEditingController();
  final _lugarEspecificoController = TextEditingController();
  final ValueNotifier<Etiqueta> _etiqueta = ValueNotifier(Etiqueta.otro);
  DateTime _fechaEncuentro = DateTime.now();
  final ValueNotifier<File?> _imagen = ValueNotifier(null);

  void placeCallback(double lat, double lng) {
    _lugar.latitud = lat;
    _lugar.longitud = lng;
  }

  Widget _getCampusWidget() {
    return DropdownButtonFormField<Campus>(
      value: _campus,
      decoration: InputDecoration(
        labelText: 'Campus',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
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
            Navigator.of(context).pushNamed(
              "/map",
              arguments: ReportMapScreenArgs(placeCallback, _campus),
            );
          },
          label: const Text("Seleccionar lugar en mapa"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        Text("* Opcional", style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _getDescriptionWidget() {
    return TextFormField(
      controller: _descripcionController,
      decoration: InputDecoration(
        labelText: 'Descripción del objeto',
        hintText: "Color, material, marca, detalles únicos...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
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
  Widget _getLugarEspecificoWidget() {
    return TextFormField(
      controller: _lugarEspecificoController,
      decoration: InputDecoration(
        labelText: 'Lugar específico',
        hintText: "TM3-5, Lab redes Sistemas, ...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        alignLabelWithHint: true,
      ),
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 2,
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
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
          items: Etiqueta.values.map<DropdownMenuItem<Etiqueta>>((
            Etiqueta value,
          ) {
            return DropdownMenuItem<Etiqueta>(
              value: value,
              child: Text(value.visibleName),
            );
          }).toList(),
          onChanged: (Etiqueta? newValue) {
            if (newValue == null) {
              return;
            }
            _etiqueta.value = newValue;
          },
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    // Usa el picker para seleccionar una imagen de la galería
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Si el usuario selecciona una imagen.
      _imagen.value = File(pickedFile.path);
    } else {
      // El usuario canceló la selección
      print('No se seleccionó ninguna imagen.');
    }
  }

  void _askToRemovePicture() async {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Aviso"),
        content: const Text("¿Desea quitar la imagen?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
          TextButton(onPressed: () {
            _imagen.value = null;
          }, child: const Text("Quitar")),
        ],
      );
    });
  }

  Widget _getCreateReportWidget() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Por favor, corrige los errores')),
            );
            return;
          }

          String? rutaPermanente;

          if (_imagen.value != null) {
            // 1. Obtener el directorio de documentos de la app
            final directory = await getApplicationDocumentsDirectory();
            
            // 2. Crear una ruta única para el archivo
            final String nombreArchivo = p.basename(_imagen.value!.path);
            rutaPermanente = '${directory.path}/$nombreArchivo';

            // 3. Copiar el archivo a la ruta permanente
            await _imagen.value!.copy(rutaPermanente);
          }

          ReporteEncontrado reporte = ReporteEncontrado(
            DateTime.now(),
            _lugar,
            _campus,
            _descripcionController.text,
            _etiqueta.value,
            "admin",
            _lugarEspecificoController.text,
            rutaPermanente,
            "TM custodia",
            "correoadmin@gmail.com",
            _fechaEncuentro,
          );

          widget.admin.addReport(reporte);

          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Reporte enviado"),
                content: const Text("El reporte ha sido enviado con éxito"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Aceptar"),
                  ),
                ],
              );
            },
          );
        },
        child: const Text("Enviar reporte"),
      ),
    );
  }

  Widget _getPictureWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.photo),
              onPressed: _pickImageFromGallery,
              label: const Text("Selecciona una imagen"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            Text(
              "* Opcional",
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
        ValueListenableBuilder(
          valueListenable: _imagen,
          builder: (context, file, child) {
            return file == null
              ? const SizedBox()
              : GestureDetector(
                onLongPress: _askToRemovePicture,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Image.file(
                      file
                    ),
                ),
              );
          }
        ),
      ],
    );
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Reportar objeto encontrado"),
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
                _getLugarEspecificoWidget(),
                const SizedBox(height: 16),
                _getDateWidget(),
                const SizedBox(height: 16),
                _getPictureWidget(),
                const SizedBox(height: 24),
                Text(
                  "Información de Contacto",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text("correoadmin@gmail.com"),
                const SizedBox(height: 24),
                _getCreateReportWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

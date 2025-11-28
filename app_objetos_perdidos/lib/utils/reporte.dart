import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:uuid/uuid.dart';


abstract class Reporte extends HiveObject{
  @HiveField(0) 
  final String id;

  @HiveField(1)
  final DateTime fechaCreacion;

  @HiveField(2)
  final Lugar lugar; 

  @HiveField(3)
 final  Campus campus; 

  @HiveField(4)
 final  String descripcion;

  @HiveField(5)
  final Etiqueta etiqueta;

  @HiveField(6)
  final String creadorId;
  
  @HiveField(7)
  final String? imagenRuta;

  @HiveField(8)
  bool encontrado;

  Widget getImagenWidget() {
    if (imagenRuta == null) {
      return Icon(Icons.image_not_supported, size: 100);
    }
    
    File file;
    
    file = File(imagenRuta!);

    if (file.existsSync()) {
      return Image.file(
        file,
        fit: BoxFit.cover,
      );
    } else {
      return Icon(Icons.image_not_supported, size: 300);
    }
  }
  
  Future<void> borrarImagen() async {
    if (imagenRuta == null || imagenRuta!.isEmpty) {
      return;
    }
    
    try {
      final File imagenArchivo = File(imagenRuta!);

      if (await imagenArchivo.exists()) {
        await imagenArchivo.delete();
        print("Report image deleted.");
      } else {
        print("Report image doesn't exists.");
      }
    } catch (e) {
      print("Error while deleting report image: $e");
    }
  }
  
 Reporte(
    this.fechaCreacion,
    this.lugar,
    this.campus,
    this.descripcion,
    this.etiqueta,
    this.creadorId,
    this.imagenRuta, {
    this.encontrado = false,
    String? id,
  }) : this.id = id ?? Uuid().v6(); 
}
import 'package:hive/hive.dart';
import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:uuid/uuid.dart';


abstract class Reporte {
  @HiveField(0) 
  late String id;

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
  
  
  Reporte(this.fechaCreacion, this.lugar, this.campus, this.descripcion, this.etiqueta, this.creadorId) {
       id = Uuid().v6(); 
       }
}
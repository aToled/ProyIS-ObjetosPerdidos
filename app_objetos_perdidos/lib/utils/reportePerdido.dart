import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:app_objetos_perdidos/utils/reporte.dart';
import 'package:hive/hive.dart';

part 'reportePerdido.g.dart';
@HiveType(typeId: 10)
class ReportePerdido extends Reporte {
  @HiveField(10)
  bool encontrado=false;
  @HiveField(11)
  final String numTel;
  @HiveField(12)
  final String correo;
  @HiveField(13)
  final DateTime fechaPerdida;

  ReportePerdido(super.fechaCreacion, super.lugar, super.campus, super.descripcion, super.etiqueta, super.creadorId, super.imagenRuta, this.numTel, this.correo, this.fechaPerdida){
  }


}
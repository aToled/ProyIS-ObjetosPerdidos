import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:app_objetos_perdidos/utils/reporte.dart';
import 'package:hive/hive.dart';
part 'reporteEncontrado.g.dart';

@HiveType(typeId: 20)
class ReporteEncontrado extends Reporte {
  @HiveField(20)
  final String ubicacionCustodia;
  @HiveField(21)
  final String correoCustodia;


  ReporteEncontrado(super.fecha, super.lugar, super.campus, super.descripcion, super.etiqueta, super.creadorId, this.ubicacionCustodia, this.correoCustodia){
  }


}
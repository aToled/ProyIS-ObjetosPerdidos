import 'package:app_objetos_perdidos/utils/reporte.dart';
import 'package:app_objetos_perdidos/utils/reports_handler.dart';

abstract class Usuario{
  void deleteReporte( Reporte reporte);
  String getId();
}
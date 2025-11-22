import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:hive/hive.dart';
import 'package:app_objetos_perdidos/utils/reporte.dart';

class ReportsHandler {
  
  static final ReportsHandler _instancia = ReportsHandler._constructorPrivado();

  factory ReportsHandler() {
    return _instancia;
  }


  ReportsHandler._constructorPrivado() {
   
  }




  final Box<ReporteEncontrado> _reportesEncontradosBox = Hive.box<ReporteEncontrado>('reportesEncontrados');
  final Box<ReportePerdido> _reportesPerdidosBox = Hive.box<ReportePerdido>('reportesPerdidos');


  void addReportPerdido(ReportePerdido reporte) {
    _reportesPerdidosBox.put(reporte.id, reporte);
  }

  void addReportEncontrado(ReporteEncontrado reporte) {
    _reportesEncontradosBox.put(reporte.id, reporte);

    
  }

  List<ReportePerdido> getAllReportesPerdidos(){
    return _reportesPerdidosBox.values.toList();
  }

  List<ReporteEncontrado> getAllReportesEncontrados(){
    return _reportesEncontradosBox.values.toList();
  }


  void borrarReporteEncontrado(Reporte reporte){
    _reportesEncontradosBox.delete(reporte.id);
  }

  void borrarReportePerdido(Reporte reporte){
    _reportesPerdidosBox.delete(reporte.id);
  }
}
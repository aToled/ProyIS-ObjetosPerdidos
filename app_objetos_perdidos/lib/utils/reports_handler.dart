import 'package:app_objetos_perdidos/utils/coincidencia.dart';
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
  final Box<Coincidencia> _coincidenciasBox = Hive.box<Coincidencia>('coincidencias');


  void addReportPerdido(ReportePerdido reporte) {
    _reportesPerdidosBox.put(reporte.id, reporte);
     emparejar_reportes();
  }

  void addReportEncontrado(ReporteEncontrado reporte) {
    _reportesEncontradosBox.put(reporte.id, reporte);
    emparejar_reportes();
    
  }
  void emparejar_reportes(){
    for(var reporteEncontrado in _reportesEncontradosBox.values){
      for(var reportePerdido in _reportesPerdidosBox.values){
        if(reportePerdido.campus==reporteEncontrado.campus && reportePerdido.etiqueta==reporteEncontrado.etiqueta){
          String keyCoincidencia= "${reportePerdido.id}_${reporteEncontrado.id}"; //concatenacion de ambas id.
          //si es que no existe esa coincidencia la agregamos
          if(!_coincidenciasBox.containsKey(keyCoincidencia)){
          _coincidenciasBox.put(keyCoincidencia, Coincidencia(reporteEncontrado, reportePerdido));}
    
        }
      }
    }
  }
  List<Coincidencia> getAllCoincidencias(){
    return _coincidenciasBox.values.toList();
  }

  List<ReportePerdido> getAllReportesPerdidos(){
    return _reportesPerdidosBox.values.toList();
  }

  List<ReporteEncontrado> getAllReportesEncontrados(){
    return _reportesEncontradosBox.values.toList();
  }


  void borrarReporteEncontrado(Reporte reporte) {
    reporte.borrarImagen();
    _reportesEncontradosBox.delete(reporte.id);
  }

  void borrarReportePerdido(Reporte reporte) {
    reporte.borrarImagen();
    _reportesPerdidosBox.delete(reporte.id);
  }

  void borrarCoincidencia(Coincidencia coincidencia) {
    _coincidenciasBox.delete("${coincidencia.reportePerdido.id}_${coincidencia.reporteEncontrado.id}");
  }
}
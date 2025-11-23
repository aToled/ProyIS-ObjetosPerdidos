import 'package:app_objetos_perdidos/utils/coincidencia.dart';
import 'package:app_objetos_perdidos/utils/reporte.dart';
import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:app_objetos_perdidos/utils/reports_handler.dart';
import 'package:app_objetos_perdidos/utils/usuario.dart';

class Administrador extends Usuario{
  
  @override
  void deleteReporte(Reporte reporte) {
    if(reporte is ReporteEncontrado){
    ReportsHandler().borrarReporteEncontrado(reporte);
    }
    else if(reporte is ReportePerdido){
      ReportsHandler().borrarReportePerdido(reporte);
    }
  } 

  @override
  String getId() {
    return 'admin'; //usaremos un solo admin a fines de prototipo
  }

  List<ReportePerdido> getReportesPerdidos() {
    return ReportsHandler().getAllReportesPerdidos();
  }
  List<ReporteEncontrado> getReportesEncontrados() {
    return ReportsHandler().getAllReportesEncontrados();
  }
  void addReport(ReporteEncontrado reporte){
      ReportsHandler().addReportEncontrado(reporte);
  }
  List<Coincidencia> getCoincidencias(){
    return ReportsHandler().getAllCoincidencias();
  }
  
  
}
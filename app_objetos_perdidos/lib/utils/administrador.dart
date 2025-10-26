import 'package:app_objetos_perdidos/utils/reporte.dart';
import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reports_handler.dart';
import 'package:app_objetos_perdidos/utils/usuario.dart';

class Administrador extends Usuario{
  
  @override
  void deleteReporte(Reporte reporte) {
    ReportsHandler().borrarReporteEncontrado(reporte);
  } 

  @override
  String getId() {
    return 'admin'; //usaremos un solo admin a fines de prototipo
  }

  List<Reporte> getReportesPerdidos() {
    return ReportsHandler().getAllReportesPerdidos();
  }
  List<Reporte> getReportesEncontrados() {
    return ReportsHandler().getAllReportesEncontrados();
  }
  void addReport(ReporteEncontrado reporte){
      ReportsHandler().addReportEncontrado(reporte);
  }
  
}
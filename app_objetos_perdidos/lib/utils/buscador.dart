import 'package:app_objetos_perdidos/utils/reporte.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:app_objetos_perdidos/utils/reports_handler.dart';
import 'package:app_objetos_perdidos/utils/usuario.dart';

class Buscador extends Usuario{
  final String userId;
  Buscador(this.userId){}

  void addReport(ReportePerdido reporte){
    ReportsHandler().addReportPerdido(reporte);
  }
  @override
  void deleteReporte(Reporte reporte) {
    if(reporte.creadorId==userId){
      ReportsHandler().borrarReportePerdido(reporte);
    }
    else{
      throw Exception("Permiso denegado");
    }
  }

  @override
  String getId() {
     return userId;
  }

  @override
  List<Reporte> getReportes() {
    final AllReportes= ReportsHandler().getAllReportesPerdidos();
    return AllReportes.where((reporte)=> reporte.creadorId== userId).toList();
    
  }}
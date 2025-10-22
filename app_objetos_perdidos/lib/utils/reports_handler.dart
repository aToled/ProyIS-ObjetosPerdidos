import 'package:app_objetos_perdidos/utils/json_manager.dart';
import 'package:app_objetos_perdidos/utils/reporte.dart';

class ReportsHandler {
  JsonManager jsonManager = JsonManager("reports.json");
  List<Reporte> _reportes = [];

  ReportsHandler() {
    jsonManager.readJson().then((json) {
      List<Map<String, dynamic>> jsonList = (json["reportes"] ?? []).cast<Map<String, dynamic>>();
      _reportes = _reporstListFromJsonList(jsonList);
    });
  }

  List<Reporte> _reporstListFromJsonList(List<Map<String, dynamic>> jsonList) {
    List<Reporte> newList = [];

    for (var json in jsonList) {
      newList.add(Reporte.fromJson(json));
    }

    return newList;
  }

  List<Map<String, dynamic>> _jsonListFromReportsList(List<Reporte> reportes) {
    List<Map<String, dynamic>> newList = [];

    for (Reporte reporte in reportes) {
      newList.add(reporte.toJson());
    }

    return newList;
  }

  List<Reporte> getReportes() {
    return _reportes.toList();
  }

  void addReport(Reporte reporte) {
    _reportes.add(reporte);

    jsonManager.writeJson({
      "reportes": _jsonListFromReportsList(_reportes)
    });
  }
}
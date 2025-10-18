import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:uuid/uuid.dart';

class Reporte {
  static var uuid = Uuid();

  late String id;
  bool encontrado = false;
  DateTime fecha;
  Lugar lugar;
  Campus campus;
  String numTel;
  String correo;
  String descripcion;
  Etiqueta etiqueta;

  Reporte._(this.id, this.encontrado, this.fecha, this.lugar, this.campus, this.numTel, this.correo, this.descripcion, this.etiqueta);
  
  Reporte(this.fecha, this.lugar, this.campus, this.numTel, this.correo, this.descripcion, this.etiqueta) {
    id = uuid.v6();
  }

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte._(
      json["id"],
      json["encontrado"],
      DateTime.parse(json["fecha"]),
      Lugar.fromJson(json["lugar"]),
      Campus.values.firstWhere((e) => e.name == json["campus"]),
      json["numTel"],
      json["correo"],
      json["descripcion"],
      Etiqueta.values.firstWhere((e) => e.name == json["etiqueta"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "encontrado": encontrado,
    "fecha": fecha.toIso8601String(),
    "lugar": lugar.toJson(),
    "campus": campus.name,
    "numTel": numTel,
    "correo": correo,
    "descripcion": descripcion,
    "etiqueta": etiqueta.name
  };
}
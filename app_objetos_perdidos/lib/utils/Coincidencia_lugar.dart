import 'dart:math';

import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
part 'coincidencia_lugar.g.dart';
@HiveType(typeId: 31)
///Clase que calcula el nivel de coincidencia de lugar entre dos reportes
class CoincidenciaLugar extends HiveObject{
  @HiveField(0)
  Lugar lugarReporteEncontrado;
  @HiveField(1)
  Lugar lugarReportePerdido;
  @HiveField(2)
  double nivel_coincidencia;
  CoincidenciaLugar(this.lugarReporteEncontrado, this.lugarReportePerdido, {this.nivel_coincidencia = -1.0}){
  }
  void calcular_factor(){
      if((lugarReporteEncontrado.latitud==0 && lugarReporteEncontrado.longitud==0 )||(lugarReportePerdido.latitud==0 && lugarReportePerdido.longitud==0)){
        this.nivel_coincidencia=0.85;
        return;
      }
       LatLng puntoPerdido=LatLng(lugarReportePerdido.latitud, lugarReportePerdido.longitud);
       LatLng puntoEncontrado=LatLng(lugarReporteEncontrado.latitud, lugarReporteEncontrado.longitud);
       final Distance distance = new Distance();
       final double distancia=distance(puntoEncontrado, puntoPerdido);
       this.nivel_coincidencia= pow(e, -0.01*distancia).toDouble();
       
       //si ya fue guardado el objeto implica que se calculo el nivel de coincidencia, entonces lo actualizamos (para que sea !=-1)
       if(isInBox){
        save();
       }

  }
  double getNivelCoincidencia(){
    //si nunca se calculó
    if(nivel_coincidencia==-1.0){
      calcular_factor();
    }
    return nivel_coincidencia;
  }
}
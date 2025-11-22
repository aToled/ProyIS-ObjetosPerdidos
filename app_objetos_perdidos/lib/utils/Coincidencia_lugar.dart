import 'dart:math';

import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:latlong2/latlong.dart';
///Clase que calcula el nivel de coincidencia de lugar entre dos reportes
class CoincidenciaLugar{
   Lugar lugarReporteEncontrado;
   Lugar lugarReportePerdido;
    late double nivel_coincidencia;
  CoincidenciaLugar(this.lugarReporteEncontrado, this.lugarReportePerdido){
       LatLng puntoPerdido=LatLng(lugarReportePerdido.latitud, lugarReportePerdido.longitud);
       LatLng puntoEncontrado=LatLng(lugarReporteEncontrado.latitud, lugarReporteEncontrado.longitud);
       final Distance distance = new Distance();
       final double distancia=distance(puntoEncontrado, puntoPerdido);
       nivel_coincidencia= pow(e, -0.01*distancia).toDouble();
  }
  double getNivelCoincidencia(){
    return nivel_coincidencia;
  }
}
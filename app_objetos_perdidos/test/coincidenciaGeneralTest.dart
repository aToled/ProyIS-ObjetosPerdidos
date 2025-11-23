import 'dart:io';

import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_objetos_perdidos/utils/coincidencia.dart';
import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';

void main() {
  // Opcional: Cargar variables de entorno si tu API Manager las necesita
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = null;
    await dotenv.load(fileName: ".env"); 
  });

  group('Pruebas de Integración con API Real de Gemini', () {
    
    test('Debe detectar una ALTA similitud en objetos casi idénticos', () async {
      // 1. ARRANGE: Creamos dos objetos muy parecidos
    
      final reporteEncontrado = ReporteEncontrado(
        DateTime.now(),        
        Lugar(-36.83170,-73.03397,10),           
        Campus.concepcion,             
        "Mochila negra HP",    
        Etiqueta.utiles,           
        "admin",       
        "Oficina Guardias",   
        "guardia@test.com",    
        DateTime.now()        
      );

      final reportePerdido= ReportePerdido(
        DateTime.now(),        
        Lugar(-36.83185,-73.03412,10),           
        Campus.concepcion,             
        "Mochila negra HP",    
        Etiqueta.utiles,           
        "user1",       
        "99999999",   
        "user1@gmail.com",    
        DateTime.now()        
      );

      final coincidencia = Coincidencia(reporteEncontrado, reportePerdido);

      // 2.Llamada real a la API (esto tardará unos segundos)
      final resultado = await coincidencia.getNivelCoincidencia();
      
      print('Resultado API Real (Alta Similitud): $resultado');

      // 3 No esperamos un número exacto, pero sí uno alto.
      // Asumiendo que el lugar es el mismo (100%) y la descripción es muy parecida.
      expect(resultado, greaterThan(70), reason: "La similitud debería ser alta para objetos parecidos");
      expect(resultado, lessThanOrEqualTo(100));
    });

    test('Debe detectar una BAJA similitud en objetos diferentes', () async {
      // 1.  Objetos distintos
        final reporteEncontrado = ReporteEncontrado(
        DateTime.now(),        
        Lugar(-36.83170,-73.03397,10),           
        Campus.concepcion,             
        "Xiaomi redmi note 9s azul",    
        Etiqueta.celular,           
        "admin",       
        "Oficina Guardias",   
        "guardia@test.com",    
        DateTime.now()        
      );

      final reportePerdido= ReportePerdido(
        DateTime.now(),        
        Lugar(-36.83185,-73.03412,10),           
        Campus.concepcion,             
        "Xiaomi poco X3",    
        Etiqueta.celular,           
        "user1",       
        "99999999",   
        "user1@gmail.com",    
        DateTime.now()        
      );

      final coincidencia = Coincidencia(reporteEncontrado, reportePerdido);

      // 2. ACT
      final resultado = await coincidencia.getNivelCoincidencia();

      print('Resultado API Real (Baja Similitud): $resultado');

      // 3. ASSERT
      expect(resultado, lessThan(25), reason: "La similitud debería ser baja para objetos distintos");
      expect(resultado, greaterThanOrEqualTo(0)); // No debería devolver -1 si la API funciona bien
    });

    test('Debe detectar similitud baja entre objetos parecidos pero muy lejos en el campus', () async {
      // 1.  Objetos distintos
        final reporteEncontrado = ReporteEncontrado(
        DateTime.now(),        
        Lugar(-36.826686907394105, -73.03682007084522,10),  //casa del deporte
        Campus.concepcion,             
        "Xiaomi redmi note 9s azul",    
        Etiqueta.celular,           
        "admin",       
        "Oficina Guardias",   
        "guardia@test.com",    
        DateTime.now()        
      );

      final reportePerdido= ReportePerdido(
        DateTime.now(),        
        Lugar(-36.82785678987943, -73.03419471539651,10),    //casino los patos (aprox 260 metros de la casa del deporte)       
        Campus.concepcion,             
        "Xiaomi redmi note 9s azul",    
        Etiqueta.celular,           
        "user1",       
        "99999999",   
        "user1@gmail.com",    
        DateTime.now()        
      );

      final coincidencia = Coincidencia(reporteEncontrado, reportePerdido);

      // 2. ACT
      final resultado = await coincidencia.getNivelCoincidencia();

      print('Resultado API Real (Baja Similitud): $resultado');

      // 3. ASSERT
      expect(resultado, lessThan(25), reason: "La similitud debería ser nula ya que son objetos distintos");
      expect(resultado, greaterThanOrEqualTo(0)); // No debería devolver -1 si la API funciona bien
    });

  });
}
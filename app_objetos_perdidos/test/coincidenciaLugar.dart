import 'package:app_objetos_perdidos/utils/coincidencia_lugar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart'; 

void main() {
  group('Pruebas de CoincidenciaLugar (Escala: 100m es lejos)', () {
    
    final baseLat = -36.820136;
    final baseLon = -73.044390;

    test('A 0 metros debe dar 100 puntos', () {
      final centro = Lugar(baseLat, baseLon, 10);
      final coincidencia = CoincidenciaLugar(centro, centro);
      expect(coincidencia.getNivelCoincidencia(), 100);
    });

    test('A ~10 metros (Muy Cerca) el puntaje debe ser alto', () {
      // 0.0001 grados son aprox 11.1 metros.
      // Esto es "Cerca" de verdad.
      final centro = Lugar(baseLat, baseLon, 10);
      final cerca = Lugar(baseLat + 0.0001, baseLon, 10); 

      final calculo = CoincidenciaLugar(centro, cerca).getNivelCoincidencia();
      
      // Con tu fórmula actual, 11m da aprox 76-77 puntos.
      print('Puntaje a 11 metros: $calculo');
      expect(calculo, greaterThan(70)); 
    });

    test('A ~111 metros (Lejos) el puntaje debe caer drásticamente', () {
      // 0.001 grados son aprox 111 metros.
      // Según tu regla, esto ya es "lejos".
      final centro = Lugar(baseLat, baseLon, 10);
      final limiteLejos = Lugar(baseLat + 0.001, baseLon, 10); 

      final calculo = CoincidenciaLugar(centro, limiteLejos).getNivelCoincidencia();

      // Con tu fórmula actual, 111m da aprox 23-24 puntos.
      print('Puntaje a 111 metros: $calculo');
      expect(calculo, lessThan(30)); // Verificamos que sea bajo
    });

    test('Comparativa: 10m debe tener mucho más puntaje que 100m', () {
      final centro = Lugar(baseLat, baseLon, 10);
      
      final puntoCerca = Lugar(baseLat + 0.0001, baseLon, 10); // ~11m
      final puntoLejos = Lugar(baseLat + 0.001, baseLon, 10);  // ~111m

      final scoreCerca = CoincidenciaLugar(centro, puntoCerca).getNivelCoincidencia();
      final scoreLejos = CoincidenciaLugar(centro, puntoLejos).getNivelCoincidencia();

      expect(scoreCerca, greaterThan(scoreLejos));
    });
  });
}
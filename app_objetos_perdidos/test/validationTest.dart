import 'dart:io';

import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/coincidencia_lugar.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:app_objetos_perdidos/utils/reporte.dart';
import 'package:app_objetos_perdidos/utils/reports_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_objetos_perdidos/utils/coincidencia.dart';
import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void emptyCoincidencesList() {
  final coincidences = ReportsHandler().getAllCoincidencias();
  for (Coincidencia coincidence in coincidences) {
    ReportsHandler().borrarCoincidencia(coincidence);
  }
}

void emptyFoundReportsList() {
  final reportesEncontrados = ReportsHandler().getAllReportesEncontrados();
  for (ReporteEncontrado reporte in reportesEncontrados) {
    ReportsHandler().borrarReporteEncontrado(reporte);
  }
}

void emptyLostReportsList() {
  final reportesPerdidos = ReportsHandler().getAllReportesPerdidos();
  for (ReportePerdido reporte in reportesPerdidos) {
    ReportsHandler().borrarReportePerdido(reporte);
  }
}

void emptyAll() {
  emptyLostReportsList();
  emptyFoundReportsList();
  emptyCoincidencesList();
}

ReportePerdido createReportePerdido(Duration duration, Campus campus, String desc, Etiqueta etiqueta) {
  return ReportePerdido(
    DateTime.now().subtract(duration),
    Lugar(-36.83190,-73.03417,10),
    campus,
    desc,
    etiqueta,
    "testingID",
    null,
    "12345678",
    "correo@udec.cl",
    DateTime.now()
  );
}

ReporteEncontrado createReporteEncontrado(Duration duration, Campus campus, String desc, Etiqueta etiqueta) {
  return ReporteEncontrado(
    DateTime.now().subtract(duration),
    Lugar(-36.83190,-73.03417,10),
    campus,
    desc,
    etiqueta,
    "testingID",
    null,
    "12345678",
    "correo@udec.cl",
    DateTime.now()
  );
}

void main() {
  // Opcional: Cargar variables de entorno si tu API Manager las necesita
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = null;
    await Hive.initFlutter();

    Hive.registerAdapter(ReportePerdidoAdapter());
    Hive.registerAdapter(ReporteEncontradoAdapter());
    Hive.registerAdapter(LugarAdapter());
    Hive.registerAdapter(CampusAdapter());
    Hive.registerAdapter(EtiquetaAdapter());
    Hive.registerAdapter(CoincidenciaLugarAdapter());
    Hive.registerAdapter(CoincidenciaAdapter());
    

    await Hive.openBox<ReporteEncontrado>('reportesEncontrados');
    await Hive.openBox<ReportePerdido>('reportesPerdidos');
    await Hive.openBox<Coincidencia>('coincidencias');
    await Hive.openBox<Coincidencia>('coincidenciasRechazadas');
    
    // Loading .env file
    await dotenv.load(fileName: ".env");
  });

  group('Pruebas de sistema matching', () {
    test('1) Matching entre reportes idénticos', () async {
      emptyAll();
      ReportePerdido reportePerdido = ReportePerdido(
        DateTime.now(),
        Lugar(-36.83185,-73.03412,10),
        Campus.concepcion,
        "Celular Samsung S20",
        Etiqueta.celular,
        "testingID",
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );

      ReporteEncontrado reporteEncontrado = ReporteEncontrado(
        DateTime.now(),
        Lugar(-36.83185,-73.03412,10),
        Campus.concepcion,
        "Celular Samsung S20",
        Etiqueta.celular,
        "testingID",
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );
      
      ReportsHandler().addReportPerdido(reportePerdido);
      ReportsHandler().addReportEncontrado(reporteEncontrado);

      expect(ReportsHandler().getAllReportesPerdidos().length, greaterThan(0));
      expect(ReportsHandler().getAllReportesEncontrados().length, greaterThan(0));
      expect(ReportsHandler().getAllCoincidencias().length, greaterThan(0));

      int nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[0].getNivelCoincidencia();

      expect(nivelCoincidencia, greaterThan(85));
    });
    test('2) Matching entre reportes similares', () async {
      emptyAll();
      ReportePerdido reportePerdido = ReportePerdido(
        DateTime.now().subtract(Duration(days: 1)),
        Lugar(-36.83190,-73.03417,10),
        Campus.concepcion,
        "Celular marca Samsung",
        Etiqueta.celular,
        "testingID",
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );

      ReporteEncontrado reporteEncontrado = ReporteEncontrado(
        DateTime.now(),
        Lugar(-36.83185,-73.03412,10),
        Campus.concepcion,
        "Celular Samsung S20",
        Etiqueta.celular,
        "testingID",
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );
      
      ReportsHandler().addReportPerdido(reportePerdido);
      ReportsHandler().addReportEncontrado(reporteEncontrado);

      expect(ReportsHandler().getAllReportesPerdidos().length, greaterThan(0));
      expect(ReportsHandler().getAllReportesEncontrados().length, greaterThan(0));
      expect(ReportsHandler().getAllCoincidencias().length, greaterThan(0));

      int nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[0].getNivelCoincidencia();

      expect(nivelCoincidencia, greaterThan(75));
    });
    test('3) Reportes completamente diferentes no matching', () async {
      emptyAll();
      ReportePerdido reportePerdido = ReportePerdido(
        DateTime.now().subtract(Duration(days: 3)),
        Lugar(-36.83190,-73.03417,10),
        Campus.concepcion,
        "Billetera",
        Etiqueta.documento,
        "testingID",
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );

      ReporteEncontrado reporteEncontrado = ReporteEncontrado(
        DateTime.now(),
        Lugar(-36.83185,-73.03412,10),
        Campus.concepcion,
        "Celular Samsung S20",
        Etiqueta.celular,
        "testingID",
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );
      
      ReportsHandler().addReportPerdido(reportePerdido);
      ReportsHandler().addReportEncontrado(reporteEncontrado);

      expect(ReportsHandler().getAllReportesPerdidos().length, greaterThan(0));
      expect(ReportsHandler().getAllReportesEncontrados().length, greaterThan(0));
      expect(ReportsHandler().getAllCoincidencias().length, equals(0));
    });
    test('4) Se validan y aceptan 5 matches', timeout: Timeout(Duration(minutes: 1)), () async {
      emptyAll();
      ReporteEncontrado re1 = createReporteEncontrado(Duration(days: 2), Campus.concepcion, "Reloj casio", Etiqueta.otro);
      ReporteEncontrado re2 = createReporteEncontrado(Duration(days: 1), Campus.concepcion, "Celular Iphone X", Etiqueta.celular);
      ReporteEncontrado re3 = createReporteEncontrado(Duration(days: 0), Campus.concepcion, "Lentes negros ray-ban", Etiqueta.lentes);
      ReporteEncontrado re4 = createReporteEncontrado(Duration(days: 1), Campus.chillan, "Estuche gris", Etiqueta.utiles);
      ReporteEncontrado re5 = createReporteEncontrado(Duration(days: 0), Campus.chillan, "Botella de vidrio con funda roja", Etiqueta.botella);

      ReportePerdido rp1 = createReportePerdido(Duration(days: 0), Campus.concepcion, "Reloj de marca casio", Etiqueta.otro);
      ReportePerdido rp2 = createReportePerdido(Duration(days: 0), Campus.concepcion, "Un celular Iphone", Etiqueta.celular);
      ReportePerdido rp3 = createReportePerdido(Duration(days: 1), Campus.concepcion, "Lentes de marca ray-ban", Etiqueta.lentes);
      ReportePerdido rp4 = createReportePerdido(Duration(days: 0), Campus.chillan, "Un estuche de color gris", Etiqueta.utiles);
      ReportePerdido rp5 = createReportePerdido(Duration(days: 2), Campus.chillan, "Botella de vidrio", Etiqueta.botella);
      
      ReportsHandler().addReportPerdido(rp1);
      ReportsHandler().addReportPerdido(rp2);
      ReportsHandler().addReportPerdido(rp3);
      ReportsHandler().addReportPerdido(rp4);
      ReportsHandler().addReportPerdido(rp5);

      ReportsHandler().addReportEncontrado(re1);
      ReportsHandler().addReportEncontrado(re2);
      ReportsHandler().addReportEncontrado(re3);
      ReportsHandler().addReportEncontrado(re4);
      ReportsHandler().addReportEncontrado(re5);

      expect(ReportsHandler().getAllReportesPerdidos().length, greaterThan(4));
      expect(ReportsHandler().getAllReportesEncontrados().length, greaterThan(4));
      expect(ReportsHandler().getAllCoincidencias().length, greaterThan(4));

      int nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[0].getNivelCoincidencia();
      expect(nivelCoincidencia, greaterThan(75));
      nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[1].getNivelCoincidencia();
      expect(nivelCoincidencia, greaterThan(75));
      nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[2].getNivelCoincidencia();
      expect(nivelCoincidencia, greaterThan(75));
      nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[3].getNivelCoincidencia();
      expect(nivelCoincidencia, greaterThan(75));
      nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[4].getNivelCoincidencia();
      expect(nivelCoincidencia, greaterThan(75));

      ReportsHandler().getAllCoincidencias()[0].reportePerdido.encontrado = true;
      ReportsHandler().getAllCoincidencias()[1].reportePerdido.encontrado = true;
      ReportsHandler().getAllCoincidencias()[2].reportePerdido.encontrado = true;
      ReportsHandler().getAllCoincidencias()[3].reportePerdido.encontrado = true;
      ReportsHandler().getAllCoincidencias()[4].reportePerdido.encontrado = true;
    });
    test('5) Se validan y rechazan 5 matches', timeout: Timeout(Duration(minutes: 1)), () async {
      emptyAll();
      ReporteEncontrado re1 = createReporteEncontrado(Duration(days: 3), Campus.concepcion, "Reloj casio", Etiqueta.otro);
      ReporteEncontrado re2 = createReporteEncontrado(Duration(days: 0), Campus.concepcion, "Celular Iphone X", Etiqueta.celular);
      ReporteEncontrado re3 = createReporteEncontrado(Duration(days: 1), Campus.concepcion, "Lentes negros ray-ban", Etiqueta.lentes);
      ReporteEncontrado re4 = createReporteEncontrado(Duration(days: 0), Campus.chillan, "Estuche gris", Etiqueta.utiles);
      ReporteEncontrado re5 = createReporteEncontrado(Duration(days: 2), Campus.chillan, "Botella de vidrio con funda roja", Etiqueta.botella);

      ReportePerdido rp1 = createReportePerdido(Duration(days: 0), Campus.losAngeles, "Reloj de marca rolex", Etiqueta.otro);
      ReportePerdido rp2 = createReportePerdido(Duration(days: 3), Campus.concepcion, "Un celular samsung", Etiqueta.celular);
      ReportePerdido rp3 = createReportePerdido(Duration(days: 2), Campus.concepcion, "Billetera de cuero", Etiqueta.billetera);
      ReportePerdido rp4 = createReportePerdido(Duration(days: 1), Campus.concepcion, "Un estuche de color gris", Etiqueta.utiles);
      ReportePerdido rp5 = createReportePerdido(Duration(days: 0), Campus.chillan, "Botella de plastico estilo pokemon", Etiqueta.botella);
      
      ReportsHandler().addReportPerdido(rp1);
      ReportsHandler().addReportPerdido(rp2);
      ReportsHandler().addReportPerdido(rp3);
      ReportsHandler().addReportPerdido(rp4);
      ReportsHandler().addReportPerdido(rp5);

      ReportsHandler().addReportEncontrado(re1);
      ReportsHandler().addReportEncontrado(re2);
      ReportsHandler().addReportEncontrado(re3);
      ReportsHandler().addReportEncontrado(re4);
      ReportsHandler().addReportEncontrado(re5);

      expect(ReportsHandler().getAllReportesPerdidos().length, greaterThan(4));
      expect(ReportsHandler().getAllReportesEncontrados().length, greaterThan(4));
      expect(ReportsHandler().getAllCoincidencias().length, lessThan(4));

      int nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[0].getNivelCoincidencia();
      expect(nivelCoincidencia, lessThan(50));
      nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[1].getNivelCoincidencia();
      expect(nivelCoincidencia, lessThan(50));

      ReportsHandler().getAllCoincidencias()[0].reportePerdido.encontrado = false;
      ReportsHandler().getAllCoincidencias()[1].reportePerdido.encontrado = false;
    });
  });
}
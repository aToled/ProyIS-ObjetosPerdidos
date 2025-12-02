import 'dart:io';

import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/coincidencia_lugar.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
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
    test('1) Reporte objeto perdido, no matching', () async {
      emptyAll();
      ReportePerdido reporte = ReportePerdido(
        DateTime.now(),
        Lugar(-36.83185,-73.03412,10),
        Campus.concepcion,
        "Celular Samsung S20",
        Etiqueta.celular,
        "testingID",
        null,
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );
      
      ReportsHandler().addReportPerdido(reporte);

      expect(ReportsHandler().getAllReportesPerdidos().length, greaterThan(0));
      expect(ReportsHandler().getAllCoincidencias().length, equals(0));
    });
    test('2) Reporte objeto encontrado, no matching', () async {
      emptyAll();
      ReporteEncontrado reporte = ReporteEncontrado(
        DateTime.now(),
        Lugar(-36.83185,-73.03412,10),
        Campus.concepcion,
        "Celular Samsung S20",
        Etiqueta.celular,
        "testingID",
        null,
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );
      
      ReportsHandler().addReportEncontrado(reporte);

      expect(ReportsHandler().getAllReportesEncontrados().length, greaterThan(0));
      expect(ReportsHandler().getAllCoincidencias().length, equals(0));
    });
    test('3) Reporte objeto perdido, matching', () async {
      emptyAll();

      ReporteEncontrado reporteEncontrado = ReporteEncontrado(
        DateTime.now().subtract(Duration(days: 3)),
        Lugar(-36.83185,-73.03412,10),
        Campus.concepcion,
        "Celular Samsung S20",
        Etiqueta.celular,
        "testingID",
        null,
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );

      ReportsHandler().addReportEncontrado(reporteEncontrado);

      ReportePerdido reportePerdido = ReportePerdido(
        DateTime.now(),
        Lugar(-36.83190,-73.03430,10),
        Campus.concepcion,
        "Celular Samsung S20",
        Etiqueta.celular,
        "testingID",
        null,
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );
      
      ReportsHandler().addReportPerdido(reportePerdido);

      expect(ReportsHandler().getAllReportesPerdidos().length, greaterThan(0));
      expect(ReportsHandler().getAllReportesEncontrados().length, greaterThan(0));
      expect(ReportsHandler().getAllCoincidencias().length, greaterThan(0));

      int nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[0].getNivelCoincidencia();

      expect(nivelCoincidencia, greaterThan(75));
    });
    test('4) Reporte objeto encontrado, matching', () async {
      emptyAll();

      ReportePerdido reportePerdido = ReportePerdido(
        DateTime.now().subtract(Duration(days: 2)),
        Lugar(-36.83185,-73.03412,10),
        Campus.concepcion,
        "Celular Samsung S20",
        Etiqueta.celular,
        "testingID",
        null,
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );
      
      ReportsHandler().addReportPerdido(reportePerdido);

      ReporteEncontrado reporteEncontrado = ReporteEncontrado(
        DateTime.now(),
        Lugar(-36.83185,-73.03412,10),
        Campus.concepcion,
        "Celular Samsung S20",
        Etiqueta.celular,
        "testingID",
        null,
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );

      ReportsHandler().addReportEncontrado(reporteEncontrado);

      expect(ReportsHandler().getAllReportesPerdidos().length, greaterThan(0));
      expect(ReportsHandler().getAllReportesEncontrados().length, greaterThan(0));
      expect(ReportsHandler().getAllCoincidencias().length, greaterThan(0));

      int nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[0].getNivelCoincidencia();

      expect(nivelCoincidencia, greaterThan(75));
    });
    test('5) Al haber matching se calcula un grado de coincidencia (sin datos opcionales)', () async {
      emptyAll();

      ReportePerdido reportePerdido = ReportePerdido(
        DateTime.now(),
        Lugar(0, 0, 10),
        Campus.concepcion,
        "Celular Samsung S20",
        Etiqueta.celular,
        "testingID",
        null,
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );
      
      ReportsHandler().addReportPerdido(reportePerdido);

      ReporteEncontrado reporteEncontrado = ReporteEncontrado(
        DateTime.now(),
        Lugar(0, 0, 10),
        Campus.concepcion,
        "Celular Samsung S20",
        Etiqueta.celular,
        "testingID",
        null,
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );

      ReportsHandler().addReportEncontrado(reporteEncontrado);

      expect(ReportsHandler().getAllReportesPerdidos().length, greaterThan(0));
      expect(ReportsHandler().getAllReportesEncontrados().length, greaterThan(0));
      expect(ReportsHandler().getAllCoincidencias().length, greaterThan(0));

      int nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[0].getNivelCoincidencia();

      expect(nivelCoincidencia, greaterThan(75));
    });
    test('6) Al haber matching se calcula un grado de coincidencia (con datos opcionales)', () async {
      emptyAll();

      ReportePerdido reportePerdido = ReportePerdido(
        DateTime.now().subtract(Duration(days: 2)),
        Lugar(-36.83185,-73.03412,10),
        Campus.chillan,
        "TNE 2025",
        Etiqueta.documento,
        "testingID",
        null,
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );
      
      ReportsHandler().addReportPerdido(reportePerdido);

      ReporteEncontrado reporteEncontrado = ReporteEncontrado(
        DateTime.now().subtract(Duration(days: 1)),
        Lugar(-36.83200,-73.03420,10),
        Campus.chillan,
        "TNE 2025",
        Etiqueta.documento,
        "testingID",
        null,
        null,
        "12345678",
        "correo@udec.cl",
        DateTime.now()
      );

      ReportsHandler().addReportEncontrado(reporteEncontrado);

      expect(ReportsHandler().getAllReportesPerdidos().length, greaterThan(0));
      expect(ReportsHandler().getAllReportesEncontrados().length, greaterThan(0));
      expect(ReportsHandler().getAllCoincidencias().length, greaterThan(0));

      int nivelCoincidencia = await ReportsHandler().getAllCoincidencias()[0].getNivelCoincidencia();

      expect(nivelCoincidencia, greaterThan(75));
    });
  });
}
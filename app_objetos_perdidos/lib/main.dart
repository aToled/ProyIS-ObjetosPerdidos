import 'package:app_objetos_perdidos/pages/api_testing_page.dart';
import 'package:app_objetos_perdidos/pages/home_admin_page.dart';
import 'package:app_objetos_perdidos/pages/home_page.dart';
import 'package:app_objetos_perdidos/pages/list_coincidencias_page.dart';
import 'package:app_objetos_perdidos/pages/list_reports_encontrados_admin_page.dart';
import 'package:app_objetos_perdidos/pages/login_page.dart';
import 'package:app_objetos_perdidos/pages/map_page.dart';
import 'package:app_objetos_perdidos/pages/list_reports_perdidos_admin_page.dart';
import 'package:app_objetos_perdidos/utils/coincidencia_lugar.dart';
import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/coincidencia.dart';
import 'package:app_objetos_perdidos/utils/coincidencia_lugar.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
  
  // Loading .env file
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Reportar objeto perdido",
      initialRoute: "/",
      locale: const Locale('es', 'ES'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
        useMaterial3: true,
      ),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case "/":
                return const LoginPage();
              case "/home":
              return const HomePage();
              case "/map":
                return const ReportMapScreen();
              case "/listReportesPerdidosAdmin":
                return const ListaReportesPerdidosAdmin();
              case "/admin_home":
                return const HomeAdminPage();
              case "/listReportesEncontradosAdmin":
                return const ListReportsEncontradosAdminPage();
              case "/listCoincidencias":
                return const ListCoincidenciasPage();
              case "/apiTesting":
                return const ApiTestingPage();
    
              default:
                return const Scaffold(
                  body: Center(child: Text("Page not found", style: TextStyle(fontSize: 25.0),)),
                );
            }
          }
        );
      }
    );
  }
}
import 'package:app_objetos_perdidos/pages/home_admin_page.dart';
import 'package:app_objetos_perdidos/pages/home_page.dart';
import 'package:app_objetos_perdidos/pages/list_reports_encontrados_admin_page.dart';
import 'package:app_objetos_perdidos/pages/login_page.dart';
import 'package:app_objetos_perdidos/pages/report_found_item.dart';
import 'package:app_objetos_perdidos/pages/report_lost_item_page.dart';
import 'package:app_objetos_perdidos/pages/map_page.dart';
import 'package:app_objetos_perdidos/pages/list_reports_perdidos_admin_page.dart';
import 'package:app_objetos_perdidos/pages/report_details_page.dart';
import 'package:app_objetos_perdidos/utils/adapadotr.dart';
import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:app_objetos_perdidos/utils/etiqueta.dart';
import 'package:app_objetos_perdidos/utils/lugar.dart';
import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();
await Hive.initFlutter();

  Hive.registerAdapter(ReportePerdidoAdapter());
  Hive.registerAdapter(ReporteEncontradoAdapter());
  Hive.registerAdapter(LugarAdapter());
  Hive.registerAdapter(CampusAdapter());
  Hive.registerAdapter(EtiquetaAdapter());
  //Hive.registerAdapter(InterceptorAdapter());
 // await Hive.deleteBoxFromDisk('reportesPerdidos');

 await Hive.openBox<ReporteEncontrado>('reportesEncontrados');
await Hive.openBox<ReportePerdido>('reportesPerdidos');

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Reportar objeto perdido",
      initialRoute: "/",
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
                return const listaReportesPerdidosAdmin();
              case "/reportDetails":
                return const ReportDetailsPage();
              case "/admin_home":
              return const HomeAdminPage();
              case "/listReportesEncontradosAdmin":
              return const ListReportsEncontradosAdminPage();
    
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
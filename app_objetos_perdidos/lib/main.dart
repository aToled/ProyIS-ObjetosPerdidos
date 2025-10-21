import 'package:app_objetos_perdidos/pages/home_page.dart';
import 'package:app_objetos_perdidos/pages/login_page.dart';
import 'package:app_objetos_perdidos/pages/report_lost_item_page.dart';
import 'package:app_objetos_perdidos/pages/test_page.dart';
import 'package:flutter/material.dart';

void main() {
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
              case "/reportLostItem":
                return const ReportLostItemPage();
              case "/test":
                return const ReportMapScreen();
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
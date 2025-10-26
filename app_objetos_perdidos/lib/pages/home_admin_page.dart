import 'package:app_objetos_perdidos/pages/report_found_item.dart';
import 'package:app_objetos_perdidos/utils/administrador.dart';
import 'package:flutter/material.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {


 late Administrador admin;
   @override
   void initState() {
    super.initState();
     admin = Administrador(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.grey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {
          
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReportFoundItemPage(
                        admin: admin,
                      ),
                    ),
                  );
              }, child: const Text("Reportar objeto encontrado")),
              
              ElevatedButton(onPressed: () {
                Navigator.of(context).pushNamed("/listReportesPerdidosAdmin", arguments: admin);
              }, child: const Text("Ver lista de reportes de objetos perdidos")),
              
              ElevatedButton(onPressed: () {
                Navigator.of(context).pushNamed("/listReportesEncontradosAdmin", arguments: admin);
              }, child: const Text("Ver lista de reportes de objetos encontrados")),
            ],
          ),
        ),
      ) ,
      
    );
  }
}
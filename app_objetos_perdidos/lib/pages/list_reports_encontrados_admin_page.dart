import 'package:app_objetos_perdidos/pages/report_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_objetos_perdidos/utils/administrador.dart';

class ListReportsEncontradosAdminPage extends StatefulWidget {
  const ListReportsEncontradosAdminPage({super.key});

  @override
  State<ListReportsEncontradosAdminPage> createState() => _ListReportsEncontradosAdminPage();
}

class _ListReportsEncontradosAdminPage extends State<ListReportsEncontradosAdminPage> {
  
  @override
  Widget build(BuildContext context) {
    final admin = ModalRoute.of(context)!.settings.arguments as Administrador;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de reportes encontrados'),
      ),
      body: CupertinoScrollbar(
        child: ListView.builder(
         
          itemCount: admin.getReportesEncontrados().length,
          itemBuilder: (context, index) {

            final reporte = admin.getReportesEncontrados()[index];
            return GestureDetector(
              onTap: () {
               Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReportDetailsPage(
                        usuario: admin,
                        reporte: reporte,
                      ),
                    ),
                  );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8), 
                ),
                child: ListTile(
                  subtitle: Text(reporte.descripcion),
                ),
              )
            );
          },
        ),
      ),
    );
  }
}
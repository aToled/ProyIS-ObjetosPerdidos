import 'package:app_objetos_perdidos/pages/report_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_objetos_perdidos/utils/administrador.dart';

class listaReportesPerdidosAdmin extends StatefulWidget {
  const listaReportesPerdidosAdmin({super.key});

  @override
  State<listaReportesPerdidosAdmin> createState() => _listaReportesPerdidosAdminState();
}

class _listaReportesPerdidosAdminState extends State<listaReportesPerdidosAdmin> {
  
  @override
  Widget build(BuildContext context) {
    final admin = ModalRoute.of(context)!.settings.arguments as Administrador;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de reportes perdidos'),
      ),
      body: CupertinoScrollbar(
        child: ListView.builder(
         
          itemCount: admin.getReportesPerdidos().length,
          itemBuilder: (context, index) {

            final reporte = admin.getReportesPerdidos()[index];
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
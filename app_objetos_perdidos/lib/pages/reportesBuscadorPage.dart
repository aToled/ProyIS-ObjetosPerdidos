import 'package:app_objetos_perdidos/pages/report_details_page.dart';
import 'package:app_objetos_perdidos/utils/buscador.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportesBuscadorPage extends StatefulWidget {
  final Buscador buscador;
  const ReportesBuscadorPage({super.key, required this.buscador});

  @override
  State<ReportesBuscadorPage> createState() => _ReportesBuscadorPageState();
}

class _ReportesBuscadorPageState extends State<ReportesBuscadorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis reportes"),),
      body: CupertinoScrollbar(
        child: ListView.builder(
         
          itemCount: widget.buscador.getReportes().length,
          itemBuilder: (context, index) {

            final reporte = widget.buscador.getReportes()[index];
            return GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReportDetailsPage(
                        usuario: widget.buscador,
                        reporte: reporte,
                      ),
                    ),
                  );
                  if(mounted){
                    setState(() {
              
                    });
                  }
              },

              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8), 
                ),
                child: ListTile(
                  subtitle: Text(reporte.id),
                ),
              )
            );
          },
        ),
      ),
     
    );
  }
}
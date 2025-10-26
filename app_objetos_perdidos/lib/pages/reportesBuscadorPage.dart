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
      appBar: AppBar(),
      body: Container(
         color: Colors.blueGrey,
      child: CupertinoScrollbar(
        child: ListView.builder(
         
          itemCount: widget.buscador.getReportes().length,
          itemBuilder: (context, index) {

            final reporte = widget.buscador.getReportes()[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/reportDetails", arguments: reporte);
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
        
      ) ,
     
    );
  }
}
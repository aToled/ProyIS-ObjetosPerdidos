import 'package:app_objetos_perdidos/utils/coincidencia_lugar.dart';
import 'package:app_objetos_perdidos/utils/gemini_api_manager.dart';
import 'package:app_objetos_perdidos/utils/reporteEncontrado.dart';
import 'package:app_objetos_perdidos/utils/reportePerdido.dart';
import 'package:hive/hive.dart';
part 'coincidencia.g.dart';
@HiveType(typeId: 30)
class Coincidencia extends HiveObject{
  @HiveField(0)
  ReportePerdido reportePerdido;
  @HiveField(1)
  ReporteEncontrado reporteEncontrado;
  @HiveField(2)
   int nivelCoincidencia;
  Coincidencia(this.reporteEncontrado, this.reportePerdido, {this.nivelCoincidencia=-1})  {
    
  }
  Future<int> getNivelCoincidencia() async {
    //Si es que es distinto de 1, ya se calculó, por ende no pedimos una nueva solicitud a la api.
    if(nivelCoincidencia!=-1){
      return nivelCoincidencia;
    }
    double nivelCoincidenciaLugar=CoincidenciaLugar(reporteEncontrado.lugar, reportePerdido.lugar).getNivelCoincidencia();
     final prompt = '''
      Actúa como un sistema de coincidencia de objetos.
      Analiza semánticamente estas dos descripciones para ver si se refieren al mismo objeto físico.
      
      Objeto Perdido: "${reportePerdido.descripcion}"
      Objeto Encontrado: "${reporteEncontrado.descripcion}"
      
      Tu tarea: Retorna SOLAMENTE un número entero entre 0 y 100 que indique el porcentaje de similitud.
      Reglas estrictas:
      1. No escribas palabras.
      2. No uses el símbolo %.
      3. Si no hay similitud, responde 0.
      4. Solo devuelve el número.
    ''';

    int coincidenciaAPI=0;
     final response = await GeminiAPIManager().generateResponse(prompt);
    final textResponse = response.trim();
    
    final justNumbers = textResponse.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (justNumbers.isEmpty) {
      return -1;
    } else {
      coincidenciaAPI= int.parse(justNumbers);
      
    }

     nivelCoincidencia=(coincidenciaAPI*nivelCoincidenciaLugar).round();
     
     if(isInBox){
      save();
     }

    return nivelCoincidencia;
  }
  

}
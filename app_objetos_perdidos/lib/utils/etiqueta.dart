import 'package:hive/hive.dart';

part 'etiqueta.g.dart';

@HiveType(typeId: 3) 
enum Etiqueta {
  @HiveField(0)
  celular("Celular"),

  @HiveField(1)
  llaves("Llaves"),

  @HiveField(2)
  cartera("Cartera"),

  @HiveField(3)
  billetera("Billetera"),

  @HiveField(4)
  utiles("Útiles"),

  @HiveField(5)
  documento("Documento"),

  @HiveField(6)
  lentes("Llentes"),

  @HiveField(7)
  botella("Botella"),

  @HiveField(8)
  otro("Otro");

  final String visibleName;

  const Etiqueta(this.visibleName);
}
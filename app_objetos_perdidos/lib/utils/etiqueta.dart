import 'package:hive/hive.dart';

part 'etiqueta.g.dart';

@HiveType(typeId: 3) 
enum Etiqueta {
  @HiveField(0)
  celular,

  @HiveField(1)
  llaves,

  @HiveField(2)
  cartera,

  @HiveField(3)
  billetera,

  @HiveField(4)
  utiles,

  @HiveField(5)
  documento,

  @HiveField(6)
  lentes,

  @HiveField(7)
  botella,

  @HiveField(8)
  otro
}
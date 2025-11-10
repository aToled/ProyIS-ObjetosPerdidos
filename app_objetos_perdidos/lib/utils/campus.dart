import 'package:hive/hive.dart';
part 'campus.g.dart'; 

@HiveType(typeId: 2)
enum Campus {
  @HiveField(0)
  concepcion("Concepción"), 

  @HiveField(1)
  chillan("Chillán"),

  @HiveField(2)
  losAngeles("Los Ángeles");

  final String visibleName;

  const Campus(this.visibleName);
}
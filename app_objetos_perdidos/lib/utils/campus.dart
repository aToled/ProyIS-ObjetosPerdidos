import 'package:hive/hive.dart';
part 'campus.g.dart'; 

@HiveType(typeId: 2)
enum Campus {
  @HiveField(0)
  concepcion, 

  @HiveField(1)
  chillan,

  @HiveField(2)
  losAngeles
}
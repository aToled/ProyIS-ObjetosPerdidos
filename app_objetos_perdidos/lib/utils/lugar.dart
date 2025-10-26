import 'package:hive/hive.dart';
part 'lugar.g.dart';

@HiveType(typeId: 1)
class Lugar {
  @HiveField(0)
  double latitud;
  
  @HiveField(1)
  double longitud;
  
  @HiveField(2)
  int radio;

  Lugar(this.latitud, this.longitud, this.radio);

  bool isNull() {
    return (latitud == 0 && longitud == 0);
  }
}
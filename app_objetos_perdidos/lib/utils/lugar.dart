class Lugar {
  double latitud;
  double longitud;
  int radio;

  Lugar(this.latitud, this.longitud, this.radio);

  factory Lugar.fromJson(Map<String, dynamic> json) {
    return Lugar(json["latitud"], json["longitud"], json["radio"]);
  }

  Map<String, dynamic> toJson() => {
    "latitud": latitud,
    "longitud": longitud,
    "radio": radio,
  };

  bool isNull() {
    return latitud == 0 && longitud == 0;
  }
}
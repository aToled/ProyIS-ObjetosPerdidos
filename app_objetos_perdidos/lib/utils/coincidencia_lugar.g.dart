// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coincidencia_lugar.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoincidenciaLugarAdapter extends TypeAdapter<CoincidenciaLugar> {
  @override
  final int typeId = 31;

  @override
  CoincidenciaLugar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoincidenciaLugar(
      fields[0] as Lugar,
      fields[1] as Lugar,
      nivel_coincidencia: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CoincidenciaLugar obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lugarReporteEncontrado)
      ..writeByte(1)
      ..write(obj.lugarReportePerdido)
      ..writeByte(2)
      ..write(obj.nivel_coincidencia);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoincidenciaLugarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

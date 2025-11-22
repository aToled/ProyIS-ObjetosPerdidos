// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coincidencia.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoincidenciaAdapter extends TypeAdapter<Coincidencia> {
  @override
  final int typeId = 30;

  @override
  Coincidencia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Coincidencia(
      fields[1] as ReporteEncontrado,
      fields[0] as ReportePerdido,
      nivelCoincidencia: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Coincidencia obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.reportePerdido)
      ..writeByte(1)
      ..write(obj.reporteEncontrado)
      ..writeByte(2)
      ..write(obj.nivelCoincidencia);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoincidenciaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

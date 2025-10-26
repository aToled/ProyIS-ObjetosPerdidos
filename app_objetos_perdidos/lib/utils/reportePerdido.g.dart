// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reportePerdido.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportePerdidoAdapter extends TypeAdapter<ReportePerdido> {
  @override
  final int typeId = 10;

  @override
  ReportePerdido read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportePerdido(
      fields[1] as DateTime,
      fields[2] as Lugar,
      fields[3] as Campus,
      fields[4] as String,
      fields[5] as Etiqueta,
      fields[6] as String,
      fields[11] as String,
      fields[12] as String,
    )
      ..encontrado = fields[10] as bool
      ..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, ReportePerdido obj) {
    writer
      ..writeByte(10)
      ..writeByte(10)
      ..write(obj.encontrado)
      ..writeByte(11)
      ..write(obj.numTel)
      ..writeByte(12)
      ..write(obj.correo)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fecha)
      ..writeByte(2)
      ..write(obj.lugar)
      ..writeByte(3)
      ..write(obj.campus)
      ..writeByte(4)
      ..write(obj.descripcion)
      ..writeByte(5)
      ..write(obj.etiqueta)
      ..writeByte(6)
      ..write(obj.creadorId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportePerdidoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

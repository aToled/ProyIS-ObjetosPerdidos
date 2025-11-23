// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reporteEncontrado.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReporteEncontradoAdapter extends TypeAdapter<ReporteEncontrado> {
  @override
  final int typeId = 20;

  @override
  ReporteEncontrado read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReporteEncontrado(
      fields[1] as DateTime,
      fields[2] as Lugar,
      fields[3] as Campus,
      fields[4] as String,
      fields[5] as Etiqueta,
      fields[6] as String,
      fields[7] as String?,
      fields[20] as String,
      fields[21] as String,
      fields[22] as DateTime,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, ReporteEncontrado obj) {
    writer
      ..writeByte(11)
      ..writeByte(20)
      ..write(obj.ubicacionCustodia)
      ..writeByte(21)
      ..write(obj.correoCustodia)
      ..writeByte(22)
      ..write(obj.fechaEncuentro)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fechaCreacion)
      ..writeByte(2)
      ..write(obj.lugar)
      ..writeByte(3)
      ..write(obj.campus)
      ..writeByte(4)
      ..write(obj.descripcion)
      ..writeByte(5)
      ..write(obj.etiqueta)
      ..writeByte(6)
      ..write(obj.creadorId)
      ..writeByte(7)
      ..write(obj.imagenRuta);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReporteEncontradoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

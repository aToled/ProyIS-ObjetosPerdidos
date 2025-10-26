// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lugar.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LugarAdapter extends TypeAdapter<Lugar> {
  @override
  final int typeId = 1;

  @override
  Lugar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lugar(
      fields[0] as double,
      fields[1] as double,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Lugar obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.latitud)
      ..writeByte(1)
      ..write(obj.longitud)
      ..writeByte(2)
      ..write(obj.radio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LugarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

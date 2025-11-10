// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campus.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CampusAdapter extends TypeAdapter<Campus> {
  @override
  final int typeId = 2;

  @override
  Campus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Campus.concepcion;
      case 1:
        return Campus.chillan;
      case 2:
        return Campus.losAngeles;
      default:
        return Campus.concepcion;
    }
  }

  @override
  void write(BinaryWriter writer, Campus obj) {
    switch (obj) {
      case Campus.concepcion:
        writer.writeByte(0);
        break;
      case Campus.chillan:
        writer.writeByte(1);
        break;
      case Campus.losAngeles:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CampusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
